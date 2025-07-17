from fastapi import Depends, HTTPException, status
from fastapi.security import APIKeyHeader
from dotenv import load_dotenv
import os

try:
    from dotenv import load_dotenv
    load_dotenv() #will load the .env file if it exists locally
except ImportError:
    # dotenv not available in Lambda deployment - that's fine
    pass  # Load environment variables from .env

API_KEY = os.getenv("API_KEY")

#validate API key got loaded
if not API_KEY:
      raise ValueError("No API_KEY set for the application. Please set the environment variable.")

api_key_header = APIKeyHeader(name="X-API-Key", auto_error=True)

async def get_api_key(api_key: str = Depends(api_key_header)):
  if api_key == API_KEY:
        return api_key
  raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "X-API-Key"},
    )