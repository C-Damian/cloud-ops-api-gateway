# Cloud Ops API Gateway

A FastAPI-based gateway for automating cloud operations and infrastructure management tasks. This project serves as a learning platform for FastAPI development, AWS service integration, and Infrastructure as Code (IaC) with Terraform.

[![Demo](https://youtu.be/CeB2i8V0O9c.png)](https://youtu.be/CeB2i8V0O9c)


## 🚀 Current Features

### Core API
- **Health Check**: Service status monitoring (`/API/health`)
- **API Key Authentication**: Header-based security (`X-API-Key`) with dual support for local and cloud deployment
- **Interactive Documentation**: Auto-generated OpenAPI docs at `/docs`

### AWS Integrations
- **Lambda Function**: Invoke AWS Lambda with parameters (`/API/lambda/{age}`) - includes AgeFunction with age validation logic
- **SQS Messaging**: Send messages to queues (`/API/SQS/send-message-to-sqs`)
- **CloudWatch Logs**: Query and filter log events (`/API/Logs`)

### Infrastructure as Code
- **Terraform**: Automated AWS infrastructure provisioning
- **API Gateway**: HTTP API with Lambda proxy integration
- **Environment Variables**: Secure API key management for cloud deployment
- **IAM Roles**: Proper permissions for Lambda execution

### Technical Stack
- **FastAPI**: Modern Python web framework
- **Pydantic**: Data validation and serialization
- **boto3**: AWS SDK for Python
- **Terraform**: Infrastructure as Code for AWS resource management
- **Mangum**: ASGI adapter for running FastAPI in AWS Lambda
- **Authentication**: Dependency injection with API key validation

## 📁 Project Structure

```
cloud-ops-api-gateway/
├── main.py                     # FastAPI application and endpoints
├── auth.py                     # Authentication logic (local + cloud)
├── requirements.txt            # Python dependencies for local development
├── lambda_reqs.txt            # Python dependencies for Lambda function
├── .env                       # Environment variables (local development only)
├── .gitignore                 # Git ignore patterns
├── README.md                  # This file
└── terraform/                 # Infrastructure as Code
    ├── providers.tf           # AWS provider configuration
    ├── lambda.tf              # Lambda function, IAM roles, and environment variables
    ├── api_gateway.tf         # API Gateway resources and integrations
    ├── outputs.tf             # Terraform outputs (API Gateway URL)
    ├── .terraform.lock.hcl    # Terraform dependency lock file
    └── terraform.tfstate      # Terraform state file (local)
```

## 🛠️ Setup and Deployment

### Prerequisites
- **Python 3.8+** installed
- **Terraform** installed (>= 1.3.0)
- **AWS Account** with configured credentials
- **AWS CLI** configured with appropriate permissions
- Access to AWS services: Lambda, API Gateway, IAM, CloudWatch Logs, SQS

### Local Development Setup

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

4. **Environment Configuration for Local Development**
   Create a `.env` file in the project root (required for local development only):
   ```env
   API_KEY=your-secret-api-key-here
   AWS_ACCESS_KEY_ID=your-aws-access-key
   AWS_SECRET_ACCESS_KEY=your-aws-secret-key
   AWS_DEFAULT_REGION=us-east-1
   ```

5. **Run the application locally**
   ```bash
   uvicorn main:app --reload
   ```

6. **Access the local API**
   - **Main API**: http://127.0.0.1:8000
   - **Interactive Docs**: http://127.0.0.1:8000/docs
   - **Health Check**: http://127.0.0.1:8000/API/health

### AWS Deployment with Terraform

1. **Navigate to Terraform directory**
   ```bash
   cd terraform
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Plan the deployment**
   ```bash
   terraform plan -var="api_key=your-secret-api-key-here"
   ```

4. **Deploy to AWS**
   ```bash
   terraform apply -var="api_key=your-secret-api-key-here"
   ```

5. **Get your API Gateway URL**
   After successful deployment, Terraform will output your API Gateway URL:
   ```
   Outputs:
   api_gateway_url = "https://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com"
   ```

6. **Access your cloud API**
   - **Main API**: `https://your-api-gateway-url.amazonaws.com/`
   - **Interactive Docs**: `https://your-api-gateway-url.amazonaws.com/docs`
   - **Health Check**: `https://your-api-gateway-url.amazonaws.com/API/health`

## 🔐 Authentication

The authentication system is designed to work seamlessly in both environments:

- **Local Development**: Uses `.env` file with `python-dotenv`
- **AWS Deployment**: Uses Terraform-managed environment variables

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

**Test Cloud Deployment:**
```bash
curl "https://your-api-gateway-url.amazonaws.com/API/health" \
  -H "X-API-Key: your-api-key"
```

**Send SQS Message:**
```bash
curl -X POST "https://your-api-gateway-url.amazonaws.com/API/SQS/send-message-to-sqs" \
  -H "X-API-Key: your-api-key" \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from FastAPI", "user_id": "user123", "priority": "high"}'
```

**Query CloudWatch Logs:**
```bash
curl "https://your-api-gateway-url.amazonaws.com/API/Logs?logGroupName=/aws/lambda/AgeFunction&hours_back=12&limit=50" \
  -H "X-API-Key: your-api-key"
```

## 🏗️ Infrastructure Architecture

```
Internet → API Gateway → Lambda Function (FastAPI + Mangum)
                      ↓
                   IAM Role (execution permissions)
                      ↓
           AWS Services (SQS, CloudWatch, Lambda invocation)
```

### Terraform Resources Created
- **API Gateway**: HTTP API with proxy integration
- **Lambda Function**: FastAPI application with Mangum adapter
- **IAM Role**: Lambda execution role with necessary permissions
- **Environment Variables**: Secure API key management
- **API Gateway Integration**: Routes all traffic to Lambda

## 🎯 Current AWS Resources

### Terraform-Managed Resources
- **Lambda Function**: `fastapi-cloud-ops-lambda` (created by Terraform)
- **API Gateway**: `fastapi_cloud_ops_api` (created by Terraform)
- **IAM Role**: Lambda execution role with CloudWatch and invocation permissions

### External AWS Resources (Manual Setup Required)
- **Lambda Function**: `AgeFunction` (us-east-1) - for age validation endpoint
- **SQS Queue**: `fastapi-test-queue` (us-east-1) - for messaging functionality
- **CloudWatch Logs**: `/aws/lambda/AgeFunction` log group

## 🚧 Development Status

This project is in active development. Current focus areas:
- ✅ Basic FastAPI structure
- ✅ AWS Lambda integration
- ✅ SQS messaging
- ✅ CloudWatch Logs querying
- ✅ API key authentication (local + cloud)
- ✅ Pydantic data validation
- ✅ Terraform infrastructure automation
- ✅ API Gateway integration
- ✅ Environment variable management

## 🔮 Planned Features

- **CI/CD Pipeline**: GitHub Actions for automated deployment
- **Database Integration**: DynamoDB for persistent storage
- **Enhanced Monitoring**: CloudWatch alarms and dashboards
- **Multi-Environment**: Dev/staging/prod with Terraform workspaces
- **S3 Integration**: File upload/download operations
- **SNS Notifications**: Pub/sub messaging
- **EC2 Management**: Instance operations
- **Enhanced Error Handling**: Comprehensive AWS error management
- **Background Tasks**: Async operation support
- **Rate Limiting**: API usage controls

## 🧪 Testing

### Local Testing
Use the interactive documentation at `http://127.0.0.1:8000/docs` to test endpoints with the built-in Swagger UI.

### Cloud Testing
After deployment, access the interactive docs at `https://your-api-gateway-url.amazonaws.com/docs` or use tools like curl, Postman, or HTTPie.

## 🔧 Terraform Commands

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var="api_key=your-key"

# Apply changes
terraform apply -var="api_key=your-key"

# Destroy infrastructure
terraform destroy -var="api_key=your-key"

# Show current state
terraform show

# Output values
terraform output
```

## 📝 Learning Notes

This project demonstrates:
- **FastAPI Development**: Modern Python web framework patterns
- **Infrastructure as Code**: Terraform for AWS resource management
- **Serverless Architecture**: Lambda + API Gateway pattern
- **Authentication Patterns**: Dual environment support (local + cloud)
- **AWS SDK Integration**: boto3 for service interactions
- **RESTful API Design**: Clean endpoint structure and documentation
- **Environment Management**: Secure configuration handling
- **Dependency Injection**: FastAPI authentication middleware
- **Error Handling**: Cloud service error management
- **DevOps Practices**: Local development to cloud deployment workflow

## 🤝 Contributing

This is a personal learning project, but suggestions and improvements are welcome! Feel free to open issues or submit pull requests.

