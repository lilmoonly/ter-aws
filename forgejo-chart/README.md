# Forgejo Helm Chart

This Helm chart deploys [Forgejo](https://forgejo.org), a self-hosted Git service, into a Kubernetes cluster.

---

## 📁 Chart Structure

forgejo-chart/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── imagePullSecret.yaml
│   ├── forgejo/
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── secret.yaml
│   │   └── service.yaml
│   
│       
│       
│       
│       
│     
│       

---

## 🧰 Requirements

- Kubernetes cluster
- Helm v3+
- Access to a container registry (e.g., GHCR)
- (Optional) Base64-encoded SQL dump for PostgreSQL initialization

---

## Installation

```bash
# Navigate to chart directory
cd forgejo-chart

# (Optional) Lint the chart
helm lint .

# Install the chart
helm install forgejo .
```

To install into a specific namespace:

```bash
helm install forgejo . -n your-namespace --create-namespace
```

---

## Upgrade

```bash
helm upgrade forgejo .
```

---

##Rollback

```bash
helm rollback forgejo [REVISION]
```

---

## Uninstall

```bash
helm uninstall forgejo
```

---

## Notes

- Be sure to fill out sensitive values in `values.yaml`, especially:
  - Any custom passwords or secrets
