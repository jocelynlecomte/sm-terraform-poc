import logging
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)
sm_client = boto3.client('sagemaker')

def handler(event, context):
    """
    Lambda function to get a model URL from the registry.
    """
    logger.info("Received event: %s", event)

    model_package_group_name = event.get('model_package_group_name')
    if not model_package_group_name:
        raise Exception("Model Package Group name is required in the event.")

    latest_approved_package_arn =  get_latest_approved_package_arn(model_package_group_name)

    model_package_description = sm_client.describe_model_package(ModelPackageName=latest_approved_package_arn)

    logger.info(f"Model package description: {model_package_description}")

    model_data_url = model_package_description["InferenceSpecification"]["Containers"][0]["ModelDataUrl"]

    return {
        "model_data_url": model_data_url,
    }


def get_latest_approved_package_arn(model_package_group_name):
    """Gets the ARN of the latest approved model package for a model package group.
    Args:
        model_package_group_name: The model package group name.
    Returns:
        The SageMaker Model Package ARN.
    """
    try:
        # Get the latest approved model package
        # cf. https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_ListModelPackages.html
        try:
            response = sm_client.list_model_packages(
                ModelPackageGroupName=model_package_group_name,
                ModelApprovalStatus="Approved",
                SortBy="CreationTime",
                MaxResults=100,
            )
        except ClientError as e:
            error_msg = f"list_model_packages failed: {e.response['Error']['Code']}, {e.response['Error']['Message']}"
            raise Exception(error_msg)

        approved_packages = response["ModelPackageSummaryList"]

        # Return error if no packages found
        if len(approved_packages) == 0:
            error_message = (
                f"No approved ModelPackage found for ModelPackageGroup: {model_package_group_name}"
            )
            logger.error(error_message)
            raise Exception(error_message)

        # Return the pmodel package arn
        model_package_arn = approved_packages[0]["ModelPackageArn"]
        logger.info(f"Identified the latest approved model package ARN: {model_package_arn}")
        return model_package_arn
    except ClientError as e:
        error_message = e.response["Error"]["Message"]
        logger.error(error_message)
        raise Exception(error_message)