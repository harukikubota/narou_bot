# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :narou_bot,
  ecto_repos: [NarouBot.Repo]

config :narou_bot,
  inquery_form_url: System.get_env("NAROU_BOT_INQUERY_FORM_URL")

# Configures the endpoint
config :narou_bot, NarouBotWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ap/D+olCMM/dss94BzwZpDRQAk0h8NF6kMNMNRPag1e+d21tbIb0WhoYqtTE4s22",
  render_errors: [view: NarouBotWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NarouBot.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :line_bot,
  client_id:     System.get_env("LINE_CHANNEL_ID"),
  client_secret: System.get_env("LINE_CHANNEL_SECRET"),
  skip_validation: false
