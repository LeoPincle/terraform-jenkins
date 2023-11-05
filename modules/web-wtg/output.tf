output "WebTierTargetGroup" {
    value = aws_lb_target_group.WebTierTargetGroup.id
}

output "web_tier_tg_arn" {
  value = aws_lb_target_group.WebTierTargetGroup.arn
}