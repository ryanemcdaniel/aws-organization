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

resource "aws_organizations_policy_attachment" "ai_opt_out_roots" {
    count = length(local.org_root_ids)

    policy_id = aws_organizations_policy.ai_opt_out.id
    target_id = local.org_root_ids[count.index]
}

resource "aws_organizations_policy_attachment" "ai_opt_out_accounts" {
    count = length(local.all_account_ids)

    policy_id = aws_organizations_policy.ai_opt_out.id
    target_id = local.all_account_ids[count.index]
}