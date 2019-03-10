/*
This is the Allegiant Generic VM Contract to be used by the various cloud
providers (eg: aws, vsphere, goolge cloud, azure, rackspace, etc . .)

If a variable has a default value it may be considered optional to those
standing up new hosts using this contract.

All variables should be implemented by the provider terraforms.
*/

# VM INSTANCE INFORMATION

variable "name" {
  type = "string"
  description = "The human readable name of the instance."
}

variable "type" {
  type = "string"
  description = "The type of VM instance.  (eg: t2, m5, dedicated, etc )."
}

variable "size" {
  type = "string"
  description = <<EOF
  Defines the cpu/ram for the VM:
  ===================
  size     cpu  ram
  ===================
  micro    1    1
  small    1    2
  medium   2    4
  large    2    8
  xlarge   4    16
  2xlarge  8    32
  4xlarge  16   64
  8xlarge  32   128
  16xlarge 64   256
EOF
}

variable "location" {
  type = "string"
  description = "Location of the instance (eg: hq, us-west-2, vsw, ndd, etc )"
}

variable "network_info" {
  type = "map"
  description =  <<EOF
  The information descibing the vpc/subnet, vlan, etc to which the vm will
  be attached.
EOF
}

variable "os_image" {
  type = "string"
  description = "The name of the ami, vsphere, etc image"
}

variable "fw_options" {
  type = "map"
  default = {
    count = "2"

    rule0.type  = "ingress"
    rule0.from  = "22"
    rule0.to    = "22"
    rule0.prot  = "tcp"
    rule0.cidr = "10.88.0.0/16,10.97.0.0/16"

    rule1.type  = "egress"
    rule1.from  = "0"
    rule1.to    = "0"
    rule1.prot  = "-1"
    rule1.cidr = "0.0.0.0/0"

  }
  description = "Optional settings for firewalls like aws security groups"
}

variable root_disk {
  type = "map"
  description = "The root disk to be attached to the VM."
  default = {
    size = "10"        # Size in GB
    type = "gp2"       # Type of disk
    delete  = "True"   # Delete on termination
  }
}

variable extra_disks {
  type = "map"
  description = "Other disks to be attached to the VM."
  default = {
    num_disks  = "0"           # The Number of extra disks (default: None)

    disk0.size = "10"          # Size in GB
    disk0.type = "gp2"         # Type of disk
    disk0.name = "/dev/sdh"    # The name of the device in the Linux
    disk0.zone = "us-west-2b"  # The name of the availability zone
  }
}

variable tags {
  type = "map"
  description = "List of tags to be add to the instance."
  default = {

  }
}

variable extra_vars {
  type = "map"
  description = "Cloud specific variables like aws_profile"
  default = {
    aws_profile = "697867080916"
    no_api_termination = "False"
    public_ip_address = "False"
    shutdown_type = "stop"
    aws_key = "aws_devops_master_us-west-2"
    iam_role = ""
  }
}


variable "post_provision" {
  type = "map"
  default = {
      path = "ansible/"
      base = "post.sh"
      user = "ec2-user"
      branch = "master"
      extra_args = "--ask-vault"
    }
  description = "User specified options for post provision script"
}