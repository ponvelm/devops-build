**Screenshots **
<img width="1901" height="1022" alt="Finalproject-53  React applicaiton signup screen" src="https://github.com/user-attachments/assets/13d05be9-d5e7-44cb-9fef-b5be7eb6db38" />



**Final Project implementation steps:**
****Step 1: Clone and run the application locally**
Open terminal:

git clone https://github.com/sriram-R-krishnan/devops-build.git
cd devops-build


Run the application (for test purpose on port 80):

# If it's a Node.js app, for example:
npm install
sudo npm start


Check if app is accessible on http://localhost.

**Step 2: Dockerize the application**
2a: Create Dockerfile

Inside the project root, create Dockerfile:

# Use official Node image as base
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy app files
COPY . .

# Expose port 80
EXPOSE 80

# Start the app
CMD ["npm", "start"]

2b: Create .dockerignore
node_modules
npm-debug.log
.git

2c: Create docker-compose.yml
version: '3'
services:
  app:
    build: .
    ports:
      - "80:80"
    container_name: devops_app

**Step 3: Bash Scripts**
3a: build.sh
#!/bin/bash
# Build docker images
docker build -t ponvel123/dev:latest .
docker tag ponvel123/dev:latest ponvel123/prod:latest

3b: deploy.sh
#!/bin/bash
# Deploy docker image
docker-compose down
docker-compose up -d


Make both scripts executable:

chmod +x build.sh deploy.sh

**Step 4: Git Version Control**
# Initialize git (if not done)
git init

# Add dev branch
git checkout -b dev

# Add .gitignore
echo "node_modules/" >> .gitignore
echo "npm-debug.log" >> .gitignore

# Add files & commit
git add .
git commit -m "Initial commit with Docker setup"

# Add remote
git remote add origin https://github.com/<your-username>/devops-build.git

# Push to dev branch
git push -u origin dev

**Step 5: Docker Hub Setup**

Create two repositories:

dev → public

prod → private

Login from CLI:

docker login

**Step 6: Jenkins Setup**

Install Jenkins (on EC2 or local VM) and required plugins:

Git plugin

Docker plugin

Pipeline plugin

Configure Jenkins credentials:

GitHub credentials

Docker Hub credentials

Create pipeline job:

Connect to GitHub repo

Enable webhook trigger (Push to dev triggers dev build)

Use your Jenkinsfile for pipeline logic

Jenkinsfile sample logic:

pipeline {
    agent any
    stages {
        stage('Clone') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/<username>/devops-build.git'
            }
        }
        stage('Build Docker') {
            steps {
                sh './build.sh'
            }
        }
        stage('Push Docker') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh 'docker push ponvel123/dev:latest'
                    } else if (env.BRANCH_NAME == 'main') {
                        sh 'docker push ponvel123/prod:latest'
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }
}

**Step 7: AWS EC2 Deployment**

Launch t2.micro instance.

Security group:

HTTP (80) → your IP or 0.0.0.0/0

SSH (22) → your IP only

Connect via SSH:

ssh -i key.pem ec2-user@<ec2-public-ip>


Install Docker:

sudo yum update -y
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user


Pull & run your Docker image:

docker pull ponvel123/dev:latest
docker run -d -p 80:80 ponvel123/dev:latest


Check deployment via EC2 public IP.

**Step 8: Monitoring**

Install Prometheus + Node Exporter or cAdvisor for Docker monitoring.




Optional: Grafana for dashboards.

Configure alert rule to send notification if container stops.
