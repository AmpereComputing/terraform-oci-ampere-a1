resource "oci_core_instance" "ampere_a1" {
  count               = var.oci_vm_count
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains.0.name
  compartment_id      = var.tenancy_ocid
  display_name        = "AmpereA1-0"
  shape               = "VM.Standard.A1.Flex"

  create_vnic_details {
    subnet_id        = oci_core_subnet.ampere_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = format("${var.instance_prefix}-%02d", count.index+1)
  }

  shape_config {

    memory_in_gbs = var.ampere_a1_vm_memory
    ocpus         = var.ampere_a1_cpu_core_count
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oraclelinux-8_4-aarch64.images.0.id
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.oci.public_key_openssh
    user_data = "${base64encode(data.template_file.cloud_config.rendered)}"
    
  }
}
