defmodule ProtoCServer.Command do
  def parse(line, socket) do
    case String.split(line, ";") do
      ["GET", _] -> {:ok, {:get, socket}}
      ["PUT", value] -> {:ok, {:put, value}}
      _ -> {:error, :unknown_command}
    end
  end

  def run({:get, socket}) do
    value = ProtoCServer.Message.get(fn list -> Enum.reverse(list) end)
    send_each_message(value, socket)
    {:ok, value}
  end

  def run({:put, value}) do
    {:ok, message} = ProtoCServer.Message.put(value)

    IO.puts("New message: #{inspect(message)}")

    GenServer.cast(
      {:via, :gproc, {:p, :l, :channel}},
      {:msg, "STATUS: 200; MESSAGE: '#{inspect(message)}'"}
    )

    {:ok, value}
  end

  def parse_message(msg) do
    [user, sent_msg] = String.split(msg, "|")

    %{
      Date: DateTime.to_string(DateTime.utc_now()),
      User: user,
      Message: sanitaze_message(sent_msg)
    }
  end

  def sanitaze_message(msg) do
    String.slice(msg, 0..(String.length(msg) - 2))
  end

  def send_each_message(msgs, socket) do
    for msg <- msgs do
      Socket.Stream.send(socket, "\nSTATUS: 200; MESSAGE: '#{inspect(msg)}'")
    end
  end
end
