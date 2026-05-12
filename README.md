# Micro-PoC ML Pipeline

A fully containerized **end-to-end ML pipeline** for manufacturing equipment failure prediction, orchestrated with **Docker Compose**.

## Architecture

```
┌─────────────────────────────────────────────────┐
│               Docker Compose Network             │
│                                                 │
│  ┌──────────────┐     ┌──────────────────────┐  │
│  │   MLflow     │◄────│      Trainer         │  │
│  │  :5000       │     │  XGBoost + sklearn   │  │
│  │  (Tracking)  │     │  logs metrics/model  │  │
│  └──────────────┘     └──────────┬───────────┘  │
│                                  │ model_store   │
│                        ┌─────────▼───────────┐  │
│                        │   Inference API     │  │
│                        │   FastAPI  :8000    │  │
│                        │   /predict endpoint │  │
│                        └─────────────────────┘  │
└─────────────────────────────────────────────────┘
```

## Services

| Service | Image | Port | Role |
|---|---|---|---|
| `mlflow` | `ghcr.io/mlflow/mlflow` | 5000 | Experiment tracking + model registry |
| `trainer` | Custom (`Dockerfile.train`) | — | XGBoost training, logs to MLflow |
| `api` | Custom (`Dockerfile.api`) | 8000 | FastAPI inference server |

## Project Structure

```
micro-poc-pipeline/
├── Dockerfile.train        # Trainer container
├── Dockerfile.api          # Inference API container
├── docker-compose.yml      # Orchestration
├── train/
│   ├── train.py            # XGBoost + MLflow training script
│   └── requirements.txt
├── api/
│   ├── main.py             # FastAPI prediction service
│   └── requirements.txt
├── data/
│   └── sensor_data.csv     # Manufacturing sensor dataset (500 samples)
└── README.md
```

## Quick Start

```bash
# Clone the repo
git clone https://github.com/Udiation/micro-poc-pipeline.git
cd micro-poc-pipeline

# Build and run all services
docker-compose up --build
```

- MLflow UI → http://localhost:5000
- Prediction API → http://localhost:8000
- Swagger Docs → http://localhost:8000/docs

## Example Prediction

```bash
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "temperature": 88.5,
    "pressure": 33.2,
    "vibration": 0.72,
    "runtime_hours": 4200,
    "load_factor": 0.91
  }'
```

**Response:**
```json
{
  "prediction": 1,
  "label": "FAILURE LIKELY",
  "failure_probability": 0.8341,
  "status": "high_risk"
}
```

## Dataset

Synthetic manufacturing telemetry — 500 samples, 5 features:
`temperature`, `pressure`, `vibration`, `runtime_hours`, `load_factor` → binary `failure` label.

## Tech Stack

| Layer | Tool |
|---|---|
| Containerization | Docker + Docker Compose |
| ML Model | XGBoost |
| Experiment Tracking | MLflow |
| Inference API | FastAPI + Uvicorn |
| Data Processing | pandas, scikit-learn |
| Inter-service Volumes | Docker named volumes |

## Author

**Udit Narayan** — M.Tech AI, IIT Patna  
[GitHub](https://github.com/Udiation) | [LinkedIn](https://linkedin.com/in/udit-narayan-a98542321)
