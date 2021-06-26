# PollerDal

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `poller_dal` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:poller_dal, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/poller_dal](https://hexdocs.pm/poller_dal).

# Steps

- Create a new mix project
- Install deps (Ecto, Postgrex)
- Create a repo by keying:

```bash
    mix ecto.gen.repo -r PollerDal.Repo
```

- A bunch of files been created
- Add the PollerDal to the supervisor in the main file
- Configure the `config/config.ex` file
- Add this:

  ```elixir
      config :poller_dal, ecto_repos: [PollerDal.Repo]
  ```

  to `config/config.ex`

- Run

```bash
mix ecto.create
```

to create the database.

- Create a migration now, eg:

```bash
  mix ecto.gen.migration create_districts
```

- Modify the migration files (add columns and stuff)
- Run migrations now

```bash
mix ecto.migrate
```

- Create a `districts` directory
- Create a file under `lib/districts`, named `districts.ex`
- Create a schema in this file (see file)
- Now we can use this module in `lib/districts/districts.ex` to interact with the Database
