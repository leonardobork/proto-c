defmodule ProtoCServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    port = String.to_integer(System.get_env("PORT") || "4040")

    children = [
      {Task.Supervisor, name: ProtoCServer.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> ProtoCServer.accept(4040) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: ProtoCServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
