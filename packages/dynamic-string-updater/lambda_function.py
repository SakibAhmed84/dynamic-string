import json
import boto3

dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    # Extract the values from the HTML Request
    form_data = event['queryStringParameters']
    new_value = form_data.get('new_value')
       
    # Update the DynamoDB item with the new value
    response = dynamodb.update_item(
        TableName='db-dynamic-string',  
        Key={
            'id': {'S': '1'} # We are only using Key Index 1 in the DB for a single Dynamic String
        },
        UpdateExpression='SET dynamicstring = :newValue',
        ExpressionAttributeValues={
            ':newValue': {'S': new_value}
        },
        ReturnValues='ALL_NEW'
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }
