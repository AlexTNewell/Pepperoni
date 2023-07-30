##################### SNS topic #####################

resource "aws_sns_topic" "dev_server_updates" {
  name = "dev_server_updates"
}
