# Google Workspace users automation

First of all, lets talk a little about some principle services used on this solution.  

*Amazon API Gateway* is an AWS service to create, publish, mintain, monitor and protect APIs REST and WebSocket at any scale. The API developers can create APIs that access the AWS or another web services as well as data stored on AWS Cloud.
*AWS Lambda* is a serverless computing service that executes code in response to events and automatically manages resources
fundamental computational tools. These events can include changes in state or an update, such as a user placing an item on
a shopping cart from an e-commerce site.
*Google Workspace* is a Google solution that provides a cloud environment with collaboration and productivity tools (Gmail, Google Drive, Google Calendar, etc.).

## What is the purpose for using these solutions?
When we deal with employees and third parties, in our mind know that there are several operational impacts and risks with security breaches related to granting, changing and revoking access to services.This management is not easy if we have many requests in this regard. 
Bringing this stack of solutions, we can approach the concept of IAM (Identity and Access Management) so that we can manage, standardize processes, automate routines, track events and monitor personnel access.
Some motivations were decisive for this case:
- *"To err is human"*: even though processes are well defined, if everything is dependent on human and manual processes, they tend to be time-consuming and can generate errors (intentional or not);
- Operational and manual routines imply process failures and lack of standardization;
- Without management, standardization, control and automation in the processes, it can compromise Confidentiality, Integrity and Availability of information;
- And share solutions openly to everyone so that they can help us in some way.

## How-to
Before execute the codes included in this repository, follow the steps above:
1. On console of Google Cloud Platform (GCP), create one project
2. Enable API: APIs & Services > Library > Admin SDK API
3. Create one service account in this project
4. Create credential to this service account with JSON format (DON'T SHARE THIS KEY WITH ANYONE!!!)
5. On *Admin* of *Google Workspace* (admin.google.com), navigate to Security > Access and data control > API controls, so click on Domain wide delegation. You will need of client_id value (within JSON file). Get this value and fill on Client ID field and put the oauth scopes above:  
- https://www.googleapis.com/auth/admin.directory.user
- https://www.googleapis.com/auth/admin.directory.group
6. Replace the *credentials.json* located on *files* folder with JSON downloaded before. Maintain the same name or will need change the value on *variables.tf*
7. Run the command to download the Google packages and compress the *lambda_function* folder (within *files*) as *lambda_function.zip*. Put *lambda_function.zip* within *files* folder
```
$ pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib -t ./files/lambda_function/
```
8. Make sure these files (*credentials.json* and *lambda_function.zip*) are with the same names and folders structure. If not, change the values located on *variables.tf*.
9. On *variables.tf*, change the value *delegated_account* with Administrator account (Google Workspace Admin privileges). It is recommended do not change the *prefix* and *prod_stage* values!). The region used is *us-west-2*

### Building the remote-state and lock state for Terraform structure
10. On Terminal, enter the *remote-state* folder and run the command:
```
terraform init
terraform apply
```

### Building the remote-state and lock state for Terraform structure
11. On the same Terminal session, go to *root* folder and run the following codes:
```
terraform init
terraform apply
```
12. After all, get the invoke URL for POST requests and the API key on AWS API Gateway (Plan usage > API keys section). With these information, put them on webhook configuration of third-party application, using:
- Web request URL for webhooks
- Method POST
- In Headers section, put *x-api-key* and the value key generated on AWS API Gateway
- In body section, with JSON (key and value format) get the values of application with the keys declared on *lambda_function.py*: *first_name*, *last_name* and *email*

Done! Now all POST requests triggered by 3rd-party application send the information to create user on Google Workspace!!! Go ahead with tests and use the imagination and Google`s documentation above to create more automated functions :)
https://developers.google.com/resources/api-libraries/documentation/admin/directory_v1/python/latest/index.html

## Destroying the Terraform structure
Use **terraform destroy** in the *root* and *remote-state* (do not forget to empty the s3 folder before remote state destroy) folders.
