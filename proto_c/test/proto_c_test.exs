defmodule ProtoCTest do
  use ExUnit.Case
  doctest ProtoC

  test "greets the world" do
    assert ProtoC.hello() == :world
  end
end
