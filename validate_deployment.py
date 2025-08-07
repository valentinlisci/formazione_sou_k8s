from kubernetes import client, config
import sys

try:
    config.load_incluster_config()
    apps_v1 = client.AppsV1Api()

    namespace = "formazione-sou"
    deployment_name = "flask-release-flask-chart"

    deployment = apps_v1.read_namespaced_deployment(name=deployment_name, namespace=namespace)
    containers = deployment.spec.template.spec.containers

    missing_fields = []

    for container in containers:
        if container.readiness_probe is None:
            missing_fields.append("readinessProbe")
        if container.liveness_probe is None:
            missing_fields.append("livenessProbe")
        if not container.resources or not container.resources.requests:
            missing_fields.append("resources.requests")
        if not container.resources or not container.resources.limits:
            missing_fields.append("resources.limits")

    if missing_fields:
        print(f"❌ Deployment non conforme: mancano {set(missing_fields)}")
        sys.exit(1)
    else:
        print("✅ Deployment conforme: tutte le probe e le risorse sono presenti.")
        sys.exit(0)

except client.exceptions.ApiException as e:
    print(f"❌ Errore API Kubernetes: {e}")
    sys.exit(2)

except Exception as e:
    print(f"❌ Errore generico nello script: {e}")
    sys.exit(3)

