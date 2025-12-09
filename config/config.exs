# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :oauth2_proxies_admin,
  generators: [timestamp_type: :utc_datetime],
  # Docker socket path - override in local.exs or runtime.exs as needed
  # For Podman, use "/run/podman/podman.sock"
  docker_socket: "/var/run/docker.sock",
  # Proxies path - override in local.exs or runtime.exs as needed
  # Defaults to priv/proxies directory
  proxies_path: Path.join(__DIR__, "../dev/proxies") |> Path.expand()

# Configure the endpoint
config :oauth2_proxies_admin, Oauth2ProxiesAdminWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: Oauth2ProxiesAdminWeb.ErrorHTML, json: Oauth2ProxiesAdminWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Oauth2ProxiesAdmin.PubSub,
  live_view: [signing_salt: "RIkOTJYu"]

# Configure the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :oauth2_proxies_admin, Oauth2ProxiesAdmin.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  oauth2_proxies_admin: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.12",
  oauth2_proxies_admin: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Import local configuration for development (optional, gitignored)
# Copy config/local.example.exs to config/local.exs to customize
if File.exists?("#{__DIR__}/local.exs") do
  import_config "local.exs"
end
