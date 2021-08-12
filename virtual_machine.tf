resource "oci_core_instance" "free_instance0" {
  availability_domain = var.oci_availability_domain
  compartment_id      = var.compartment_ocid
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
    source_id   = var.image_ocid
  }

  metadata = {
    ssh_authorized_keys = local.ssh_public_key
  }
}
