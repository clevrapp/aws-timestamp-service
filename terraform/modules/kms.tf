resource "aws_kms_key" "my_key" {
  description             = "KMS key for S3 object encryption"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "my_key_alias" {
  name          = "alias/myKeyAlias"
  target_key_id = aws_kms_key.my_key.id
}
