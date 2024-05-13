# Adım 1: Kubernetes Cluster Kurulumu

### Install kubectl

- Launch an AWS EC2 instance of Amazon Linux 2023 AMI with security group allowing SSH.

- Connect to the instance with SSH.

- Update the installed packages and package cache on your instance.

```bash
sudo dnf update -y
```

- Download the Amazon EKS vended kubectl binary.

```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl
```

- Apply execute permissions to the binary.

```bash
chmod +x ./kubectl
```

- Copy the binary to a folder in your PATH. If you have already installed a version of kubectl, then we recommend creating a $HOME/bin/kubectl and ensuring that $HOME/bin comes first in your $PATH.

```bash
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
```

- (Optional) Add the $HOME/bin path to your shell initialization file so that it is configured when you open a shell.

```bash
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
```

- After you install kubectl , you can verify its version with the following command:

```bash
kubectl version --client
```

### Install eksctl

- Download and extract the latest release of eksctl with the following command.

```bash
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz"
```

- Move and extract the binary to /tmp folder.

```bash
tar -xzf eksctl_$(uname -s)_amd64.tar.gz -C /tmp && rm eksctl_$(uname -s)_amd64.tar.gz
```

- Move the extracted binary to /usr/local/bin.

```bash
sudo mv /tmp/eksctl /usr/local/bin
```

- Test that your installation was successful with the following command.

```bash
eksctl version
```

## Part 2 - Creating the Kubernetes Cluster on EKS

- Configure AWS credentials. Or you can attach `AWS IAM Role` to your EC2 instance.

```bash
aws configure
```

- Create an EKS cluster via `eksctl`. It will take a while.

```bash
eksctl create cluster --region us-east-1 --version 1.29 --zones us-east-1a,us-east-1b,us-east-1c --node-type t3a.medium --nodes 4 --nodes-min 4 --nodes-max 7 --name cw-cluster

### Part 3 - Creating Namespaces

apiVersion: v1
kind: Namespace
metadata:
  name: test

---
apiVersion: v1
kind: Namespace
metadata:
  name: production


#### Part 4 - Defining Groups and Roles

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: test
  name: junior-test
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["*"]
  verbs: ["*"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: production
  name: junior-production
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["*"]
  verbs: ["get", "list"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jr-test-rb
  namespace: test
subjects:
- kind: Group
  name: junior
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: junior-test
  apiGroup: rbac.authorization.k8s.io

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jr-production-rb
  namespace: production
subjects:
- kind: Group
  name: junior
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: junior-production
  apiGroup: rbac.authorization.k8s.io

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: test
  name: junior-test
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["*"]
  verbs: ["*"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: production
  name: junior-production
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["*"]
  verbs: ["get", "list"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jr-test-rb
  namespace: test
subjects:
- kind: Group
  name: junior
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: junior-test
  apiGroup: rbac.authorization.k8s.io

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jr-production-rb
  namespace: production
subjects:
- kind: Group
  name: junior
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: junior-production
  apiGroup: rbac.authorization.k8s.io

## Part 5 - Installing Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/aws/deploy.yaml


## Part 6 - Configuring Worker Nodes

$ node1=$(kubectl get no -o jsonpath="{.items[1].metadata.name}")

$ node2=$(kubectl get no -o jsonpath="{.items[2].metadata.name}")

$ node3=$(kubectl get no -o jsonpath="{.items[3].metadata.name}")

$ kubectl taint node $node1 tier=production:NoSchedule

$ kubectl taint node $node2 tier=production:NoSchedule

$ kubectl taint node $node3 tier=production:NoSchedule

$ kubectl label node $node1 tier=production

$ kubectl label node $node2 tier=production

$ kubectl label node $node3 tier=production

## Part 7 - Deploying Wordpress Application

apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-test-pv-vol
  namespace: test
  labels:
    tier: test
    app: mysql
spec:
  storageClassName: manual
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-test-pv-claim
  namespace: test
  labels:
    tier: test
    app: mysql
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
  namespace: test
  labels:
    tier: test
    app: mysql
spec:
  selector:
    matchLabels:
      tier: test
      app: mysql

  template:
    metadata:
      labels:
        tier: test
        app: mysql
    spec:
      containers:
      - name: mysql-test
        image: mysql:5.6


        envFrom:
          - secretRef:
              name: mysql-test-secret
        resources:
          limits:
            memory: "1Gi"
            cpu: "250m"
        ports:
          - containerPort: 3306
            name: mysql-test-port

        volumeMounts:
        - mountPath: /var/lib/mysql
          name: mysql-pv-storage

      volumes:
      - name: mysql-pv-storage
        persistentVolumeClaim:
          claimName: "mysql-test-pv-claim"

---
apiVersion: v1
kind: Service
metadata:
  name: mysql-test-svc
  namespace: test
  labels:
    tier: test
spec:
  selector:
    tier: test
    app: mysql
  ports:
  - port: 3306
    targetPort: 3306

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress-deploy
  namespace: test
  labels:
    app: wordpress
    tier: test
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: test
      app: wordpress
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        tier: test
        app: wordpress
    spec:
      containers:
      - name: wordpress-cotainer
        image: wordpress:5.6
        ports:
        - containerPort: 80
        resources:
          limits:
            cpu: "0.5"
            memory: "512Mi"
          requests:
            cpu: "0.1"
            memory: "256Mi"
        env:
        - name: WORDPRESS_DB_HOST
          value: mysql-test-svc
        envFrom:
          # - configMapRef:
          #     name: test-config
          - secretRef:
              name: test-secret

      affinity:
        podAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - mysql
            topologyKey: kubernetes.io/hostname
---
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: test-config
#   namespace: test
# data:
#   WORDPRESS_DB_HOST: mysql-test-svc

---
apiVersion: v1
kind: Secret
metadata:
  name: test-secret
  namespace: test
type: Opaque
data:
  WORDPRESS_DB_USER: bXlzcWx3cGFkbWlu
  WORDPRESS_DB_PASSWORD: UEBzc3cwcmQxIQ==
  WORDPRESS_DB_NAME: d29yZHByZXNzZGI=

---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-test-secret
  namespace: test
type: Opaque
data:
  MYSQL_USER: bXlzcWx3cGFkbWlu
  MYSQL_PASSWORD: UEBzc3cwcmQxIQ==
  MYSQL_DATABASE: d29yZHByZXNzZGI=
  MYSQL_ROOT_PASSWORD: UEBzc3cwcmQxIQ==
---
apiVersion: v1
kind: Service
metadata:
  name: test-svc
  namespace: test
  labels:
    tier: test
    app: wordpress
spec:
  selector:
    tier: test
    app: wordpress
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30001
  type: NodePort

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
  namespace: production
  labels:
    tier: production
    app: mysql
spec:
  selector:
    matchLabels:
      tier: production
      app: mysql

  template:
    metadata:
      labels:
        tier: production
        app: mysql
    spec:
      containers:
        - name: mysql-prod
          image: mysql:5.6
          envFrom:
            - secretRef:
                name: mysql-pr-secret
          resources:
            limits:
              memory: "1Gi"
              cpu: "250m"
          ports:
            - containerPort: 3306
              name: mysql-prod-port

      nodeSelector:
        tier: production
      tolerations:
        - key: "tier"
          operator: "Equal"
          value: "production"
          effect: "NoSchedule"
---
apiVersion: v1
kind: Service
metadata:
  name: mysql-prod-svc
  namespace: production
  labels:
    tier: production
spec:
  selector:
    tier: production
    app: mysql
  ports:
    - port: 3306
      targetPort: 3306
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress-deploy-pr
  namespace: production
  labels:
    tier: production
    app: wordpress
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: production
      app: wordpress
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        tier: production
        app: wordpress
    spec:
      containers:
        - name: wordpress-cotainer-pr
          image: wordpress:5.6
          ports:
            - containerPort: 80
          resources:
            limits:
              cpu: "0.5"
              memory: "512Mi"
            requests:
              cpu: "0.1"
              memory: "256Mi"
          env:
          - name: WORDPRESS_DB_HOST
            value: mysql-prod-svc
          envFrom:
            # - configMapRef:
            #     name: prod-config
            - secretRef:
                name: prod-secret
      nodeSelector:
        tier: production
      tolerations:
        - key: "tier"
          operator: "Equal"
          value: "production"
          effect: "NoSchedule"
---
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: prod-config
#   namespace: production
# data:
#   WORDPRESS_DB_HOST: mysql-prod-svc

---
apiVersion: v1
kind: Secret
metadata:
  name: prod-secret
  namespace: production
type: Opaque
data:
  WORDPRESS_DB_USER: bXlzcWx3cGFkbWlu
  WORDPRESS_DB_PASSWORD: UEBzc3cwcmQxIQ==
  WORDPRESS_DB_NAME: d29yZHByZXNzZGI=
---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-pr-secret
  namespace: production
type: Opaque
data:
  MYSQL_USER: bXlzcWx3cGFkbWlu
  MYSQL_PASSWORD: UEBzc3cwcmQxIQ==
  MYSQL_DATABASE: d29yZHByZXNzZGI=
  MYSQL_ROOT_PASSWORD: UEBzc3cwcmQxIQ==

---
apiVersion: v1
kind: Service
metadata:
  name: wp-prod-svc
  namespace: production
  labels:
    tier: production
    app: wordpress
spec:
  selector:
    tier: production
    app: wordpress
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30002
  type: NodePort


## Part 8 - Providing Access via Route53

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  labels:
    tier: test
    app: wordpress
  namespace: test
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: testblog.ahmetdevops.click
    http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: test-svc
            port:
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: prod-ingress
  labels:
    tier: production
    app: wordpress
  namespace: production
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: companyblog.ahmetdevops.click
    http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: wp-prod-svc
            port:
              number: 80
```
