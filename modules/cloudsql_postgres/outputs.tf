output "instance_name" {
  value = google_sql_database_instance.agentix_postgres.name
}

output "connection_name" {
  value = google_sql_database_instance.agentix_postgres.connection_name
}

output "first_ip" {
  value = google_sql_database_instance.agentix_postgres.first_ip_address
}


# Usernames

output "db_users" {
  description = "Created database users"

  value = [
    for user in google_sql_user.users : user.name
  ]
}

# Secret Manager Secret Names

output "db_password_secrets" {
  description = "Secret names containing passwords"

  value = {
    for user in var.db_users :
    user => google_secret_manager_secret.db_passwords[user].secret_id
  }
}

output "db_passwords" {
  description = "Generated passwords per user"

  value = {
    for user in var.db_users :
    user => random_password.db_passwords[user].result
  }

  sensitive = true
}
