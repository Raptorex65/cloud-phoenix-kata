# *PROJECT PHOENIX KATA*

 I have implemented an architecture based on utilizing cloudformation template structure. (You can think of it there was also a hidden criteria like using cloudformation to produce your infrastructure).

#**APPLICATION**#

According to given prerequisites I decided to containerize the phoenix-kata application on a Dockerfile. 
As a single node for database I chose to install mongodb community linux edition through my cloudformation template. (There is also a container image for mongodb but I did not prefer in order not to repeat sth before)

As project required to setup a scaling solution, Autoscaling and loadbalancer with health checks was a proper solution to recover the instances from crashes. But a full-fledged dockerized solution could also be implemented. I would also have utilized docker containers and make my application and database packaged and work within a container. In that case I would have made use of AWS ECS cluster. 

![Phoenix-structure](https://user-images.githubusercontent.com/71727239/215362345-1892c763-c1d8-428f-8297-2fa7bd9ebe67.jpg)

#**STRUCTURE**#

In order to meet the autoscaling requirement and make a secure environment for database backup I set up a VPC with two private and two public subnets. I created private subnets for EFS mount targets. I could also used just one mount target but in that case you must reach instances on other AZ’s, and which is a costly option, because AWS charges on inter-AZ communication for EFS. Thus it doesnot make sense to use One zone storage option. 

![efs](https://user-images.githubusercontent.com/71727239/215362037-163011cd-a8b6-4750-a171-300bb19cb7ff.png)

**EFS as Secure Storage for Database Backup**
EFS is natively integrated with AWS Backup. I preferred EFS file system as a secure storage area for backing up database logs and data. Launch template setup instances to mount EFS system when initializing automatically. 
I have composed two mount targets on the private subnets and modified Mongodb’s default paths 

![asg-targets](https://user-images.githubusercontent.com/71727239/215362053-0df9bc42-925b-4e09-b348-f4957f16e932.png)

#**SCALING**#

For scaling and balancing requirements of the workload Application Load Balancer and Autoscaling structures placed in cfn template. Scaling up policy for 100 requests/min and scaling down policy for CPUUtilization below 40 % threshold was applied. I have also created a Route 53 alias record for the load balancer. You can reach load balancer and application through port:80 and 443. EC2 instances of webserver has 22 and 3000 port for Loadbalancer communication.
Security groups designed permissive only for the source security groups. Only Loadbalancer communicates with WebServer on port:3000. Mount targets only reached by Webserver from port:2049. 

In order to meet the scaling need I have designed two scaling policies, used a predefined cloudwatch metric ALBRequestCountPerTarget to follow the incoming requests and scale up accordingly. We have also a scale down policy based upon CPUUtilization metric. When it decreases under 40 percent threshold for 5 minutes it scales instances down. 

#**CICD**#

For automation of the creating infrastructure and implemeting CICD Pipeline Process I worked in two ways, launched a jenkins server and prepared a Jenkinsfile for pipeline process and deployed infrastructure (cloudformation template) inside Jenkins pipeline. You can also launch a single job for cloudformation infrastructure on Jenkins with the help of a plugin named as cloudformation.

![jenkins](https://user-images.githubusercontent.com/71727239/215362077-2a5b5d79-e02f-4f4e-b363-ccd27df0fb34.png)

Secondly I also prepared a template for AWS Codepipeline and tried to apply pipeline process through other services such as Codebuild and Codedeploy. You can examine the pipeline on the file named as (phoenixpipeline.yaml). I managed build process using a buildspec.yml file (my-buildspec.yml) . 

#**CRASH**#

About killing the application process (Get/Crash) I found a solution by using one of the AWS service (AWS FIS). You can implement several kinds of experiment templates for your infrastructure. I have placed a kill-process-template.json designed for crashing certain process and there is a (crash-fis.yaml) cfn template designed for some actions like terminating, stopping instances. 

![fis-crash](https://user-images.githubusercontent.com/71727239/215362098-d7385565-c753-4e11-9ff8-976920249f3f.png)

#**OTHERS**#

Infrastructure prepared as a cloudformation template (cfn-structure.yaml).
For several parameters needed for stacks and files (such as DB_CONNECTION_STRING) I stored them in Parameter Store and use securely as an inherent AWS components.
For OSI-approved open source license we have an option on github inherently. You can change the status of your repo by selecting one of them such as (Apache, MIT, BSD etc)

![result](https://user-images.githubusercontent.com/71727239/215362090-2b7eed47-c01a-4f4b-8998-4da5ae178d01.png)

The infrastructure is up and running and you can check it out by visiting: **https://phoenix.cloudbundle.net**
