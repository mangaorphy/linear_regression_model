from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
from typing import Literal
import joblib
import numpy as np
import os

app = FastAPI(title="Nitrogen Prediction API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"], 
    allow_headers=["*"],
)


# Load models at startup
def load_models():
    try:

        # Get the directory where prediction.py is located
        current_dir = os.path.dirname(os.path.abspath(__file__))
        
        # Go up one level to summative folder, then into linear_regression
        model_dir = os.path.join(current_dir, '..', 'linear_regression')

        model = joblib.load(os.path.join(model_dir, 'nitrogen_model.pkl'))
        scaler = joblib.load(os.path.join(model_dir, 'feature_scaler.pkl'))
        label_mapping = joblib.load(os.path.join(model_dir, 'label_mapping.pkl'))
        return model, scaler, label_mapping
    except Exception as e:
        raise RuntimeError(f"Error loading models: {str(e)}")

model, scaler, label_mapping = load_models()

# Input data model
class PredictionRequest(BaseModel):
    P: float = Field(..., ge=0, le=150, description="Phosphorus (P) in mg/kg (0-150)")
    K: float = Field(..., ge=0, le=200, description="Potassium (K) in mg/kg (0-200)")
    temperature: float = Field(..., ge=-20, le=50, description="Temperature in °C (-20 to 50)")
    humidity: float = Field(..., ge=0, le=100, description="Humidity in % (0-100)")
    ph: float = Field(..., ge=0, le=14, description="Soil pH (0-14)")
    rainfall: float = Field(..., ge=0, le=500, description="Rainfall in mm (0-500)")
    crop_type: str

    class Config:
        json_schema_extra = {
            "example": {
                "P": 42.0,
                "K": 43.0,
                "temperature": 20.88,
                "humidity": 82.0,
                "ph": 6.5,
                "rainfall": 202.94,
                "crop_type": "rice"
            }
        }

@app.post("/predict")
async def predict_nitrogen(request: PredictionRequest):
    try:
        # Convert crop type to encoded value
        encoded_label = label_mapping.get(request.crop_type.lower())
        if encoded_label is None:
            available_crops = list(label_mapping.keys())
            raise HTTPException(
                status_code=400,
                detail=f"Unknown crop type. Available options: {available_crops}"
            )

        # Prepare feature array
        features = np.array([
            request.P,
            request.K,
            request.temperature,
            request.humidity,
            request.ph,
            request.rainfall,
            encoded_label
        ]).reshape(1, -1)

        # Scale features
        scaled_features = scaler.transform(features)

        # Predict
        prediction = model.predict(scaled_features)
        
        return {
            "predicted_nitrogen": round(float(prediction[0]), 2),
            "units": "mg/kg",
            "crop_type": request.crop_type
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/crop-types")
async def get_crop_types():
    """Return list of supported crop types"""
    return {"crop_types": list(label_mapping.keys())}

@app.get("/")
async def health_check():
    return {"status": "healthy"}