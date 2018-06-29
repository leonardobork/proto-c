defmodule ProtoC.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      { DynamicSupervisor, name: ProtoC.MessageBucketSupervisor, strategy: :one_for_one},
      { ProtoC.Registry, name: ProtoC.Registry }
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  
end