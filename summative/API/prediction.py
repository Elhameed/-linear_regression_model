from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import pandas as pd

# Load the trained model and columns
model, one_hot_columns = joblib.load("Nigerian_Car_Prices_model.joblib")

app = FastAPI()

# Define the root endpoint
@app.get("/")
def read_root():
    return {"message": "Welcome to the Car Price Prediction API!"}

# Define the input data model
class CarFeatures(BaseModel):
    Year_of_manufacture: int
    Condition: str
    Mileage: float
    Engine_Size: float
    Fuel: str
    Transmission: str
    Make: str
    Build: str

# Define the mapping for categorical variables
def preprocess_input(data):
    # Create a dictionary to hold the input features
    input_data = {
        'Year of manufacture': data.Year_of_manufacture,
        'Condition': data.Condition,
        'Mileage': data.Mileage,
        'Engine Size': data.Engine_Size,
        'Fuel': data.Fuel,
        'Transmission': data.Transmission,
        'Make': data.Make,
        'Build': data.Build
    }
    
    # Convert to DataFrame
    df = pd.DataFrame([input_data])
    
    # One-hot encode categorical variables
    df_encoded = pd.get_dummies(df, columns=['Make', 'Condition', 'Fuel', 'Transmission', 'Build'], drop_first=True)
    
    # Ensure all expected columns are present
    for col in one_hot_columns:
        if col not in df_encoded.columns:
            df_encoded[col] = 0
    
    df_encoded = df_encoded[one_hot_columns]
    
    return df_encoded

@app.post("/predict")
def predict(car: CarFeatures):
    try:
        # Preprocess the input data
        input_data = preprocess_input(car)
        
        # Make a prediction
        prediction = model.predict(input_data)
        
        return {"predicted_price": prediction[0]}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
