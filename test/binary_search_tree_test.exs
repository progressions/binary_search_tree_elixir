defmodule BinarySearchTreeTest do
  use ExUnit.Case
  doctest BinarySearchTree

  setup do
    tree = BinarySearchTree.insert(nil, 10)
    |> BinarySearchTree.insert(19)
    |> BinarySearchTree.insert(-6)
    |> BinarySearchTree.insert(21)
    |> BinarySearchTree.insert(15)
    |> BinarySearchTree.insert(0)

    node_21 = BinarySearchTree.find(tree, 21)
    node_19 = BinarySearchTree.find(tree, 19)
    node_15 = BinarySearchTree.find(tree, 15)
    node_0 = BinarySearchTree.find(tree, 0)

    {:ok, tree: tree, node_21: node_21, node_19: node_19, node_15: node_15, node_0: node_0}
  end

  test "insert first node" do
    assert BinarySearchTree.insert(nil, 10).data == 10
    assert BinarySearchTree.insert(nil, 10).left == nil
    assert BinarySearchTree.insert(nil, 10).right == nil
  end

  test "insert second node" do
    node = BinarySearchTree.insert(nil, 10)
    assert BinarySearchTree.insert(node, 19).right.data == 19
  end

  test "insert lesser value" do
    node = BinarySearchTree.insert(nil, 10)
    assert BinarySearchTree.insert(node, 9).left.data == 9
  end

  test "in_order traversal", state do
    assert BinarySearchTree.in_order(state.tree) == [-6, 0, 10, 15, 19, 21]
  end

  test "pre_order traversal", state do
    assert BinarySearchTree.pre_order(state.tree) == [10, -6, 0, 19, 15, 21]
  end

  test "post_order traversal", state do
    assert BinarySearchTree.post_order(state.tree) == [0, -6, 15, 21, 19, 10]
  end

  test "level_order traversal", state do
    assert BinarySearchTree.level_order(state.tree) == [10, -6, 19, 0, 15, 21]
  end

  test "find data in self" do
    assert BinarySearchTree.find(%BinarySearchTree.Node{data: 10, left: nil, right: nil}, 10).data == 10
  end

  test "find data in tree", state do
    assert BinarySearchTree.find(state.tree, 19) == state.node_19
  end

  test "next smallest from 19 is 15", state do
    assert BinarySearchTree.next_smallest(state.node_19).data == 15
  end

  test "next smallest from 10 is 0", state do
    assert BinarySearchTree.next_smallest(state.tree).data == 0
  end
end
