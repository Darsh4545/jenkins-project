pipeline {
    agent any

    environment {
        
        PROJECT_ID = 'poised-graph-435714-p2'
        IMAGE_NAME = 'gcr.io/poised-graph-435714-p2/my-app:latest'
        GKE_CLUSTER = 'my-gke-cluster'
        GKE_ZONE = 'us-central1'
        GOOGLE_CREDENTIALS = credentials('service-gcp')
        GIT_CREDENTIALS = credentials('jenkins-git')  // This is the GitHub credentials ID
       
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code, using the specified branch
                git branch: 'main', url: 'https://github.com/Darsh4545/jenkins-project.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t gcr.io/poised-graph-435714-p2/my-app:latest ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Configure Docker to use Google Cloud
                    sh 'gcloud auth activate-service-account --key-file=$GOOGLE_CREDENTIALS'
                    sh 'gcloud auth configure-docker'

                    // Push the Docker image to Google Container Registry
                    sh "docker push gcr.io/poised-graph-435714-p2/my-app:latest"
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                script {
                    // Get credentials for GKE cluster
                    sh "gcloud container clusters get-credentials ${GKE_CLUSTER} --zone ${GKE_ZONE} --project ${PROJECT_ID}"
                    
                    // Deploy the application using kubectl
                    sh """
                    kubectl set image deployment/${GKE_CLUSTER} ${IMAGE_NAME}=gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_TAG}
                    kubectl rollout status deployment/${IMAGE_NAME} 
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
