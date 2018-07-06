defmodule ProtoCServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = 8000

    children = [
      worker(ProtoCServer, [port]),
      ProtoCServer.Message
    ]

    IO.puts("\n------> Starting on port #{port}!")

    opts = [strategy: :one_for_one, name: ProtoCServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
