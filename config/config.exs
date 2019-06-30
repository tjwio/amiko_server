# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :amiko_server,
  ecto_repos: [AmikoServer.Repo]

# Configures the endpoint
config :amiko_server, AmikoServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "I7pICqS9hOrV42qwKYnaSNploPL+BM5fqLMxi1GbvI2cI6vKD+Rjr9SYxJm644+s",
  render_errors: [view: AmikoServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AmikoServer.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Guardian
config :friction_server, FrictionServer.Authentication.Guardian,
       issuer: "amiko_server",
       ttl: { 30, :days },
       allowed_drift: 2000,
       secret_key: "OTb8bHSfHVhnMEw/kajXPFMnXRlU2/QZX0q8KEs5Onuye+xn7wBjZNjuR4B7H6d1"

# Configure AWS S3
config :ex_aws,
       access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
       secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
       s3: [
         scheme: "https://",
         host: "s3-elixir.s3.amazonaws.com",
         region: System.get_env("AWS_REGION")
       ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
