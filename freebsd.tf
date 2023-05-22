# "FreeBSD OS"
resource "oci_marketplace_accepted_agreement" "freebsd_accepted_agreement" {
  agreement_id    = oci_marketplace_listing_package_agreement.freebsd_package_agreement.agreement_id
  compartment_id  = var.tenancy_ocid
  listing_id      = data.oci_marketplace_listing.freebsd.id
  package_version = data.oci_marketplace_listing.freebsd.default_package_version
  signature       = oci_marketplace_listing_package_agreement.freebsd_package_agreement.signature
}
resource "oci_marketplace_listing_package_agreement" "freebsd_package_agreement" {
  agreement_id    = data.oci_marketplace_listing_package_agreements.freebsd_package_agreements.agreements[0].id
  listing_id      = data.oci_marketplace_listing.freebsd.id
  package_version = data.oci_marketplace_listing.freebsd.default_package_version
}
data "oci_marketplace_listings" "freebsd" {
  pricing        = ["Free"]
  name           = ["FreeBSD"]
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_package_agreements" "freebsd_package_agreements" {
  listing_id      = data.oci_marketplace_listing.freebsd.id
  package_version = data.oci_marketplace_listing.freebsd.default_package_version
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_package" "freebsd_package" {
  listing_id      = data.oci_marketplace_listing.freebsd.id
  package_version = data.oci_marketplace_listing.freebsd.default_package_version
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_packages" "freebsd_packages" {
  listing_id     = data.oci_marketplace_listing.freebsd.id
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing" "freebsd" {
  listing_id     = data.oci_marketplace_listings.freebsd.listings[0].id
  compartment_id = var.tenancy_ocid
}
data "oci_core_app_catalog_listing_resource_versions" "freebsd_app_catalog_listing_resource_versions" {
  listing_id     = data.oci_marketplace_listing_package.freebsd_package.app_catalog_listing_id
}
data "oci_core_app_catalog_listing_resource_version" "freebsd_catalog_listing" {
  listing_id       = data.oci_marketplace_listing_package.freebsd_package.app_catalog_listing_id
  resource_version = data.oci_marketplace_listing_package.freebsd_package.app_catalog_listing_resource_version
}
resource "oci_core_app_catalog_listing_resource_version_agreement" "freebsd_app_catalog_listing_resource_version_agreement" {
  listing_id               = data.oci_marketplace_listing_package.freebsd_package.app_catalog_listing_id
  listing_resource_version = data.oci_core_app_catalog_listing_resource_versions.freebsd_app_catalog_listing_resource_versions.app_catalog_listing_resource_versions[0].listing_resource_version
}
resource "oci_core_app_catalog_subscription" "freebsd_app_catalog_subscription" {
  compartment_id           = var.tenancy_ocid
  eula_link                = oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement.eula_link
  listing_id               = oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement.listing_id
  listing_resource_version = oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement.listing_resource_version
  oracle_terms_of_use_link = oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement.oracle_terms_of_use_link
  signature                = oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement.signature
  time_retrieved           = oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement.time_retrieved
}

# Output OCI FreeBSD Image ID
output OCI_FreeBSD_OS_Image_id {
    value   = data.oci_core_app_catalog_listing_resource_version.freebsd_catalog_listing.listing_resource_id
}
