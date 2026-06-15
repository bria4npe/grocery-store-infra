resource "aws_ecr_repository" "this" {
  for_each = toset(var.services)

  name                 = "${var.project}-${each.key}${var.suffix}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
