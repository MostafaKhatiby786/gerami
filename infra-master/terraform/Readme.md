## Install providers without internet

```bash
terraform init -plugin-dir .terraform/providers/
``




.....bash

cd ~/tf_cache

mkdir -p registry.terraform.io/hashicorp/vsphere/2.0.0/linux_amd64/
wget https://releases.hashicorp.com/terraform-provider-vsphere/2.0.0/terraform-provider-vsphere_2.0.0_linux_amd64.zip
unzip terraform-provider-vsphere_2.0.0_linux_amd64.zip -d registry.terraform.io/hashicorp/vsphere/2.0.0/linux_amd64/

terraform init -plugin-dir ~/tf_cache



................


`