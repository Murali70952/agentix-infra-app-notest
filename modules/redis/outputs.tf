output "host" {
  value = google_redis_instance.redis.host
}

output "port" {
  value = google_redis_instance.redis.port
}

output "name" {
  value = google_redis_instance.redis.name
}

output "redis_auth_secret" {
  description = "Secret containing Redis AUTH string"
  value = var.auth_enabled ? google_secret_manager_secret.redis_auth[0].secret_id : null
}

output "redis_auth_string" {
  value     = var.auth_enabled ? google_redis_instance.redis.auth_string : null
  sensitive = true
}