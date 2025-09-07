# fabcon2025-cicd-demo
This repo represent the Cross-tenant CI-CD automation session for FabCon Vienna 2025.


# STEP 1: Infrastructure create & Git setup​
1. Create a Fabric capacity using Terraform​
1. Create ADO cloud connection using Terraform ​
1. Create a main workspaces using Terraform​
1. Connect the workspace to Git repo using the connection from step 1 using Terraform (branch: main)​


The Git folder contains the following items:​
1. data pipeline with variable library
1. copyjob with variable library
1. notebook using variable library​

![alt text](img/FabCon2025-Vienna.png)
​
# STEP 2: Work with feature workspace​
1. Create feature workspace by using `Branch-out` operartion via Fabric UI 
1. Work with variable library, develop some items, save and commit
1. Create PR from dev -> main branch
1. Via ADO pipeline automation - update main workspace using Fabric Git `update-from-git` REST API

![alt text](img/FabCon2025-Vienna-step2.png)