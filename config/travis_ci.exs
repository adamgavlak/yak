use Mix.Config

config :yak, Yak.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  username: "postgres",
  password: "",
  database: "travis_ci_test",
  hostname: "localhost"