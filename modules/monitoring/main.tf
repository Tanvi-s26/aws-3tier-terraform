resource "aws_sns_topic" "alerts" {
  name = "${var.name}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = "${var.name}-unhealthy-hosts"
  alarm_description   = "At least one server behind the load balancer is unhealthy"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 2
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    TargetGroup  = var.target_group_arn_suffix
    LoadBalancer = var.alb_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_high" {
  alarm_name          = "${var.name}-app-cpu-high"
  alarm_description   = "Average CPU across app servers is above 80 percent"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "db_cpu_high" {
  alarm_name          = "${var.name}-db-cpu-high"
  alarm_description   = "Database CPU is above 80 percent"
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }
}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.name}-overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "Load balancer requests"
          region  = var.region
          stat    = "Sum"
          period  = 60
          metrics = [["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix]]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "Healthy servers"
          region  = var.region
          stat    = "Average"
          period  = 60
          metrics = [["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix]]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title   = "App server CPU"
          region  = var.region
          stat    = "Average"
          period  = 300
          metrics = [["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.asg_name]]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          title   = "Database CPU"
          region  = var.region
          stat    = "Average"
          period  = 300
          metrics = [["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_identifier]]
        }
      }
    ]
  })
}