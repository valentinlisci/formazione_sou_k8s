pipeline {
  agent {
    label 'agent1'
  }

  parameters {
    string(name: 'IMAGE_TAG', defaultValue: '', description: 'Tag immagine Docker (lascia vuoto per generarlo 
in base a Git)')
  }

  environment {
    KUBECONFIG = "/home/jenkins/.kube/config"
    DOCKER_IMAGE = "valentinlisci/flask-app-example-build"
    HELM_CHART_DIR = "charts/flask-chart"
    HELM_RELEASE_NAME = "flask-release"
    HELM_NAMESPACE = "formazione-sou"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
        script {
          def shortCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          def branchName = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
          def tagFromGit = sh(script: "git describe --tags --exact-match || true", returnStdout: true).trim()

          if (!params.IMAGE_TAG?.trim()) {
            if (tagFromGit) {
              env.IMAGE_TAG = tagFromGit
            } else if (branchName == "main") {
              env.IMAGE_TAG = "latest"
            } else if (branchName == "develop") {
              env.IMAGE_TAG = "develop-${shortCommit}"
            } else {
              env.IMAGE_TAG = "${branchName}-${shortCommit}"
            }
          } else {
            env.IMAGE_TAG = params.IMAGE_TAG
          }

          echo "Tag finale immagine Docker: ${env.IMAGE_TAG}"
        }
      }
    }

    stage('Login DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 
'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
        }
      }
    }

    stage('Build Docker') {
      steps {
        sh '''
          echo "Costruisco immagine Docker..."
          docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
          docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
        '''
      }
    }

    stage('Push Docker') {
      steps {
        sh '''
          echo "Pusho immagine Docker..."
          docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
          docker push ${DOCKER_IMAGE}:latest
        '''
      }
    }

    stage('Helm Deploy') {
      steps {
        dir("${HELM_CHART_DIR}") {
          sh '''
            echo "Deploy su Kubernetes via Helm..."
            export KUBECONFIG=${KUBECONFIG}
            helm upgrade --install ${HELM_RELEASE_NAME} . \
              --namespace ${HELM_NAMESPACE} \
              --create-namespace \
              --set image.repository=${DOCKER_IMAGE} \
              --set image.tag=${IMAGE_TAG} \
              --set service.type=NodePort
          '''
        }
      }
    }

    stage('Validazione Deployment') {
      steps {
        sh '''
          echo "Eseguo validazione Deployment..."
          kubectl delete pod validator -n ${HELM_NAMESPACE} --ignore-not-found
          kubectl apply -f validator-pod.yaml
          sleep 5
          kubectl logs -n ${HELM_NAMESPACE} validator || true
        '''
      }
    }
  }

  post {
    always {
      sh 'docker logout || true'
    }
    success {
      echo "Deploy completato con successo."
    }
    failure {
      echo "Errore durante la pipeline."
    }
  }
}

