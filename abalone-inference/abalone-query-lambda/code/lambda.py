import logging
import time
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
athena_client = boto3.client('athena')

def handler(event, context):
    """
    Lambda function to run an athena query that gets the abalones we want.
    """
    logger.info("Received event: %s", event)

    database = event.get('database')
    bucket = event.get('bucket')
    sex = event.get('sex')
    # raise exception if the event does not contain the required parameters
    if not database or not bucket or not sex:
        raise ValueError("Event must contain 'database' and 'bucket' and 'sex' parameters")

    try:
        query_string = f"SELECT * FROM abalone WHERE sex IN ({sex})"
        query_execution_id = run_athena_query(query_string, database, bucket)
        if not has_query_succeeded(query_execution_id):
            raise Exception(f"Query {query_execution_id} did not complete successfully.")
        return {
            "results_location" : get_query_results_location(query_execution_id)
        }
    except ClientError as e:
        logger.error("Error running query: %s", e)
        raise e


def run_athena_query(query_string, database, bucket):
    logger.info("Running query: %s", query_string)
    response = athena_client.start_query_execution(
        QueryString=query_string,
        QueryExecutionContext={'Database': database},
        ResultConfiguration={
            'OutputLocation': f's3://{bucket}/athena-results/'
        }
    )
    query_execution_id = response['QueryExecutionId']
    logger.info("Query execution started with ID: %s", query_execution_id)
    return query_execution_id

def has_query_succeeded(execution_id):
    state = "RUNNING"
    max_execution = 5

    while max_execution > 0 and state in ["RUNNING", "QUEUED"]:
        max_execution -= 1
        response = athena_client.get_query_execution(QueryExecutionId=execution_id)
        if (
                "QueryExecution" in response
                and "Status" in response["QueryExecution"]
                and "State" in response["QueryExecution"]["Status"]
        ):
            state = response["QueryExecution"]["Status"]["State"]
            if state == "SUCCEEDED":
                return True

        time.sleep(10)

    return False

def get_query_results_location(execution_id):
    response = athena_client.get_query_execution(QueryExecutionId=execution_id)
    output_location = response['QueryExecution']['ResultConfiguration']['OutputLocation']
    logger.info("Athena results S3 location: %s", output_location)
    return output_location