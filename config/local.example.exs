import Config

# Local development configuration
# Copy this file to config/local.exs and customize for your environment
# config/local.exs is gitignored and will not be committed

# Configure Docker socket path for your local development environment
config :oauth2_proxies_admin, docker_socket: "/var/run/docker.sock"

# For Podman instead of Docker:
# config :oauth2_proxies_admin, docker_socket: "/run/podman/podman.sock"

# For custom socket path:
# config :oauth2_proxies_admin, docker_socket: "/your/custom/path/docker.sock"
