output "AppTierTargetGroup" {
    value = aws_lb_target_group.AppTierTargetGroup.id
}

output "app_tier_tg_arn" {
  value = aws_lb_target_group.AppTierTargetGroup.arn
}