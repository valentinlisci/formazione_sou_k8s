pipeline {
  agent any

  environment {
    TAG = "v1.9"
    CHART_DIR = "charts/flask-chart"
    RELEASE_NAME = "flask-app"
    NAMESPACE = "formazione-sou"
  }

  stages {
    stage('Helm Install') {
      steps {
        sh '''
          echo "✅ Verifica versione Helm installato"
          helm version || { echo "❌ Helm non è installato nel nodo Jenkins"; exit 1; }

          echo "🚀 Eseguo helm upgrade --install"
          helm upgrade --install $RELEASE_NAME $CHART_DIR \
            --namespace $NAMESPACE \
            --create-namespace \
            --set image.repository=valentinlisci/flask-app-example-build \
            --set image.tag=$TAG
        '''
      }
    }
  }

  post {
    failure {
      echo '❌ Deploy fallito'
    }
    success {
      echo '✅ Deploy riuscito'
    }
  }
}

