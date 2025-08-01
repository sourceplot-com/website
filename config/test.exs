import Config

config :bcrypt_elixir, :log_rounds, 1

config :sourceplot, Sourceplot.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "sourceplot_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :sourceplot, SourceplotWeb.Core.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Uh7zUYiUDa7A21zu01bVotmYdDeLSWI9JvW5pabT9+GDZUXwX3d4tBZBUvhV5WMo",
  server: false

config :sourceplot, Sourceplot.Mailer, adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  enable_expensive_runtime_checks: true
