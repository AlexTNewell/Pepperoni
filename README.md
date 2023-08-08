# Website Hosted on EC2 using NGINX & Docker

Key Points:
- Provisioned via GitHub Actions using Terraform 
- Route53: Allow access via a clean domain name.
- SSL certificate: Encrypt HTTP traffic.
- ALB: ensure individual EC2s are not overloaded and remain responsive.
- Subnets &amp; Bastion hosts: Allows the ec2s to run securely in the backend.
- EC2 user data: Automatically pull the docker image from Dockerhub and run a container upon instantiation
- ASG: Ensures the system scales to meet demand and that new EC2s automatically.
- Multi-AZ: Provisioned across two AZs for fault tolerance

Room for Expansion
- Lacks application, infrastructure, network and expenditure monitoring/alerts
- Lacks build pipeline unit and integration tests.
- Potentially create separate development and production environments. For example, in its current configuration the files being served are copied to the docker container. Although this may be desirable for production, in development, a bind
mount might be preferred so that code changes take place as they are pushed.
