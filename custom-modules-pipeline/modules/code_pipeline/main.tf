resource "aws_codepipeline" "code_pipeline" {
  name     = var.codepipeline_name
  role_arn = var.role_arn

  artifact_store {
    location = var.bucket_name
    type     = "S3"

    encryption_key {
      id   = var.pipeline_key_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      owner    = "AWS"
      name     = "Source"
      provider = "CodeCommit"
      version  = "1"

      configuration = {
        "RepositoryName"       = var.codecommit_name
        "BranchName"           = "main"
        "PollForSourceChanges" = false
      }

      output_artifacts = ["source_output"]
    }
  }

  stage {
    name = "Build"

    action {
      category = "Build"
      owner    = "AWS"
      name     = "Build"
      provider = "CodeBuild"
      version  = "1"

      configuration = {
        "ProjectName" = var.codebuild_name
      }

      input_artifacts = ["source_output"]
    }
  }
}
