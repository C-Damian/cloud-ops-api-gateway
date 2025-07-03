from fastapi import FastAPI
import datetime
from pydantic import BaseModel
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