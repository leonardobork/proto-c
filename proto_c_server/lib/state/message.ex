defmodule ProtoCServer.Message do
  use Agent

  @doc """
  Starts a new bucket.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(callback) do
    Agent.get(__MODULE__, callback)
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  def put(value) do
    data = ProtoCServer.Command.parse_message(value)
    Agent.update(__MODULE__, fn list -> [data | list] end)
  end
end
