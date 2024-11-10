pipeline {
    agent any

    environment {
        
        PROJECT_ID = 'poised-graph-435714-p2'
        IMAGE_NAME = 'gcr.io/poised-graph-435714-p2/my-app:latest'
        IMAGE_TAG = "${env.BUILD_ID}"
        GKE_CLUSTER = 'my-gke-cluster'
        GKE_ZONE = 'us-central1-a'
        GOOGLE_CREDENTIALS = credentials('service-gcp')
        GIT_CREDENTIALS = credentials('git-jenkins')  // This is the GitHub credentials ID
       
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code, using the specified branch
                git credentialsId: 'git-jenkins', branch: 'main', url: 'https://github.com/Darsh4545/jenkins-project.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker buildx build -t gcr.io/poised-graph-435714-p2/my-app:latest ."
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
                    
                    sh "kubectl apply -f deployment.yaml --namespace ${GKE_NAMESPACE}"
                    
                    // Deploy the application using kubectl
                    sh """
                    kubectl set image deployment/${IMAGE_NAME} ${IMAGE_NAME}=gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_TAG}
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
