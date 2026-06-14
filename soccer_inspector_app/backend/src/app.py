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

# ===========================================
# Carregamento dos modelos
# ===========================================

mlp = joblib.load("models/mlp_model.pkl")
kmeans = joblib.load("models/kmeans_model.pkl")
isolation_models = joblib.load("models/isolation_models.pkl")
scaler = joblib.load("models/scaler.pkl")
label_encoder = joblib.load("models/label_encoder.pkl")

# ===========================================
# API
# ===========================================

app = FastAPI(
    title="Soccer Inspector AI",
    version="1.0"
)

# ===========================================
# Dados recebidos do aplicativo
# ===========================================

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


# ===========================================
# Página inicial
# ===========================================

@app.get("/")
def home():

    return {
        "status": "API funcionando"
    }


# ===========================================
# Previsão
# ===========================================

@app.post("/prever")
def prever(jogador: Jogador):

    try:

        # -------------------------
        # Entrada
        # -------------------------

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

        # -------------------------
        # Normalização
        # -------------------------

        entrada_escalada = scaler.transform(
            entrada
        )

        # -------------------------
        # Cluster
        # -------------------------

        cluster = int(
            kmeans.predict(
                entrada_escalada
            )[0]
        )

        # -------------------------
        # Isolation Forest
        # -------------------------

        anomaly = 1

        if jogador.athlete_id in isolation_models:

            modelo_iso = isolation_models[
                jogador.athlete_id
            ]

            anomaly = int(
                modelo_iso.predict(
                    entrada_escalada
                )[0]
            )

        # -------------------------
        # Preparação para o MLP
        # -------------------------

        entrada_final = pd.DataFrame(
            entrada_escalada,
            columns=entrada.columns
        )

        # One Hot Encoding do Cluster

        entrada_final["Cluster_0"] = (
            1 if cluster == 0 else 0
        )

        entrada_final["Cluster_1"] = (
            1 if cluster == 1 else 0
        )

        entrada_final["Cluster_2"] = (
            1 if cluster == 2 else 0
        )

        # Isolation Forest

        entrada_final["Anomaly"] = anomaly

        # Ordem das colunas do treinamento

        entrada_final = entrada_final[

            [

                "Distance (m)",
                "Metres per Minute (m)",
                "Duration (mins)",

                "High Intensity Running (m)",
                "No. of High Intensity Events",

                "Sprint Distance (m)",
                "No. of Sprints",

                "Raw Top Speed (kph)",
                "Top Speed (kph)",
                "Avg Speed (kph)",

                "Accelerations",
                "Decelerations",

                "Workload",
                "Workload Volume",
                "Workload Intensity",

                "Cluster_0",
                "Cluster_1",
                "Cluster_2",

                "Anomaly"

            ]

        ]

        # -------------------------
        # Previsão
        # -------------------------

        resultado = mlp.predict(
            entrada_final
        )

        resultado = label_encoder.inverse_transform(
            resultado
        )

        # -------------------------
        # Retorno
        # -------------------------

        return {

            "athlete_id": jogador.athlete_id,
            "cluster": cluster,
            "anomaly": anomaly,
            "prediction": str(
                resultado[0]
            )

        }

    except Exception as e:

        return {

            "erro": str(e)

        }