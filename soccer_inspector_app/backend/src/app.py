# Instalar dependências (executar coamando na pasta backend): pip install fastapi uvicorn joblib pandas scikit-learn 
# Executar API (executar coamdo na pasta backend/src): uvicorn app:app --reload  

from fastapi import FastAPI
from pydantic import BaseModel
import pandas as pd
import joblib

# ====================================
# Carregar os modelos
# ====================================

mlp = joblib.load("models/mlp_model.pkl")
kmeans = joblib.load("models/kmeans_model.pkl")
isolation_models = joblib.load("models/isolation_models.pkl")
scaler = joblib.load("models/scaler.pkl")
label_encoder = joblib.load("models/label_encoder.pkl")

# ====================================
# Criar API
# ====================================

app = FastAPI(title="Football AI API")

# ====================================
# Modelo dos dados recebidos
# ====================================

class Jogador(BaseModel):

    idade: float
    gols: float
    assistencias: float
    minutos_jogados: float
    nota_media: float

# ====================================
# Rota inicial
# ====================================

@app.get("/")
def home():

    return {
        "mensagem": "API da IA funcionando!"
    }

# ====================================
# Previsão
# ====================================

@app.post("/prever")

def prever(jogador: Jogador):

    dados = pd.DataFrame([{

        "idade": jogador.idade,
        "gols": jogador.gols,
        "assistencias": jogador.assistencias,
        "minutos_jogados": jogador.minutos_jogados,
        "nota_media": jogador.nota_media

    }])

    # Normalização
    dados_escalados = scaler.transform(dados)

    # Cluster
    cluster = int(kmeans.predict(dados_escalados)[0])

    # Anomalia
    anomalia = int(isolation_models.predict(dados_escalados)[0])

    # Rede Neural
    previsao = mlp.predict(dados_escalados)

    resultado = label_encoder.inverse_transform(previsao)

    return {

        "cluster": cluster,
        "anomalia": anomalia,
        "avaliacao": str(resultado[0])

    }