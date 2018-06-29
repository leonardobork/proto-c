defmodule ProtoC.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    registry = start_supervised!({ProtoC.Registry, name: context.test})
    %{registry: context.test}
  end

  test "spawns buckets", %{registry: registry} do
    assert ProtoC.Registry.lookup(registry, "shopping") == :error

    _ = ProtoC.Registry.create(registry, "shopping")
    assert {:ok, bucket} = ProtoC.Registry.lookup(registry, "shopping")

    ProtoC.MessageBucket.put(bucket, "milk", 1)
    assert ProtoC.MessageBucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    ProtoC.Registry.create(registry, "shopping")
    {:ok, bucket} = ProtoC.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)

    # Do a call to ensure the registry processed the DOWN message
    _ = ProtoC.Registry.create(registry, "bogus")
    assert ProtoC.Registry.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    ProtoC.Registry.create(registry, "shopping")
    {:ok, bucket} = ProtoC.Registry.lookup(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)

    # Do a call to ensure the registry processed the DOWN message
    _ = ProtoC.Registry.create(registry, "bogus")
    assert ProtoC.Registry.lookup(registry, "shopping") == :error
  end
end
