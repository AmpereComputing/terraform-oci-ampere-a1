
output "oci_aarch64_images_map" {
  sensitive = false
  value = zipmap(
    [
      "${data.oci_marketplace_listing.almalinux_8.name}${data.oci_core_app_catalog_listing_resource_version.almalinux_8_catalog_listing.listing_resource_version}",
      "${data.oci_marketplace_listing.almalinux_9.name}${data.oci_core_app_catalog_listing_resource_version.almalinux_9_catalog_listing.listing_resource_version}",
      "${data.oci_marketplace_listing.freebsd.name}${data.oci_core_app_catalog_listing_resource_version.freebsd_catalog_listing.listing_resource_version}",
      data.oci_core_images.oraclelinux-8_4-aarch64.images.0.display_name,
      data.oci_core_images.oraclelinux-7_9-aarch64.images.0.display_name,
      data.oci_core_images.ubuntu-20_04-aarch64.images.0.display_name,
      data.oci_core_images.ubuntu-18_04-aarch64.images.0.display_name
    ],
    [
      data.oci_core_app_catalog_listing_resource_version.almalinux_8_catalog_listing.listing_resource_id,
      data.oci_core_app_catalog_listing_resource_version.almalinux_9_catalog_listing.listing_resource_id,
      data.oci_core_app_catalog_listing_resource_version.freebsd_catalog_listing.listing_resource_id,
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
      "${data.oci_marketplace_listing.almalinux_8.name}${data.oci_core_app_catalog_listing_resource_version.almalinux_8_catalog_listing.listing_resource_version}",
      "${data.oci_marketplace_listing.almalinux_9.name}${data.oci_core_app_catalog_listing_resource_version.almalinux_9_catalog_listing.listing_resource_version}",
      "${data.oci_marketplace_listing.freebsd.name}${data.oci_core_app_catalog_listing_resource_version.freebsd_catalog_listing.listing_resource_version}",
      data.oci_core_images.oraclelinux-8_4-aarch64.images.0.display_name,
      data.oci_core_images.oraclelinux-7_9-aarch64.images.0.display_name,
      data.oci_core_images.ubuntu-20_04-aarch64.images.0.display_name,
      data.oci_core_images.ubuntu-18_04-aarch64.images.0.display_name
    ],
    [
      data.oci_core_app_catalog_listing_resource_version.almalinux_8_catalog_listing.listing_resource_id,
      data.oci_core_app_catalog_listing_resource_version.almalinux_9_catalog_listing.listing_resource_id,
      data.oci_core_app_catalog_listing_resource_version.freebsd_catalog_listing.listing_resource_id,
      data.oci_core_images.oraclelinux-8_4-aarch64.images.0.id,
      data.oci_core_images.oraclelinux-7_9-aarch64.images.0.id,
      data.oci_core_images.ubuntu-20_04-aarch64.images.0.id,
      data.oci_core_images.ubuntu-18_04-aarch64.images.0.id,
    ]
  )

    oci_aarch64_image_names = tolist(keys(local.oci_aarch64_images))
    oci_aarch64_image_ids   = tolist(values(local.oci_aarch64_images))
    os_images = {
      almalinux8 = {
        os_image_id = data.oci_core_app_catalog_listing_resource_version.almalinux_8_catalog_listing.listing_resource_id
      }
      almalinux9 = {
        os_image_id = data.oci_core_app_catalog_listing_resource_version.almalinux_9_catalog_listing.listing_resource_id
      }
      freebsd        = {
        os_image_id = data.oci_core_app_catalog_listing_resource_version.freebsd_catalog_listing.listing_resource_id
      }
      oraclelinux84  = {
        os_image_id  = data.oci_core_images.oraclelinux-8_4-aarch64.images.0.id
      }
      oraclelinux79  = {
        os_image_id  = data.oci_core_images.oraclelinux-7_9-aarch64.images.0.id
      }
      ubuntu2004     = {
        os_image_id  = data.oci_core_images.ubuntu-20_04-aarch64.images.0.id
      }
      ubuntu1804     = {
        os_image_id  = data.oci_core_images.ubuntu-18_04-aarch64.images.0.id
      }
   }

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

