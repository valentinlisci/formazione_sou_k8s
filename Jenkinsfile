pipeline {
  agent any

  environment {
    HELM_VERSION = "v3.13.3"
    HELM_INSTALL_DIR = "${WORKSPACE}/tools"
    PATH = "${HELM_INSTALL_DIR}:${PATH}"
    KUBECONFIG = "/home/jenkins/.kube/config"  // kubeconfig corretto
  }

  stages {
    stage('Setup Helm') {
      steps {
        sh '''
          echo "🔍 Controllo se Helm è installato..."

          if ! command -v helm >/dev/null; then
            echo "⬇️  Scarico Helm ${HELM_VERSION}..."
            mkdir -p ${HELM_INSTALL_DIR}
            curl -sSL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar -xz
            mv linux-amd64/helm ${HELM_INSTALL_DIR}/helm
            rm -rf linux-amd64
            echo "✅ Helm installato in ${HELM_INSTALL_DIR}/helm"
          else
            echo "✅ Helm già presente"
          fi

          echo "📦 Versione Helm:"
          helm version
        '''
      }
    }

    stage('Verifica Connessione Cluster') {
      steps {
        sh '''
          echo "🔍 Verifica connessione al cluster Kubernetes..."
          export KUBECONFIG=/home/jenkins/.kube/config
          kubectl cluster-info
          kubectl get nodes
        '''
      }
    }

    stage('Helm Install') {
      steps {
        dir('charts/flask-chart') {
          sh '''
            echo "🚀 Deploy con Helm..."
            export KUBECONFIG=/home/jenkins/.kube/config
            helm upgrade --install flask-release . \
              --namespace default \
              --create-namespace
          '''
        }
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

