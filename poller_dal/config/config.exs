import Config

config :poller_dal, PollerDal.Repo,
  database: "poller_#{Mix.env()}",
  username: "maxbigbudget",
  password: "",
  hostname: "localhost"

config :poller_dal,
  ecto_repos: [PollerDal.Repo]
