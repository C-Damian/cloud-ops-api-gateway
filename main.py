from fastapi import FastAPI, Depends
import datetime
from pydantic import BaseModel
import boto3
import json
from auth import get_api_key
from typing import Optional

app = FastAPI()
date = datetime.datetime.now()

class HealthResponse(BaseModel):
    service: str
    status: str
    version: str
    timestamp: str

class SQSMessage(BaseModel):
    message: str
    user_id: Optional[str] = None
    priority: Optional[str] = "normal"


@app.get("/")
def hi():
  return "Hello World!"

@app.get("/protected-data/")
async def read_protected_data(api_key: str = Depends(get_api_key)):
  return {"Secret Message": f"Hi, your secret key is {api_key}"}

@app.get("/API/health", response_model=HealthResponse)
def health():
  return {
    "service": "cloud-ops-api-gateway",
    "status": "healthy", 
    "version": "1.0.0",
    "timestamp": str(date)
}

@app.get("/API/lambda/{age}") #age var to pass arg into API
async def call_lambda(age: int, api_key: str = Depends(get_api_key)): 
    # configure client and response according to the settigns and naming conventions you're using for your lambda function in aws.
    client = boto3.client('lambda', region_name='us-east-1')

    #pass data to lambda
    payload = {"age": age}

    response = client.invoke(
       FunctionName='hello', 
       InvocationType='RequestResponse',
       Payload=json.dumps(payload)
       )
    
    # Decode the response payload
    payload = response['Payload'].read()
    result = json.loads(payload)
    
    return result

@app.post("/API/SQS/send-message-to-sqs")
async def send_message(message_data: SQSMessage, api_key: str = Depends(get_api_key)):
    # Create SQS client
    client = boto3.client('sqs', region_name='us-east-1')
    
    # Send message to your specific queue
    response = client.send_message(
        QueueUrl='https://sqs.us-east-1.amazonaws.com/992382714131/fastapi-test-queue',
        MessageBody=message_data.message
    )
    
    # Return confirmation with message ID
    return {
        "message_id": response['MessageId'], 
        "status": "sent",
        "queue": "fastapi-test-queue"
    }

@app.get("/API/Logs")
async def cloud_watch(
  logGroupName: str,
  api_key: str = Depends(get_api_key)
  ):
  # Create cloudwatch client
  client = boto3.client('logs', region_name='us-east-1')
  # Get logs
  response = client.filter_log_events(logGroupName=logGroupName)
  return response