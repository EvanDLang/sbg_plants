# Example for dev/providers.tf
provider "postgresql" {
  host     = var.endpoint
  port     = var.port
  database = "traitsdb"
  username = var.dbuser
  password = var.password
  superuser = false
  sslmode  = "require"
}
# Create the "startup" database
#resource "postgresql_database" traitsdb"" {
#  name = "traitsdb"
#}
#data "postgresql_database" traitsdb {
#  name = "traitsdb"
#}


# Connect to the "startup" database
#resource "postgresql_role" "root" {
#  name = "dbadmin"
#}#

#resource "postgresql_grant" "connect_to_traitsdb" {
#  database    = "traitsdb"
 # object_type = "database"
#  privileges   = ["CONNECT"]
#  role        = postgresql_role.root.name
#}

# Create the "api" schema
resource "postgresql_schema" "api" {
  name = "api"
  #database = data.postgresql_database.traitsdb.name
}

# Create the "web_anon" role
resource "postgresql_role" "web_anon" {
  name = "web_anon"
  login = false
}

# Grant usage on the "api" schema to the "web_anon" role
resource "postgresql_grant" "grant_usage_to_web_anon" {
  database    = "traitsdb"
  object_type = "schema"
  #object_name = postgresql_schema.api.name
  schema     = "api"
  privileges = ["USAGE"]
  role = postgresql_role.web_anon.name
}

# Grant select on the "trees" table to the "web_anon" role
#resource "postgresql_grant" "grant_select_on_trees_to_web_anon" {
#  database    = "traitsdb"
#  object_type = "table"
#  #object_name = postgresql_table.trees.name
#  privileges = ["SELECT"]
#  role = postgresql_role.web_anon.name
#}

# Create the "authenticator" role
resource "postgresql_role" "authenticator" {
  name = "authenticator"
  login = true
  password = "secret1"  # Should be handled securely in production
}

resource "postgresql_grant_role" "grant_web_anon_to_authenticator" {
  role       = "web_anon"
  grant_role = "authenticator"

  depends_on = [
    postgresql_role.authenticator
  ]
}