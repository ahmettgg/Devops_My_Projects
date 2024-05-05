# Castello Bookstore Application

This project enables the deployment of Castello Bookstore, a bookstore application, in a Kubernetes environment. The application consists of a backend MySQL database and a frontend web server.

## Table of Contents

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Support and Contact](#support-and-contact)

## Requirements

To use this application, you need the following requirements:

- Kubernetes cluster
- `kubectl` CLI tool
- Docker
- A MySQL database

## Installation

1. First, create a MySQL Deployment and Service in your Kubernetes environment. You can use the Deployment and Service YAML files for MySQL to accomplish this step. For example:

   ```bash
   kubectl apply -f backpod.yaml
   kubectl apply -f service.yaml
   ```

2. Finally, apply the necessary Deployment and Service YAML files to run the frontend web server. For example:

   ```bash
   kubectl apply -f frontpod.yaml
   kubectl apply -f front-service.yaml
   ```

## Usage

Once the application is successfully deployed, you can access the frontend web server by using the IP address of one of your Kubernetes nodes and the NodePort number.

## Support and Contact

If you have any questions or feedback, feel free to reach out to us.
