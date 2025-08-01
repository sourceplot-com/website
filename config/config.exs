import Config

config :sourceplot,
  ecto_repos: [Sourceplot.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

config :sourceplot, SourceplotWeb.Core.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SourceplotWeb.ErrorHTML, json: SourceplotWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Sourceplot.PubSub,
  live_view: [signing_salt: "2QfH/StM"]

config :sourceplot, Sourceplot.Mailer, adapter: Swoosh.Adapters.Local

config :tailwind,
  version: "3.4.3",
  sourceplot: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :sourceplot, :aws,
  region: System.get_env("AWS_REGION"),

  daily_stats_table_name: System.get_env("DAILY_STATS_TABLE_NAME"),
  daily_stats_table_date_index: System.get_env("DAILY_STATS_TABLE_DATE_INDEX"),
  daily_stats_user_access_key_id: System.get_env("DAILY_STATS_USER_ACCESS_KEY_ID"),
  daily_stats_user_secret_access_key: System.get_env("DAILY_STATS_USER_SECRET_ACCESS_KEY")

import_config "#{config_env()}.exs"
