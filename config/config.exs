# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :store,
  ecto_repos: [Store.Repo]

# Configures the endpoint
config :store, StoreWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: StoreWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Store.PubSub,
  live_view: [signing_salt: "5kFWBsBn"]

config :icons,
  collection: [Heroicons, Ionicons]

config :waffle,
  storage: Waffle.Storage.Local,
  storage_dir_prefix: "priv",
  asset_host: {:system, "ASSET_HOST"}

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :store, Store.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tailwind,
  version: "3.0.12",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

  config :boruta, Boruta.Oauth,
  repo: Store.Repo,
  cache_backend: Boruta.Cache,
  contexts: [
    access_tokens: Boruta.Ecto.AccessTokens,
    clients: Boruta.Ecto.Clients,
    codes: Boruta.Ecto.Codes,
    # mandatory for user flows
    resource_owners: Store.Oauth.ResourceOwners,
    scopes: Boruta.Ecto.Scopes
  ],
  max_ttl: [
    authorization_code: 60,
    access_token: 60 * 60 * 24,
    refresh_token: 60 * 60 * 24 * 30
  ],
  token_generator: Boruta.TokenGenerator

config :boruta, Boruta.Cache,
  primary: [
    # => 1 day
    gc_interval: :timer.hours(6),
    backend: :shards,
    partitions: 2
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
