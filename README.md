# Cloud Ops API Gateway

A FastAPI-based gateway for automating cloud operations and infrastructure management tasks. This project serves as a learning platform for FastAPI development and AWS service integration.

## 🚀 Current Features

### Core API
- **Health Check**: Service status monitoring (`/API/health`)
- **API Key Authentication**: Header-based security (`X-API-Key`)
- **Interactive Documentation**: Auto-generated OpenAPI docs at `/docs`

### AWS Integrations
- **Lambda Function(Small app wtih logic to check age passed)**: Invoke AWS Lambda with parameters (`/API/lambda/{age}`)
- **SQS Messaging**: Send messages to queues (`/API/SQS/send-message-to-sqs`)
- **CloudWatch Logs**: Query and filter log events (`/API/Logs`)

### Technical Stack
- **FastAPI**: Modern Python web framework
- **Pydantic**: Data validation and serialization
- **boto3**: AWS SDK for Python
- **Authentication**: Dependency injection with API key validation

## 📁 Project Structure

```
cloud-ops-api-gateway/
├── main.py              # FastAPI application and endpoints
├── auth.py              # Authentication logic
├── requirements.txt     # Python dependencies
├── .env                 # Environment variables (create this)
├── .gitignore          # Git ignore patterns
└── README.md           # This file
```

## 🛠️ Local Setup

### Prerequisites
- Python 3.8+ installed
- AWS Account with configured credentials
- Access to AWS services: Lambda, SQS, CloudWatch Logs

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd cloud-ops-api-gateway
   ```

2. **Create virtual environment**
   ```bash
   # macOS/Linux
   python3 -m venv venv
   source venv/bin/activate
   
   # Windows
   python -m venv venv
   venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install fastapi uvicorn boto3 python-dotenv
   ```

4. **Environment Configuration**
   Create a `.env` file in the project root:
   ```env
   API_KEY=your-secret-api-key-here
   AWS_ACCESS_KEY_ID=your-aws-access-key
   AWS_SECRET_ACCESS_KEY=your-aws-secret-key
   AWS_DEFAULT_REGION=us-east-1
   ```

5. **Run the application**
   ```bash
   uvicorn main:app --reload
   ```

6. **Access the API**
   - **Main API**: http://127.0.0.1:8000
   - **Interactive Docs**: http://127.0.0.1:8000/docs
   - **Health Check**: http://127.0.0.1:8000/API/health

## 🔐 Authentication

All protected endpoints require an API key in the request header:
```
X-API-Key: your-secret-api-key-here
```

## 📚 API Endpoints

### Public Endpoints
- `GET /` - Hello World message
- `GET /API/health` - Service health status

### Protected Endpoints (Require API Key)
- `GET /protected-data/` - Test authenticated access
- `GET /API/lambda/{age}` - Invoke AgeFunction Lambda with age parameter
- `POST /API/SQS/send-message-to-sqs` - Send message to SQS queue
- `GET /API/Logs` - Query CloudWatch logs with filtering options

### Request Examples

**Send SQS Message:**
```bash
curl -X POST "http://127.0.0.1:8000/API/SQS/send-message-to-sqs" \
  -H "X-API-Key: your-api-key" \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from FastAPI", "user_id": "user123", "priority": "high"}'
```

**Query CloudWatch Logs:**
```bash
curl "http://127.0.0.1:8000/API/Logs?logGroupName=/aws/lambda/AgeFunction&hours_back=12&limit=50" \
  -H "X-API-Key: your-api-key"
```

## 🎯 Current AWS Resources

The API currently integrates with these AWS resources:
- **Lambda Function**: `AgeFunction` (us-east-1)
- **SQS Queue**: `fastapi-test-queue` (us-east-1)
- **CloudWatch Logs**: `/aws/lambda/AgeFunction` log group

## 🚧 Development Status

This project is in active development. Current focus areas:
- ✅ Basic FastAPI structure
- ✅ AWS Lambda integration
- ✅ SQS messaging
- ✅ CloudWatch Logs querying
- ✅ API key authentication
- ✅ Pydantic data validation

## 🔮 Planned Features

- **S3 Integration**: File upload/download operations
- **SNS Notifications**: Pub/sub messaging
- **DynamoDB Operations**: NoSQL database interactions
- **EC2 Management**: Instance operations
- **Enhanced Error Handling**: Comprehensive AWS error management
- **Background Tasks**: Async operation support
- **Rate Limiting**: API usage controls

## 🧪 Testing

Use the interactive documentation at `/docs` to test endpoints with the built-in Swagger UI, or use tools like curl, Postman, or HTTPie for API testing.

## 📝 Learning Notes

This project demonstrates:
- FastAPI dependency injection patterns
- AWS SDK (boto3) integration
- RESTful API design principles
- Authentication middleware implementation
- Query parameter vs request body patterns
- Time-based filtering and pagination
- Error handling for cloud services

## 🤝 Contributing

This is a personal learning project, but suggestions and improvements are welcome! Feel free to open issues or submit pull requests.

## 📄 License

This project is for educational purposes. Feel free to use and modify as needed for your own learning.