use Mix.Config

config :yak, Yak.Web.Endpoint,
  on_init: {Yak.Web.Endpoint, :load_from_system_env, []},
  http: [port: {:system, "PORT"}],
  url: [host: "stage.yak.sk", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :yak, Yak.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
