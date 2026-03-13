# Secure Serverless API with Terraform

This project demonstrates how to provision a **secure serverless API architecture on AWS using Terraform and CI/CD automation**.

The goal of the project is to simulate a **production-style DevOps workflow** where infrastructure is modular, reproducible, and deployed through automation.

---

## Architecture

Client  
↓  
API Gateway  
↓  
AWS Lambda  
↓  
DynamoDB  
↓  
CloudWatch Logs  

Infrastructure is provisioned using **Terraform modules**, with **remote state stored in S3** and **state locking handled by DynamoDB**.

---

## Features

- Infrastructure as Code using **Terraform**
- Modular Terraform architecture
- Environment-based deployment structure
- **API Gateway HTTP API**
- **AWS Lambda serverless function**
- **DynamoDB database**
- **CloudWatch logging**
- **S3 remote Terraform state**
- **DynamoDB state locking**
- **GitHub Actions CI/CD pipeline**

---

## Project Structure
