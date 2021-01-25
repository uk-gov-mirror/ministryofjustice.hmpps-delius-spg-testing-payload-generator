module "payload-generator-release-pipeline" {
  source            = "git::https://github.com/ministryofjustice/hmpps-delius-spg-codepipeline.git//terraform/ci-components/codepipeline?ref=main"
  approval_required = false
  artefacts_bucket  = local.artefacts_bucket
  pipeline_name     = local.payload_generator_release_pipeline_name
  iam_role_arn      = local.iam_role_arn
  log_group         = local.log_group_name
  tags              = local.tags
  cache_bucket      = local.cache_bucket
  codebuild_name    = local.payload_generator_release_pipeline_name
  github_repositories = {
    SourceArtifact = ["hmpps-delius-spg-testing-payload-generator", var.release_branch_name]
  }
  stages = [
    {
      name = "Build"
      actions = [
        {
          action_name      = "Build"
          codebuild_name   = "spgw-maven-artifact-publisher"
          input_artifacts  = "SourceArtifact"
          output_artifacts = "BuildArtifact"
          namespace        = "BuildVariables"
          action_env       = null
        }
      ]
    }
  ]
}