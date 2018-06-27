defmodule ProtoC.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(ProtoC.Registry)
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert ProtoC.Registry.lookup(registry, "shopping") == :error

    ProtoC.Registry.create(registry, "shopping")
    assert {:ok, bucket} = ProtoC.Registry.lookup(registry, "shopping")

    ProtoC.MessageBucket.put(bucket, "milk", 1)
    assert ProtoC.MessageBucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    ProtoC.Registry.create(registry, "shopping")
    {:ok, bucket} = ProtoC.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert ProtoC.Registry.lookup(registry, "shopping") == :error
  end
end