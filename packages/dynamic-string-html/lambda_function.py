import boto3

def lambda_handler(event, context):
    # Initialize the DynamoDB client
    dynamodb = boto3.client('dynamodb')
    
    table_name = 'db-dynamic-string'
    
    try:
        # Retrieve data from DynamoDB
        response = dynamodb.get_item(
            TableName=table_name,
            Key={
                'id': {'S': '1'}  
            }
        )
        
        # Extract the text attribute from the DynamoDB response
        text_from_dynamodb = response['Item']['dynamicstring']['S']
        
        # Create an HTML page with the retrieved text
        html_content = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <title>DevOps Technical Challenge</title>
        </head>
        <body>
            <h1>The saved string is: {text_from_dynamodb}</h1>
        </body>
        </html>
        """
        
        # Return the HTML content as the HTTP response
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'text/html',
            },
            'body': html_content
        }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error: {str(e)}"
        }
