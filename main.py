from fastapi import FastAPI
import datetime
from pydantic import BaseModel
import boto3
import json

app = FastAPI()
date = datetime.datetime.now()

class HealthResponse(BaseModel):
    service: str
    status: str
    version: str
    timestamp: str

@app.get("/")
def hi():
  return "Hello World!"

@app.get("/health", response_model=HealthResponse)
def health():
  return {
    "service": "cloud-ops-api-gateway",
    "status": "healthy", 
    "version": "1.0.0",
    "timestamp": str(date)
}

@app.get("/invoke")
def invoke():
    # configure client and response according to the settigns and naming conventions you're using for your lambda function in aws.
    client = boto3.client('lambda', region_name='us-east-1')
    response = client.invoke(FunctionName='hello', InvocationType='RequestResponse')
    
    # Decode the response payload
    payload = response['Payload'].read()
    result = json.loads(payload)
    
    return result