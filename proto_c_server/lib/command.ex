defmodule ProtoCServer.Command do
  import Socket

  def parse(line, socket) do
    case String.split(line) do
      ["GET"] -> {:ok, {:get, socket}}
      ["PUT", value] -> {:ok, {:put, value}}
      _ -> {:error, :unknown_command}
    end
  end

  def run({:get, socket}) do
    [value | _] = ProtoCServer.Message.get(fn list -> list end)
    Socket.Stream.send(socket, value)
    {:ok, value}
  end

  def run({:put, value}) do
    ProtoCServer.Message.put(value)
    GenServer.cast({:via, :gproc, {:p, :l, :channel}}, {:msg, "aa"})
    {:ok, value}
  end

  def parse_message(msg) do
    data = String.split(msg)
  end

  def broadcast_each do
  end
end
