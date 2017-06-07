# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :yak,
  ecto_repos: [Yak.Repo]

# Configures the endpoint
config :yak, Yak.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OVP7YvrOfkXLtCUgHhppfo/3SehsBy35QkDfBjDlmonAASfS3DEtEn8FMM5Y/PKM",
  render_errors: [view: Yak.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Yak.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "eu-central-1"

config :ex_aws, :s3,
  scheme: "https://",
  host: "s3-eu-central-1.amazonaws.com"

config :rollbax,
  access_token: System.get_env("ROLLBAR_KEY"),
  environment: Mix.env

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
