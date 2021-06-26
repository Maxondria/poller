defmodule PollerDal do
  use Application

  def start(_type, _args) do
    children = [
      {PollerDal.Repo, []}
    ]

    options = [strategy: :one_for_one, name: PollerDal.Supervisor]

    Supervisor.start_link(children, options)
  end
end
