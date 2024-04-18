FROM httpd

RUN apt-get update -y && \
    apt-get clean




WORKDIR /usr/local/apache2/htdocs



ADD https://raw.githubusercontent.com/ahmettgg/AWS_My_Project/main/01-Apachi-CloudFormation-Github-Static-Website-EC2/static-web/index.html .
ADD https://raw.githubusercontent.com/ahmettgg/AWS_My_Project/main/01-Apachi-CloudFormation-Github-Static-Website-EC2/static-web/cat0.jpg .
ADD https://raw.githubusercontent.com/ahmettgg/AWS_My_Project/main/01-Apachi-CloudFormation-Github-Static-Website-EC2/static-web/cat1.jpg .
ADD https://raw.githubusercontent.com/ahmettgg/AWS_My_Project/main/01-Apachi-CloudFormation-Github-Static-Website-EC2/static-web/cat2.jpg .

RUN chmod -R 645 /usr/local/apache2/htdocs

CMD ["httpd-foreground"]