# Network 
# Create a core virtual network for the tenancy
resource "oci_core_virtual_network" "ampere_vcn" {
  cidr_block     = var.oci_vcn_cidr_block
  compartment_id = var.tenancy_ocid
  display_name   = "AmpereVirtualCoreNetwork"
  dns_label      = "amperevcn"
}

# Within that Core network create a subnet
resource "oci_core_subnet" "ampere_subnet" {
  cidr_block        = var.oci_vcn_cidr_subnet
  display_name      = "AmpereSubnet"
  dns_label         = "Ampere"
  security_list_ids = [oci_core_security_list.ampere_security_list.id]
  compartment_id    = var.tenancy_ocid
  vcn_id            = oci_core_virtual_network.ampere_vcn.id
  route_table_id    = oci_core_route_table.ampere_route_table.id
  dhcp_options_id   = oci_core_virtual_network.ampere_vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "ampere_internet_gateway" {
  compartment_id = var.tenancy_ocid
  display_name   = "AmpereInternetGateway"
  vcn_id         = oci_core_virtual_network.ampere_vcn.id
}

resource "oci_core_route_table" "ampere_route_table" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_virtual_network.ampere_vcn.id
  display_name   = "AmpereRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ampere_internet_gateway.id
  }
}
