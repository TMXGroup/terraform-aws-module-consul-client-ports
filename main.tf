terraform {
  required_version = ">= 0.11.5"
}

# https://www.consul.io/docs/agent/options.html#ports
resource "aws_security_group" "consul_client" {
  count = "${var.create ? 1 : 0}"

  name_prefix = "${var.name}-"
  description = "Security Group for ${var.name} Consul"
  vpc_id      = "${var.vpc_id}"
  tags        = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

# Serf LAN (Default 8301) - TCP. This is used to handle gossip in the LAN. Required by all agents on TCP and UDP.
resource "aws_security_group_rule" "serf_lan_tcp" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  source_security_group_id   = "${var.consul_sg_group}"
}
resource "aws_security_group_rule" "serf_lan_tcp_internal" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  source_security_group_id   = "${aws_security_group.consul_client.id}"
}
# Serf LAN (Default 8301) - UDP. This is used to handle gossip in the LAN. Required by all agents on TCP and UDP.
resource "aws_security_group_rule" "serf_lan_udp" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "udp"
  from_port         = 8301
  to_port           = 8301
  source_security_group_id   = "${var.consul_sg_group}"
}
resource "aws_security_group_rule" "serf_lan_udp_internal" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "udp"
  from_port         = 8301
  to_port           = 8301
  source_security_group_id   = "${aws_security_group.consul_client.id}"
}

#Consul Connect Default ports - TCP
resource "aws_security_group_rule" "server_connect_tcp" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 20000
  to_port           = 20255
  source_security_group_id   = "${var.consul_sg_group}"
}
resource "aws_security_group_rule" "server_connect_tcp_internal" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 20000
  to_port           = 20255
  source_security_group_id   = "${aws_security_group.consul_client.id}"
}

# CLI RPC (Default 8400) - TCP. This is used by all agents to handle RPC from the CLI on TCP only.
# This is deprecated in Consul 0.8 and later - all CLI commands were changed to use the
# HTTP API and the RPC interface was completely removed.
resource "aws_security_group_rule" "cli_rpc_tcp" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8400
  to_port           = 8400
  source_security_group_id   = "${var.consul_sg_group}"
}
resource "aws_security_group_rule" "cli_rpc_tcp_interanl" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8400
  to_port           = 8400
  source_security_group_id   = "${aws_security_group.consul_client.id}"
}

# HTTP API (Default 8500) - TCP. This is used by agents to talk to the HTTP API on TCP only.
resource "aws_security_group_rule" "http_api_tcp" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8500
  to_port           = 8500
  source_security_group_id   = "${var.consul_sg_group}"
}
resource "aws_security_group_rule" "http_api_tcp_internal" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8500
  to_port           = 8500
  source_security_group_id   = "${aws_security_group.consul_client.id}"
}

# DNS Interface (Default 8600) - TCP. Used to resolve DNS queries on TCP and UDP.
resource "aws_security_group_rule" "dns_interface_tcp" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8600
  to_port           = 8600
  source_security_group_id   = "${var.consul_sg_group}"
}

resource "aws_security_group_rule" "dns_interface_tcp_internal" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8600
  to_port           = 8600
  source_security_group_id   = "${aws_security_group.consul_client.id}"
}


# DNS Interface (Default 8600) - UDP. Used to resolve DNS queries on TCP and UDP.
resource "aws_security_group_rule" "dns_interface_udp" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "udp"
  from_port         = 8600
  to_port           = 8600
  source_security_group_id   = "${var.consul_sg_group}"
}
resource "aws_security_group_rule" "dns_interface_udp_internal" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "ingress"
  protocol          = "udp"
  from_port         = 8600
  to_port           = 8600
  source_security_group_id   = "${aws_security_group.consul_client.id}"
}
# All outbound traffic - TCP.
resource "aws_security_group_rule" "outbound_tcp" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "egress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = ["0.0.0.0/0"]
}
# All outbound traffic - UDP.
resource "aws_security_group_rule" "outbound_udp_internal" {
  count = "${var.create ? 1 : 0}"

  security_group_id = "${aws_security_group.consul_client.id}"
  type              = "egress"
  protocol          = "udp"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = ["0.0.0.0/0"]
}
