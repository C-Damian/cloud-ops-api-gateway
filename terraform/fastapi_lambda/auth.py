from fastapi import Depends, HTTPException, status
from fastapi.security import APIKeyHeader
from dotenv import load_dotenv
import os

load_dotenv()  # Load environment variables from .env
API_KEY = os.getenv("API_KEY")

api_key_header = APIKeyHeader(name="X-API-Key", auto_error=True)

async def get_api_key(api_key: str = Depends(api_key_header)):
  if api_key == API_KEY:
        return api_key
  raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "X-API-Key"},
    )