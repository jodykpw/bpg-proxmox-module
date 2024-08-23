resource "proxmox_virtual_environment_download_file" "cloud_image" {
  for_each = var.vms

  content_type        = each.value.cloud_image_content_type
  datastore_id        = each.value.cloud_image_datastore_id
  url                 = each.value.cloud_image_url
  file_name           = each.value.cloud_image_file_name
  node_name           = each.value.cloud_image_node_name
  overwrite           = each.value.cloud_image_overwrite
  overwrite_unmanaged = each.value.cloud_image_overwrite_unmanaged
}