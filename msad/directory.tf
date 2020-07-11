resource "random_password" "password" {
    length = 24
    special = true
    override_special = "/@"
}

resource "aws_secretsmanager_secret" "password" {
    name = "sample-msad-password"
    description = "Sample MS Active Directory Root Password"
    recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "password" {
    secret_id = aws_secretsmanager_secret.password.id
    secret_string = random_password.password.result
}

resource "aws_directory_service_directory" "directory" {
    depends_on = [aws_secretsmanager_secret_version.password]
    name = "corp.example.com"
    short_name = "CORP"
    description = "Sample Microsoft Active Directory"
    password = random_password.password.result
    edition = "Enterprise"
    type = "MicrosoftAD"
    vpc_settings {
        vpc_id = data.aws_vpc.vpc.id
        subnet_ids = [
            data.aws_subnet.private-a.id,
            data.aws_subnet.private-b.id
        ]
    }
}
