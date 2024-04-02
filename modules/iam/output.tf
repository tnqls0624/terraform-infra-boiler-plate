output "iam_ecs_task_execution_arn" {
  description = "The arn of the ecs_task_execution"
  value = aws_iam_role.ecs_task_execution.arn
}

output "iam_policy_ECR_FullAccess_arn" {
  description = "The ARN of the IAM policy for ECR_FullAccess"
  value       = aws_iam_policy.ECR_FullAccess.arn
}

output "iam_code_build_arn" {
  description = "The ARN of the IAM policy for Code Build"
  value       = aws_iam_role.code_build.arn
}

output "iam_code_pipeline_arn" {
  description = "The ARN of the IAM policy for Code Pipeline"
  value       = aws_iam_role.code_pipeline.arn
}