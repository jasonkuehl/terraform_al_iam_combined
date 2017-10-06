data "aws_region" "current" {
  current = true
}

data "aws_ami" "tmc" {
  most_recent = true
  filter {
    name = "owner-id"
    values = ["239734009475"]
  }
  name_regex = "^Alertlogic\\sTMC\\s-\\sP\\d{2}$"
  owners = ["239734009475"] # Alertlogic
}

resource "aws_instance" "tmc" {
    count                  = "${var.instance_count}"
    availability_zone      = "${element(var.zones, count.index)}"
    ami                    = "${data.aws_ami.tmc.id}"
    instance_type          = "${var.instance_type}"
    vpc_security_group_ids = ["${aws_security_group.tmc_sg.id}"]
    key_name               = "${var.primary_key_pair}"
    subnet_id              = "${element(var.sn, count.index)}"

    tags {
        Name = "${var.tag_name}-${count.index}-${var.puppet_env}"
    }

    depends_on = ["aws_security_group.tmc_sg"]
}

resource "aws_eip" "tmc" {
  count      = "${var.instance_count}"
  instance   = "${element(aws_instance.tmc.*.id, count.index)}"
  vpc        = true
	depends_on = ["aws_instance.tmc"]
}

resource "aws_security_group" "tmc_sg" {
    name = "Alert Logic Threat Manager Security Group"
    tags {
	    Name = "Alert Logic Threat Manager Security Group"
    }
    vpc_id = "${var.vpc_id}"

    ingress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["204.110.218.96/27"]
                        from_port = 22
                        to_port = 22
                    }
    ingress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["204.110.219.96/27"]
                        from_port = 22
                        to_port = 22
                    }
    ingress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["208.71.209.32/27"]
                        from_port = 22
                        to_port = 22
                    }
    ingress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["204.110.218.96/27"]
                        from_port = 4849
                        to_port = 4849
                    }
    ingress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["204.110.219.96/27"]
                        from_port = 4849
                        to_port = 4849
                    }
    ingress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["208.71.209.32/27"]
                        from_port = 4849
                        to_port = 4849
                    }
    ingress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["${var.monitoringCIDR}"]
                        from_port = 7777
                        to_port = 7777
                    }
    ingress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["${var.monitoringCIDR}"]
                        from_port = 443
                        to_port = 443
                    }
    ingress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["${var.claimCIDR}"]
                        from_port = 80
                        to_port = 80
                    }

    egress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["204.110.218.96/27"]
                        from_port = 443
                        to_port = 443
                    }
    egress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["204.110.219.96/27"]
                        from_port = 443
                        to_port = 443
                    }
    egress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["204.110.218.96/27"]
                        from_port = 4138
                        to_port = 4138
                    }
    egress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["204.110.219.96/27"]
                        from_port = 4138
                        to_port = 4138
                    }
    egress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["208.71.209.32/27"]
                        from_port = 443
                        to_port = 443
                    }
    egress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["208.71.209.32/27"]
                        from_port = 4138
                        to_port = 4138
                    }
    egress
                    {
                        protocol = "udp"
                        cidr_blocks = ["8.8.8.8/32"]
                        from_port = 53
                        to_port = 53
                    }
    egress
                    {
                        protocol = "udp"
                        cidr_blocks = ["8.8.4.4/32"]
                        from_port = 53
                        to_port = 53
                    }
    egress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["8.8.8.8/32"]
                        from_port = 53
                        to_port = 53
                    }
    egress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["8.8.4.4/32"]
                        from_port = 53
                        to_port = 53
                    }
    egress
                    {
                        protocol = "tcp"
                        cidr_blocks = ["0.0.0.0/0"]
                        from_port = 80
                        to_port = 80
                    }
}
