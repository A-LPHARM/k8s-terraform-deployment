# Prometheus and Grafana Deployment on Kubernetes

## Overview
This guide provides step-by-step instructions for deploying **Prometheus** and **Grafana** on a Kubernetes cluster using Kubernetes manifest files.

For more details on monitoring using prometheus and grafana visit 

## Prerequisites
- A running **Kubernetes cluster** (Minikube, EKS, GKE, AKS, or K3s)
- **kubectl** installed and configured
- **PersistentVolume** support if using a cloud provider

## Deployment Steps

### 1. Clone the Repository
```sh
git clone https://github.com/A-LPHARM/k8s-terraform-deployment.git
cd monitoring
```

### 2. Deploy Prometheus
#### Apply Prometheus ConfigMap and Deployment
```sh
kubectl apply -f prometheus/namespace.yaml
kubectl apply -f prometheus/clusterRole.yaml
kubectl apply -f prometheus/config-map.yaml
kubectl apply -f prometheus/prometheus-deployment.yaml
kubectl apply -f prometheus/prometheus-service.yaml
```

### 3. Deploy Grafana
#### Apply Grafana ConfigMap, Deployment, and Service
```sh
kubectl apply -f grafana/grafana-datasource-configmap.yaml
kubectl apply -f grafana/deployment.yaml
kubectl apply -f grafana/service.yaml
```

### 4. Verify Deployments
```sh
kubectl get pods -n monitoring
kubectl get services -n monitoring
```

### 5. Access the Dashboards
#### Prometheus UI
To access Prometheus:
```sh
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
```
Then open [http://localhost:9090](http://localhost:9090) in your browser.

#### Grafana UI
To access Grafana:

use the [http://NodePort:3000] or or (http://LoadBalancer:3000) in your browser.

**Default Login:**
- Username: `admin`
- Password: `admin`

- then input your new password

### 6. Add Prometheus as a Data Source in Grafana
1. Open Grafana UI.
2. Navigate to **Configuration** → **Data Sources**.
3. Click **Add Data Source** → Select **Prometheus**.
4. Set **URL** to `http://prometheus:9090`.
5. Click **Save & Test**.

### 7. Import Dashboards
- Navigate to **Create → Import** in Grafana.
- Use **Grafana Dashboard ID 1860 or 8588** for Kubernetes monitoring.

## Cleanup
To remove all deployments:
```sh
kubectl delete -f grafana/.
kubectl delete -f prometheus/. 

```

## Contributing
Feel free to submit issues or pull requests to improve this deployment guide.

