# Outputs
output "Navigate your browser to this IP to claim your Threat Manager Appliance" {
    value = "${aws_eip.tmc.public_ip}"
}

output "Copy this Security Group ID into the destination fields of the new egress rules for the protected hosts' Security Groups" {
	value = "${aws_security_group.tmc_sg.id}"
}
