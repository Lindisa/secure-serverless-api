resource "aws_cloudfront_distribution" "cdn" {
  enabled = true

  origin {
    domain_name = replace(var.api_gateway_url, "https://", "")
    origin_id   = "api-origin"
  }

  default_cache_behavior {
    target_origin_id       = "api-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}