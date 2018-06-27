defmodule ProtoC.MessageBucketTest do
  use ExUnit.Case, async: true

  test "stores values by key" do
    {:ok, state} = ProtoC.MessageBucket.start_link([])
    assert ProtoC.MessageBucket.get(state, "main") == nil

    ProtoC.MessageBucket.put(state, "main", ["Hello"])
    assert ProtoC.MessageBucket.get(state, "main") == ["Hello"]
  end
end