Proposed Solution:
-----------------
1. IaC (Terraform): 
a. Automate provision of INFRA (EC2 + EBS Volume for Jenkins installation + VPC + Subnet + Route Tables + IGW + Security groups)
b. Automate basic CloudWatch monitoring + SNS

2. Configuration Management (Ansible) [user data, along with Python]
a. Automate deployment of CI (Jenkins) [user data, along with Java]


Pre-requisites:
--------------
1. Setup aws configure
2. Terraform version used: v0.12.23
3. ansible-playbook binary available on the node where terraform commands are used
4. Run ssh-keygen -f mykey in folder where repo is cloned

How to use the repo:
-------------------
1. Setup pre-requisites
2. git clone https://github.com/vchaudh3/tf_jenkins_ansible.git
3. wget https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip; unzip terraform_0.12.23_linux_amd64.zip; mv terraform /usr/bin/terraform
4. terraform init; terraform plan; terraform apply
5. Access Jenkins at <ec2-pub-ip>:8081
5.1 Setup Jenkins job, petclinic_Jenkins_job.pdf
5.2 Run Jenkins job, petclinic_Jenkins_job_run.pdf
5.3 Access the app, petclinic_app_dashboard.pdf
6. Either manually stress the CPU or wait for the alarm to trigger (CPUUtilization >=1) Gmail - ALARM_ _high-cpu-utilization-alarm_ in EU (Ireland).pdf

Notes:
-----
1. Default port for Jenkins changed from 8080-->8081 as the https://github.com/spring-projects/spring-petclinic runs on 8080
2. Attachments from the successful Jenkins run and the config attached


Enhancements:
------------
1. Option for remote backend configured but not used for this scenario


