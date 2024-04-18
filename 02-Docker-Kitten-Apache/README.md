Project-101: Carousel of Cats Static Website with Docker Container
Description
This project will guide you through creating a static website with a carousel of cute cats and deploying it using a Docker container.

Problem Statement
Goal:

Create a visually appealing static website using HTML and CSS.
Deploy the website using a Docker container running an Apache image.
The website should:

Feature a carousel displaying images of cute cats.
Be accessible via a web browser from anywhere on the internet.
Project Structure
101-cats-carousel-static-website (folder)
|
|----readme.md (This file)
|----Dockerfile (Defines Docker image build instructions)
|----docker-compose.yml (Optional; for local development)
|----static-web
| |----index.html (HTML file for the website)
| |----cat0.jpg (Image file for the cat carousel)
| |----cat1.jpg
| |----cat2.jpg
Expected Outcome
A functional cat carousel website.
Learning Objectives
Use of HTML and CSS for web design.
Use of Docker for containerized application packaging and deployment.
Gain experience with version control systems (Git).
Project-101: Carousel of Cats Static Website with Docker Container and CloudFormation
Description
This project will guide you through creating a static website with a carousel of cute cats and deploying it automatically using a Docker container and AWS CloudFormation.

Problem Statement
Goal:

Create a visually appealing static website using HTML and CSS.
Deploy the website using a Docker container running an Apache image.
Manage the deployment process with AWS CloudFormation for automation and repeatability.
Functional Requirements:

The website should feature a carousel displaying images of cute cats.
The website should be accessible via a web browser from anywhere on the internet.
Project Structure
101-cats-carousel-static-website (folder)
|
|----readme.md (This file)
|----Dockerfile (Defines Docker image build instructions)
|----docker-compose.yml (Optional; for local development)
|----static-web
| |----index.html (HTML file for the website)
| |----cat0.jpg (Image file for the cat carousel)
| |----cat1.jpg
| |----cat2.jpg
Expected Outcome
A functional cat carousel website.
The website URL after deploying the CloudFormation stack.
Learning Objectives
Use of HTML and CSS for web design.
Use of Docker for containerized application packaging and deployment.
Use of AWS CloudFormation for infrastructure automation.
Gain experience with version control systems (Git).
Solution Steps

1. Local Development (Optional):

Create the project directory (101-cats-carousel-static-website).
Place the static-web folder with website files.
(Optional) Create a docker-compose.yml file to set up a local development environment using Docker Compose (see documentation for details). 2. Building the Docker Image:

Open a terminal in the project directory.
Build an image named cats-carousel from the Dockerfile by running the command: docker build -t cats-carousel .
