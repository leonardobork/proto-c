defmodule ProtoC  do
  use Application

  def start(_type, _args) do
    ProtoC.Supervisor.start_link(name: ProtoC.Supervisor)
  end
end