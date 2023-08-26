# Website Hosted on EC2 using NGINX & Docker

This project uses GitHub Actions and Terraform to automatically provision a website running on NGINX inside Docker containers hosted on EC2 instances. 

## The Web Server
I choose NGINX for its high performance, low resource usage and event-driven architecture. 

## The Infrastructure

- Route53: Allow access via a clean domain name.
- SSL certificate: Encrypt HTTP traffic.
- ALB: ensure individual EC2s are not overloaded and remain responsive.
- Private Subnets: Allows the EC2 instances to run securely in the backend.
- ASG: Ensures the system scales to meet demand and that new EC2s automatically.
- Multi-AZ: Provisioned across two AZs for fault tolerance


## Infrastructure as Code & CI/CD:
- Provisioned automatically using GitHub Actions and Terraform 

## Room For Growth
- Docker containers are spun up on the EC2 instance using the user data. Althgouh suitable in small dpeloyements, in larger deployments, Docker Compose, Kubernetes, AWS ECS, or AWS EKS would offer better scalability, manageability, and efficiency.
- The deployment pipeline lacks any unit or integration tests. Ideally, all the project would have several tests. A fail would trigger a rollback and a pass would push any updates.
- The project does not have any application, infrastructure, network or expenditure monitoring or alerts in place. 
- Potentially create separate development and production environments. For example, in its current configuration the files being served are copied to the docker container. Although this may be desirable for production, in development, a bind mount might be preferred so that code changes take place as they are pushed.
