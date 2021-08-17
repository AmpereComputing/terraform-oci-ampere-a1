resource "oci_core_instance" "ampere_a1" {
# Using the Default Availability Domain
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains.0.name
# compartment_id      = var.compartment_ocid
  compartment_id      = var.tenancy_ocid
  display_name        = "AmpereA1-0"
  shape               = "VM.Standard.A1.Flex"

  create_vnic_details {
    subnet_id        = oci_core_subnet.ampere_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "ampere-a1-0"
  }

  shape_config {

    #Optional
    #baseline_ocpu_utilization = var.instance_shape_config_baseline_ocpu_utilization
    # https://blogs.oracle.com/cloud-infrastructure/post/oracle-makes-building-applications-on-ampere-a1-compute-instances-easy?source=:ow:o:p:nav:062520CloudComputeBC
    memory_in_gbs = 24
    ocpus         = var.ampere_a1_cpu_core_count
  }
  source_details {
    source_type = "image"
#   source_id   = var.image_ocid
    source_id   = data.oci_core_images.oraclelinux-8_4-aarch64.images.0.id
  }

  metadata = {
# Add key from your home directory
#    ssh_authorized_keys = "${file("/home/ansible/.ssh/id_rsa.pub")}"
#   ssh_authorized_keys = "${file(tls_private_key.oci.public_key_openssh)}"
    ssh_authorized_keys = tls_private_key.oci.public_key_openssh
    user_data = "${base64encode(data.template_file.cloud_config.rendered)}"
    
  }
}
