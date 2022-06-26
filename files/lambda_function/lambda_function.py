import json
import os
import boto3
from google.oauth2 import service_account
from googleapiclient.discovery import build

# Set API permissions with scopes
SCOPES = ['https://www.googleapis.com/auth/admin.directory.user','https://www.googleapis.com/auth/admin.directory.group']

# Get values from environment variables
REGION = os.environ.get('REGION')
SUBJECT = os.environ.get('SUBJECT')
PARAM_KEY = os.environ.get('PARAM_KEY')

# Lambda triggers with parameters from API request
def lambda_handler(event, context):
    
    # Register in CloudWatch logs
    print(event)

    # Get values from function defined this
    param_value = get_parameters(PARAM_KEY)

    # Loads the json with values to authentication
    service_account_info = json.loads(param_value)
    credentials = service_account.Credentials.from_service_account_info(
        service_account_info, scopes=SCOPES)

    # Delegates to the service account permissions with another Admin account (user type, different from service account) 
    credentials_delegated = credentials.with_subject(SUBJECT)

    # Get values from parameters 
    first_name = event['first_name']
    last_name = event['last_name']
    email = event['email']
    # issue_key = event['issue_key']
    # department = event['department']
    # initial_date = event['initial_date']

    # Object to intialize methods
    service = build('admin', 'directory_v1', credentials=credentials_delegated)

    # Create users on GSuite
    user_infos = {
    "name": {
        "familyName": last_name,
        "givenName": first_name
    },
    "password": "Password@123",
    "primaryEmail": email
    }
    response_user = service.users().insert(body=user_infos).execute()
    print(response_user)

    # # Add user to group
    # member_infos = {
    # "email": email,
    # "role": "MEMBER",
    # "type": "USER"
    # }
    # response_group = service.members().insert(groupKey='<id_google_group>',body=member_infos).execute()
    # print(response_group)

# Get secret values from AWS SSM (default on Google documentation)
def get_parameters(param_key):
    ssm = boto3.client('ssm', region_name=REGION)
    response = ssm.get_parameters(
        Names=[
            param_key,
        ],
        WithDecryption=True
    )
    return response['Parameters'][0]['Value']
