resource "aws_iam_role" "this" {
  for_each = var.roles

  name = "${var.project}-${var.environment}-${each.key}"

  assume_role_policy = each.value.assume_role_policy

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    for item in flatten([
      for role_name, role in var.roles : [
        for policy_arn in role.policy_arns : {
          key        = "${role_name}-${policy_arn}"
          role       = role_name
          policy_arn = policy_arn
        }
      ]
    ]) : item.key => item
  }

  role       = aws_iam_role.this[each.value.role].name
  policy_arn = each.value.policy_arn
}
