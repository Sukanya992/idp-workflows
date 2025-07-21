# main.tf

# Configure the Google Cloud provider
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Create a VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "${var.environment_name}-vpc"
  auto_create_subnetworks = false # Prefer custom subnets for better control
  project                 = var.gcp_project_id
}

# Create a Subnet
resource "google_compute_subnetwork" "app_subnet" {
  name          = "${var.environment_name}-app-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
  project       = var.gcp_project_id
}

# Create a Compute Engine instance (example for a web server)
resource "google_compute_instance" "web_server" {
  name         = "${var.environment_name}-web-server"
  machine_type = var.instance_machine_type
  zone         = "${var.gcp_region}-a" # Or parameterize zone
  project      = var.gcp_project_id

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Or a custom image
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.app_subnet.id
    access_config {} # Assign ephemeral public IP for simplicity; for production, use external IP or NAT Gateway
  }

  metadata_startup_script = "#! /bin/bash\nsudo apt-get update\nsudo apt-get install -y apache2\nsudo systemctl start apache2"

  tags = ["http-server", "${var.environment_name}"]
}

# Output the instance IP
output "web_server_ip" {
  value       = google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip
  description = "The external IP address of the web server."
}

output "vpc_network_name" {
  value = google_compute_network.vpc_network.name
}
