pipeline {
  agent any

  environment {
    TAG = "v1.9"
  }

  stages {
    stage('Helm Install') {
      agent {
        docker {
          image 'alpine/helm:3.14.0' // versione compatibile
          args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
      }
      steps {
        sh '''
          helm upgrade --install flask-app charts/flask-chart \
            --namespace formazione-sou \
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
  }
}
