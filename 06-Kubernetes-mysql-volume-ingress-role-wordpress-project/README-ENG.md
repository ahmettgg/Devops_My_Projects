Kubernetes Cluster and Application Configuration
This project involves setting up a Kubernetes cluster and configuring applications according to specific requirements.

Steps
Kubernetes Cluster Installation:

1.1. Set up a Kubernetes cluster with one master and four worker nodes, totaling five nodes.

Namespace Creation:

2.1. Create two namespaces named "test" and "production".

Group and Role Definition:

3.1. For the junior group:

Create a role with full permissions (read, list, create, etc.) on all resources in the "test" namespace.
Create a role with read and list permissions only on all resources in the "production" namespace.
3.2. For the senior group:

Create a role with full permissions on all resources in both the "test" and "production" namespaces.
Create a role with read and list permissions only on cluster-wide resources.
Ingress Controller Installation:

4.1. Install an ingress controller such as Nginx, Traefik, or Haproxy.

Worker Node Configuration:

5.1. Ensure that only three worker nodes can schedule and deploy pods in the "production" environment. Prevent other pods from being scheduled on these worker nodes.

Wordpress Application Deployment:

6.1. Deploy Wordpress and MySQL applications in both the "test" and "production" namespaces.

6.2. Create a "ClusterIP" type service for MySQL and store long-term data on persistent volumes.

6.3. Implement security measures to protect sensitive information for both applications.

6.4. Ensure that both applications are scheduled on the same worker node and define CPU and memory resource constraints.

Providing Access via Route53:

7.1. Set up Route53 to allow access to the Wordpress applications in the "test" namespace via "testblog.example.com" and in the "production" namespace via "companyblog.example.com".