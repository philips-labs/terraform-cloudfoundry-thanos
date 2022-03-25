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
  environment = var.environment
  command     = "/sidecars/bin/thanos_s3.sh compact --wait --data-dir=/prometheus --objstore.config-file=/sidecars/etc/bucket_config.yaml"
  service_binding {
    service_instance = cloudfoundry_service_instance.s3.id
  }
}
