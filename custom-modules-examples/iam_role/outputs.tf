output "id" { value = aws_iam_role.this.id }
output "arn" { value = aws_iam_role.this.arn }
output "name" { value = aws_iam_role.this.name }
output "profile" { value = aws_iam_instance_profile.this[*].name }
