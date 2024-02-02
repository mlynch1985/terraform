# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_detective_graph" "region1" {
  provider = aws.region1
}

resource "aws_detective_graph" "region2" {
  provider   = aws.region2
  depends_on = [aws_detective_graph.region1]
}

resource "aws_detective_graph" "region3" {
  provider   = aws.region3
  depends_on = [aws_detective_graph.region2]
}

# resource "aws_detective_graph" "region4" {
#   provider = aws.region4
#   depends_on = [aws_detective_graph.region3]
# }

resource "aws_detective_organization_configuration" "region1" {
  auto_enable = true
  graph_arn   = aws_detective_graph.region1.id
  provider    = aws.region1
  depends_on  = [aws_detective_graph.region1]
}

resource "aws_detective_organization_configuration" "region2" {
  auto_enable = true
  graph_arn   = aws_detective_graph.region2.id
  provider    = aws.region2
  depends_on  = [aws_detective_graph.region2]
}

resource "aws_detective_organization_configuration" "region3" {
  auto_enable = true
  graph_arn   = aws_detective_graph.region3.id
  provider    = aws.region3
  depends_on  = [aws_detective_graph.region3]
}

# resource "aws_detective_organization_configuration" "region4" {
#   auto_enable = true
#   graph_arn   = aws_detective_graph.region4.id
#   provider = aws.region4
#   depends_on = [aws_detective_graph.region4]
# }
