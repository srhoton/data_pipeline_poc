# Create an AWS IAM role that allows access to the specified S3 bucket
resource "aws_iam_role" "data_pipeline_poc_s3_access" {
  name               = "S3AccessRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dms.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "dms_vpc_role" {
  name               = "dms-vpc-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dms.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "dms_vpc_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role = aws_iam_role.dms_vpc_role.id
  
}

resource "aws_iam_role_policy" "data_pipeline_poc_s3_access" {
  name = "S3AccessPolicy"
  role = aws_iam_role.data_pipeline_poc_s3_access.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetBucketAcl",
        "s3:GetBucketPolicy",
        "s3:GetBucketVersioning",
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:ListBucketMultipartUploads",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.data_pipeline_poc_bucket.arn}",
        "${aws_s3_bucket.data_pipeline_poc_bucket.arn}/*",
        "${aws_s3_bucket.data_pipeline_poc_output_bucket.arn}",
        "${aws_s3_bucket.data_pipeline_poc_output_bucket.arn}/*",
        "${aws_s3_bucket.data_pipeline_script_bucket.arn}",
        "${aws_s3_bucket.data_pipeline_script_bucket.arn}/*"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_policy" "source_db_s3_access" {
    description = "This policy will be used for Glue Crawler and Job execution. Please do NOT delete!"
    name        = "AWSGlueServiceRole-source-db-s3-access-EZCRC-s3Policy"
    path        = "/service-role/"
    policy      = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "s3:GetObject",
                        "s3:PutObject",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "${aws_s3_bucket.data_pipeline_poc_bucket.arn}*",
                        "${aws_s3_bucket.data_pipeline_poc_output_bucket.arn}*",
                        "${aws_s3_bucket.data_pipeline_script_bucket.arn}*"
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags        = {}
    tags_all    = {}
}

resource "aws_iam_role" "source_db_s3_access" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "glue.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [
        aws_iam_policy.source_db_s3_access.arn,
        "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
    ]
    max_session_duration  = 3600
    name                  = "AWSGlueServiceRole-source-db-s3-access"
    path                  = "/service-role/"
}

resource "aws_iam_role" "data_pipeline_poc_event_role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "events.amazonaws.com"
                    }
                    Sid       = ""
                },
            ]
            Version   = "2012-10-17"
        }
    )
    description           = "Allows CloudWatch Events to invoke targets and perform actions in built-in targets on your behalf."
    force_detach_policies = false
    managed_policy_arns   = [
        "arn:aws:iam::aws:policy/service-role/CloudWatchEventsBuiltInTargetExecutionAccess",
        "arn:aws:iam::aws:policy/service-role/CloudWatchEventsInvocationAccess",
    ]
    max_session_duration  = 3600
    name                  = "data-pipeline-poc-event-role"
    path                  = "/"
    tags                  = {}
    tags_all              = {}

    inline_policy {
        name   = "data-pipeline-poc-glue-event-policy"
        policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
                            "glue:notifyEvent",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "${aws_glue_workflow.data_pipeline_poc_reservations_workflow.arn}",
                        ]
                    },
                ]
                Version   = "2012-10-17"
            }
        )
    }
}

resource "aws_iam_role" "data_pipeline_poc_invoke_glue_role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "events.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [
        "arn:aws:iam::705740530616:policy/service-role/data-pipeline-poc-invoke-glue-role",
    ]
    max_session_duration  = 3600
    name                  = "data-pipeline-poc-invoke-glue-role"
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}
}