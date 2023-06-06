resource "cloudfoundry_app" "thanos_compactor" {
  count             = var.thanos_compactor_enabled ? 1 : 0
  name              = "tf-thanos-compactor-${local.postfix}"
  space             = var.cf_space_id
  memory            = var.thanos_compactor_memory
  disk_quota        = var.thanos_compactor_disk_quota
  docker_image      = var.thanos_compactor_image
  health_check_type = "process"
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }
  environment = merge(
    {
      S3_BUCKET     = cloudfoundry_service_key.s3.credentials["bucket"]
      S3_ENDPOINT   = cloudfoundry_service_key.s3.credentials["endpoint"]
      S3_API_KEY    = cloudfoundry_service_key.s3.credentials["api_key"]
      S3_SECRET_KEY = cloudfoundry_service_key.s3.credentials["secret_key"]
      S3_URI        = cloudfoundry_service_key.s3.credentials["uri"]
    },
    var.environment
  )
  command = "/sidecars/bin/thanos_s3_sk.sh compact --wait --data-dir=/prometheus --objstore.config-file=/sidecars/etc/bucket_config.yaml"
}
