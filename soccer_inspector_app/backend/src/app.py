# Instalar Python:
# winget install Python.Python.3.13

# Instalar dependências:
# pip install fastapi uvicorn joblib pandas scikit-learn

# Executar API:
# uvicorn app:app --reload

from fastapi import FastAPI
from pydantic import BaseModel
import pandas as pd
import joblib
from fastapi.middleware.cors import CORSMiddleware
# ==========================================
# CARREGAMENTO DOS MODELOS
# ==========================================

package = joblib.load("models/model_package.pkl")

mlp = package["mlp"]
kmeans = package["kmeans"]
isolation_models = package["isolation_models"]
scaler = package["scaler"]
label_encoder = package["label_encoder"]
model_features = package["features"]

# ==========================================
# FASTAPI
# ==========================================

app = FastAPI(
    title="Soccer Inspector AI",
    version="2.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # para testes
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# ==========================================
# INPUT
# ==========================================

class Jogador(BaseModel):

    athlete_id: int

    distance: float
    metres_per_minute: float
    duration: float

    high_intensity_running: float
    high_intensity_events: float

    sprint_distance: float
    sprints: float

    raw_top_speed: float
    top_speed: float
    avg_speed: float

    accelerations: float
    decelerations: float

    workload: float
    workload_volume: float
    workload_intensity: float


# ==========================================
# HOME
# ==========================================

@app.get("/")
def home():

    return {
        "status": "API funcionando"
    }


# ==========================================
# PREVISÃO
# ==========================================

@app.post("/prever")
def prever(jogador: Jogador):

    try:

        # ==========================
        # FEATURES FÍSICAS
        # ==========================

        entrada = pd.DataFrame([{

            "Distance (m)": jogador.distance,
            "Metres per Minute (m)": jogador.metres_per_minute,
            "Duration (mins)": jogador.duration,

            "High Intensity Running (m)": jogador.high_intensity_running,
            "No. of High Intensity Events": jogador.high_intensity_events,

            "Sprint Distance (m)": jogador.sprint_distance,
            "No. of Sprints": jogador.sprints,

            "Raw Top Speed (kph)": jogador.raw_top_speed,
            "Top Speed (kph)": jogador.top_speed,
            "Avg Speed (kph)": jogador.avg_speed,

            "Accelerations": jogador.accelerations,
            "Decelerations": jogador.decelerations,

            "Workload": jogador.workload,
            "Workload Volume": jogador.workload_volume,
            "Workload Intensity": jogador.workload_intensity

        }])

        # ==========================
        # SCALER (15 FEATURES)
        # ==========================

        entrada_escalada = scaler.transform(
            entrada
        )

        entrada_scaled_df = pd.DataFrame(
            entrada_escalada,
            columns=entrada.columns
        )

        # ==========================
        # KMEANS (15 FEATURES)
        # ==========================

        cluster = int(
            kmeans.predict(
                entrada_escalada
            )[0]
        )

        entrada_scaled_df["Cluster_0"] = (
            1 if cluster == 0 else 0
        )

        entrada_scaled_df["Cluster_1"] = (
            1 if cluster == 1 else 0
        )

        entrada_scaled_df["Cluster_2"] = (
            1 if cluster == 2 else 0
        )

        # ==========================
        # ISOLATION FOREST
        # ==========================

        anomaly = 0

        if jogador.athlete_id in isolation_models:

            modelo_iso = isolation_models[
                jogador.athlete_id
            ]

            anomaly_raw = int(
                modelo_iso.predict(
                    entrada_escalada
                )[0]
            )

            anomaly = (
                1 if anomaly_raw == -1 else 0
            )

        entrada_scaled_df["Anomaly_Flag"] = anomaly

        # ==========================
        # GARANTIA DAS FEATURES
        # ==========================

        for col in model_features:

            if col not in entrada_scaled_df.columns:

                entrada_scaled_df[col] = 0

        entrada_final = entrada_scaled_df[
            model_features
        ]

        # ==========================
        # MLP (19 FEATURES)
        # ==========================

        pred = mlp.predict(
            entrada_final
        )

        pred_label = (
            label_encoder
            .inverse_transform(pred)
        )

  # ==========================
        # ANÁLISE TEXTUAL
        # ==========================

        analise = ""

        classificacao = str(pred_label[0])

        if classificacao == "Declining":
            analise += (
                "O atleta apresenta sinais de queda de desempenho físico em relação ao padrão esperado. "
            )

        elif classificacao == "Improving":
            analise += (
                "O atleta demonstra evolução de desempenho e apresenta indicadores físicos positivos. "
            )

        elif classificacao == "Stable":
            analise += (
                "O atleta mantém um desempenho consistente e dentro dos padrões esperados. "
            )

        else:
            analise += (
                f"O atleta foi classificado como {classificacao}. "
            )

        if anomaly == 1:
            analise += (
                "Os dados atuais apresentam comportamento fora do histórico do atleta, indicando uma possível anomalia."
            )
        else:
            analise += (
                "Os dados analisados estão dentro do comportamento histórico esperado."
            )

        if cluster == 0:
            nome_cluster = "Alta Intensidade"

        elif cluster == 1:
            nome_cluster = "Desempenho Equilibrado"

        else:
            nome_cluster = "Baixa Intensidade"

        analise += (
            f" O jogador pertence ao grupo '{nome_cluster}'."
        )

        # ==========================
        # RETORNO
        # ==========================

        return {

            "athlete_id": jogador.athlete_id,

            "cluster": cluster,

            "cluster_name": nome_cluster,

            "anomaly": anomaly,

            "prediction": classificacao,

            "analysis": analise

        }

        # ==========================
        # RETORNO
        # ==========================

        return {

            "athlete_id": jogador.athlete_id,

            "cluster": cluster,

            "anomaly": anomaly,

            "prediction": str(
                pred_label[0]
            )

        }

    except Exception as e:

        return {

            "erro": str(e)

        }