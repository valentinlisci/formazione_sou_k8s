FROM python:3.9-slim

# Variabili
ENV HELM_VERSION=v3.18.4

# Crea directory di lavoro
WORKDIR /app

# Installa curl, tar e Helm
RUN apt-get update && \
    apt-get install -y curl tar && \
    curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-amd64 helm-${HELM_VERSION}-linux-amd64.tar.gz

# (Pulizia opzionale – rimuove curl, NON tar)
RUN apt-get remove -y curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copia e installa dipendenze Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Avvio
CMD ["python", "app.py"]
