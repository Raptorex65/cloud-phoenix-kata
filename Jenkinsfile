pipeline {
    agent any
    environment {
        ECR_REPO_NAME = "phoenix-jenkins-repo"
        APP_NAME = "phoenix-app-withjenkins"
        AWS_REGION = "us-east-1"        
        AWS_ACCOUNT_ID=sh(script:'aws sts get-caller-identity --query Account --output text', returnStdout:true).trim()
        ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }
    stages {
        stage('Create ECR Repo') {
            steps {
                echo 'Creating ECR Repo for App'
                sh """
                aws ecr create-repository \
                --repository-name ${ECR_REPO_NAME} \
                --image-scanning-configuration scanOnPush=false \
                --image-tag-mutability MUTABLE \
                --region ${AWS_REGION}
                """
            }
        }
        stage('Build App Docker Image') {
            steps {
                echo 'Building App Image'
                sh 'docker build --force-rm -t "$ECR_REPO_NAME" .'
                sh 'docker image ls'
            }
        }
        stage('Push Image to ECR Repo') {
            steps {
                echo 'Pushing App Image to ECR Repo'
                sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin "$ECR_REGISTRY"'
                sh 'docker tag "$ECR_REPO_NAME":latest "$ECR_REGISTRY"/"$ECR_REPO_NAME":latest'
                sh 'docker push "$ECR_REGISTRY"/"$ECR_REPO_NAME":latest'
            }
        }
        stage('Create Infrastructure for the App') {
            steps {
                echo 'Creating Infrastructure with CFN Stacks'
                sh """
                aws cloudformation create-stack \
                --stack-name PhoenixStack \
                --template-body file://cfn-structure.yaml \
                --capabilities CAPABILITY_IAM \
                --region us-east-1"
                """
            }
        }

    }
}



   
