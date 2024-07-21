from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import numpy as np
import joblib

# Load the trained model (replace 'model.joblib' with your actual model file)
model = joblib.load("Nigerian_Car_Prices_model.joblib")

# Define the input data schema using Pydantic
class PredictRequest(BaseModel):
    tv: float
    radio: float
    newspaper: float

app = FastAPI()

@app.post('/predict')
def predict(request: PredictRequest):
    # Extract data from request
    data = np.array([[request.tv, request.radio, request.newspaper]])
    
    # Make prediction
    prediction = model.predict(data)
    
    return {"prediction": prediction[0]}
