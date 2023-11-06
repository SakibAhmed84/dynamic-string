 Deployment of this resources will create the following AWS objects:

- 1 x IAM role with Relevant permission for the lambda functions
- 2 x Lambda functions i.e. an HTML frontend page that displays a dynamic string and an API URL which can be passed with some values to manipulate that dynamic string
- 1 x DynamoDB Table which will hold the dynamic string  

# Pre-Requisites: 

- AWS Account
- IAM user with full Permission to AWSLambda, AWSDynamoDB, IAMFullAccess at least
- Access Key and Secret for the above User 
- A Linux Machine / VM with Internet Access
- Terraform v1.6.0


# How to Deploy: 

- Clone the Repo 
- Edit the deploy.tf file and insert your AWS Access Key and Secret at relevant lines under Provider section and save the changes

	    access_key = "INSERT_AWS_ACCESS_KEY"
	    secret_key = "INSERT_SECRET"


- Run Terraform init, plan and apply. If no issues this should deploy the services in your AWS account in London Region


# Usage:

- Run command: 
	"terraform state show aws_lambda_function_url.dynamic_string_html_url" 
  and copy the URL String in function_url. e.g. https://xxxxxxx.lambda-url.eu-west-2.on.aws/ this is the URL of the Frontend HTML Page

- Run command: 
	"terraform state show aws_lambda_function_url.dynamic_string_updater_url" 
  and copy the URL String in function_url. e.g. https://xxxxxxx.lambda-url.eu-west-2.on.aws/ this is the URL of the API end point where the dynamic string can be manipulated

- Open the two URLs in two different Tabs in a broswer. My preference is Firefox as it shows the transactions / errors in detail 

- Initially both the URLs will not show anything

- Now at the end of second URL add "?new_value=AnyStringValue" (without the quotes) e.g. https://xxxxxxx.lambda-url.eu-west-2.on.aws?new_value=hello-world if successful this will return a HTTP 200 response

- If the first URL is now refreshed the page will show a Message: The saved string is: hello-world

- To change the string Dynamically just repeat the step with a new string value.

# Change Log:

As of 05/11/2023 it is no longer required to perform the first two steps i.e. running the terraform state show command in order to retrieve the URLs. They are now displayed on screen after the TF apply is performed using Output function.

Example: 

- output_dynamic_string_html_url    = "https://xxxx.lambda-url.eu-west-2.on.aws/"
- output_dynamic_string_updater_url = "https://abcd.lambda-url.eu-west-2.on.aws/"

The outputs are kept in the state file therefore can be called anytime using the command "terraform output". It is a handy feature to obtain the URLs in the future very easily. 
