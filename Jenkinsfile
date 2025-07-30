pipeline {
  agent any

  environment {
    CHART_DIR = 'charts/flask-chart'
    RELEASE_NAME = 'flask-app'
    NAMESPACE = 'formazione-sou'
    IMAGE_REPOSITORY = 'valentinlisci/flask-app-example-build'
    IMAGE_TAG = 'v1.9'
  }

  stages {
    stage('Helm Install') {
      steps {
        script {
          sh '''
            helm upgrade --install ${RELEASE_NAME} ${CHART_DIR} \
              --namespace ${NAMESPACE} \
              --create-namespace \
              --set image.repository=${IMAGE_REPOSITORY} \
              --set image.tag=${IMAGE_TAG}
          '''
        }
      }
    }
  }

  post {
    success {
      echo "✅ Deploy completato con successo sul namespace ${NAMESPACE}"
    }
    failure {
      echo "❌ Deploy fallito"
    }
  }
}
