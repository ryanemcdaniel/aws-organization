# ==
# Organizational AI Opt-Out Policy
# ==
resource "aws_organizations_policy" "ai_opt_out" {
  name        = "OptOutFromAllAIServices"
  description = "Opt outs from all AI services."
  type        = "AISERVICES_OPT_OUT_POLICY"
  content = jsonencode({
    "services" = {
      "@@operators_allowed_for_child_policies" = [
        "@@none"
      ],
      "default" = {
        "@@operators_allowed_for_child_policies" = [
          "@@none"
        ],
        "opt_out_policy" = {
          "@@operators_allowed_for_child_policies" = [
            "@@none"
          ],
          "@@assign" = "optOut"
        }
      }
    }
  })
}

resource "aws_organizations_policy_attachment" "ai_opt_out" {
  for_each  = var.accounts
  policy_id = aws_organizations_policy.ai_opt_out.id
  target_id = each.value.id
}