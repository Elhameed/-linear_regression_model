# Car Price Prediction App

This Flutter app predicts car prices using a machine learning model hosted on a FastAPI server.

## API Endpoint

The API endpoint for prediction is publicly available at: https://car-price-model.onrender.com/predict
This API predicts wine quality based on multiple informations e.g Year of Manufacture, Condition, Build, Mileage etc. 

You can test the API using Postman. Create a POST request, enter the URL above. In the body, select raw and JSON and enter the JSON object: {
  "Year_of_manufacture": 2010,
  "Condition": "Nigerian Used",
  "Mileage": 50000,
  "Engine_Size": 2000,
  "Fuel": "Petrol",
  "Transmission": "Automatic",
  "Make": "Toyota",
  "Build": "SUV"
}

The response should be: 
{
    "predicted_price":27191661.37540102
}
