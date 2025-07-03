****Cloud Ops API Gateway****
****
A FastAPI-based gateway in its early development stage for automating the management of cloud operations and infrastructure tasks, this is for personal practice with FastAPI and integration with other DevOps practices.

**Current state:** it's a basic FastAPI app with a hello world endpoint with plans to become a hub for cloud operations integrated with AWS.

****How to Run It Locally:****
****
**Prerequisites:** Python 3.x required
- Clone this repo
- Create virtual environment:
  4mac: python3 -m venv venv
- Install dependencies with pip:
  pip install fastapi uvicorn boto3 python-dotenv
- Run with uvicorn command: uvicorn main:app  --reload
- What URL to visit to see it working: 127.0.0.1:8000, you can also go to /docs for additional api documentation and an interactive testing env.

**Enviroment Setup:**
- You will eventually need aws credentials
<<<<<<< HEAD
- .env file will be added later
=======
- add a .env file to secure your aws secret keys
>>>>>>> 7f2523c (Added health endpoint and read me)
