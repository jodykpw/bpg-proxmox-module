resource "proxmox_virtual_environment_file" "cloud_init" {
  for_each = var.vms

  content_type = each.value.cloud_init_content_type
  datastore_id = each.value.cloud_init_datastore_id
  node_name    = each.value.cloud_init_node_name

  source_raw {
    data = <<EOF
#cloud-config
hostname: ${each.value.hostname}
manage_etc_hosts: ${each.value.manage_etc_hosts}
fqdn: ${each.value.fqdn}
timezone: ${each.value.timezone}
chpasswd:
  ## Force password change if admin_password not provided
  expire: ${each.value.admin_password == null ? true : false}
  users:
    - name: ${each.value.admin_username}
      password: ${each.value.admin_password != null ? each.value.admin_password : "password"}
      type: text
write_files:
  - path: /tmp/home_disk_setup.sh
    content: |
      #!/bin/bash
      BLOCK_DEVICE=${each.value.home_disk_block_device}
      echo -e "n\np\n\n\n\nw" | sudo fdisk $BLOCK_DEVICE
      mkfs.xfs $(echo $BLOCK_DEVICE)1
      mkdir /mnt/new_home/
      mount $(echo $BLOCK_DEVICE)1 /mnt/new_home/
      rsync -avh /home/ /mnt/new_home/
      UUID=$(blkid $(echo $BLOCK_DEVICE)1 | awk '{print $2}' | sed 's/"//g')
      echo "$UUID /mnt/new_home xfs defaults 0 0" | sudo tee -a /etc/fstab
users:
${join("\n", [
  for u in each.value.users : <<EOT
  - name: ${u.username}
${u.uid != null ? "    uid: ${u.uid}" : ""}
${u.gid != null ? "    gid: ${u.gid}" : ""}
    groups: "${join(", ", u.groups)}"
    sudo: "${u.sudo}"
    shell: ${u.shell}
    ssh_authorized_keys:
${join("\n", [for key in u.ssh_authorized_keys : "      - ${key}"])}
EOT
])}
package_upgrade: ${each.value.package_upgrade}
${length(each.value.packages) > 0 ? "packages:\n${join("\n", [for pkg in each.value.packages : "  - ${pkg}"])}" : ""}
${length(each.value.runcmd) > 0 ? "runcmd:\n${join("\n", [for cmd in each.value.runcmd : "  - ${cmd}"])}" : ""}
power_state:
    delay: now
    mode: reboot
    message: Rebooting after cloud-init completion
    condition: true
EOF

    file_name = "vm-${each.value.name}-cloud-init.yaml"
  }
}