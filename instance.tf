resource "aws_instance" "jenkins-instance" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.medium"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.jenkins-securitygroup.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  # user data
  user_data = data.template_cloudinit_config.cloudinit-jenkins.rendered
  
  connection {
  private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
  user        = "${var.ansible_user}"
  host     = "${aws_instance.jenkins-instance.public_ip}"
}

  # Ansible requires Python to be installed on the remote machine as well as the local machine.

provisioner "remote-exec" {
    inline = [
        "sudo apt-get update",
        "sudo apt-get install -y python",
		"sudo tail -50 /var/log/cloud-init-output.log",
		"sudo sleep 10",
		"sudo tail -50 /var/log/cloud-init-output.log",
    ]
}


  

}



resource "aws_ebs_volume" "jenkins-data" {
  availability_zone = "eu-west-1a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "jenkins-data"
  }
}

resource "aws_volume_attachment" "jenkins-data-attachment" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.jenkins-data.id
  instance_id  = aws_instance.jenkins-instance.id
  skip_destroy = true
  
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
	  >hosts.ini;
	  echo "[ansible]" | tee -a hosts.ini;
	  echo "${aws_instance.jenkins-instance.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.PATH_TO_PRIVATE_KEY}" | tee -a hosts.ini;
      export ANSIBLE_HOST_KEY_CHECKING=False;
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.PATH_TO_PRIVATE_KEY} -i hosts.ini playbooks/install_java.yaml
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.PATH_TO_PRIVATE_KEY} -i hosts.ini playbooks/install_jenkins.yaml
    EOT
  }

  connection {
  private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
  user        = "${var.ansible_user}"
  host     = "${aws_instance.jenkins-instance.public_ip}"
}

provisioner "remote-exec" {
    inline = [
		"sudo tail -50 /var/log/cloud-init-output.log"
    ]
}
  
}



