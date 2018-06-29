defmodule ProtoCServerTest do
  use ExUnit.Case
  doctest ProtoCServer

  test "greets the world" do
    assert ProtoCServer.hello() == :world
  end
end
