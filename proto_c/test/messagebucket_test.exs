defmodule ProtoC.MessageBucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = ProtoC.MessageBucket.start_link([])
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert ProtoC.MessageBucket.get(bucket, "bucket1") == nil

    ProtoC.MessageBucket.put(bucket, "bucket1", ["Hello"])
    assert ProtoC.MessageBucket.get(bucket, "bucket1") == ["Hello"]
  end
end
