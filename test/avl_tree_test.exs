defmodule AvlTreeTest do
  use ExUnit.Case
  doctest AvlTree

  test "insert first node" do
    assert AvlTree.insert(nil, 10).data == 10
    assert AvlTree.insert(nil, 10).left == nil
    assert AvlTree.insert(nil, 10).right == nil
  end

  test "insert_with_height needs balancing on left" do
    {_, height} = AvlTree.insert(nil, 1)
    |> AvlTree.insert(2)
    |> AvlTree.insert_with_height(3)

    assert height == 3
  end

  test "insert_with_height needs balancing on right" do
    {_, height} = AvlTree.insert(nil, 3)
    |> AvlTree.insert(2)
    |> AvlTree.insert_with_height(1)

    assert height == 3
  end

end
