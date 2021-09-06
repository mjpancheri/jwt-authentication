# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :authentication, ecto_repos: [Authentication.Repo], generators: [binary_id: true]

config :authentication, Authentication.Guardian,
    issuer: "authentication",
    secret_key: "BY8grm00++tVtByLhHG15he/3GlUG0rOSLmP2/2cbIRwdR4xJk1RHvqGHPFuNcF8",
    ttl: {3, :days}

 config :authentication, AuthenticationWeb.AuthAccessPipeline,
    module: Authentication.Guardian,
    error_handler: AuthenticationWeb.AuthErrorHandler

# Configures the endpoint
config :authentication, AuthenticationWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gezCztOVJKD3K7/pRxOCsVz2/26KpvIXP6iwcLAtR6kikK55jKMTPDbjxLrheGDc",
  render_errors: [view: AuthenticationWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Authentication.PubSub,
  live_view: [signing_salt: "ywIHqVZp"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
