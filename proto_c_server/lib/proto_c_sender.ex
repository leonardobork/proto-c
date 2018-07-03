defmodule ProtoCServer.Sender do
  use GenServer
  import Socket

  def start_link(socket, opts \\ []) do
    GenServer.start_link(__MODULE__, [socket: socket], opts)
  end

  def init(socket) do
    :gproc.reg({:p, :l, :channel})
    {:ok, socket}
  end

  def handle_cast({:msg, msg}, [socket: socket] = state) do
    Socket.Stream.send(socket, msg)
    {:noreply, state}
  end
end
