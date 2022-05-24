
output "oci_aarch64_images_map" {
  sensitive = false
  value = zipmap(
    [

      "${data.oci_marketplace_listing.almalinux_8_5.name}${data.oci_core_app_catalog_listing_resource_version.almalinux_8_5_catalog_listing.listing_resource_version}",
#     data.oci_core_app_catalog_listing_resource_version.almalinux_8_5_catalog_listing.listing_id,
      data.oci_core_images.oraclelinux-8_4-aarch64.images.0.display_name,
      data.oci_core_images.oraclelinux-7_9-aarch64.images.0.display_name,
      data.oci_core_images.ubuntu-20_04-aarch64.images.0.display_name,
      data.oci_core_images.ubuntu-18_04-aarch64.images.0.display_name
    ],
    [
      data.oci_core_app_catalog_listing_resource_version.almalinux_8_5_catalog_listing.listing_resource_id,
      data.oci_core_images.oraclelinux-8_4-aarch64.images.0.id,
      data.oci_core_images.oraclelinux-7_9-aarch64.images.0.id,
      data.oci_core_images.ubuntu-20_04-aarch64.images.0.id,
      data.oci_core_images.ubuntu-18_04-aarch64.images.0.id
    ]
  )
}

locals {
    oci_aarch64_images = zipmap(
    [
      "${data.oci_marketplace_listing.almalinux_8_5.name}${data.oci_core_app_catalog_listing_resource_version.almalinux_8_5_catalog_listing.listing_resource_version}",
      #data.oci_core_app_catalog_listing_resource_version.almalinux_8_5_catalog_listing.listing_resource_version,
      data.oci_core_images.oraclelinux-8_4-aarch64.images.0.display_name,
      data.oci_core_images.oraclelinux-7_9-aarch64.images.0.display_name,
      data.oci_core_images.ubuntu-20_04-aarch64.images.0.display_name,
      data.oci_core_images.ubuntu-18_04-aarch64.images.0.display_name
    ],
    [
      data.oci_core_app_catalog_listing_resource_version.almalinux_8_5_catalog_listing.listing_resource_id,
      data.oci_core_images.oraclelinux-8_4-aarch64.images.0.id,
      data.oci_core_images.oraclelinux-7_9-aarch64.images.0.id,
      data.oci_core_images.ubuntu-20_04-aarch64.images.0.id,
      data.oci_core_images.ubuntu-18_04-aarch64.images.0.id,
    ]
  )

    oci_aarch64_image_names = tolist(keys(local.oci_aarch64_images))
    oci_aarch64_image_ids = tolist(values(local.oci_aarch64_images))

}

output "local_oci_aarch64_images_map" {
  value = local.oci_aarch64_images
  sensitive = false
}

output "local_oci_aarch64_image_names" {
  value = local.oci_aarch64_image_names
  sensitive = false
}
output "local_oci_aarch64_image_ids" {
  value = local.oci_aarch64_image_ids
  sensitive = false
}
