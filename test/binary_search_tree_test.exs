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
    assert BinarySearchTree.insert(nil, 10) == %BinarySearchTree.Node{data: 10, parent: nil, left: nil, right: nil}
  end

  test "insert second node" do
    node = BinarySearchTree.insert(nil, 10)
    assert BinarySearchTree.insert(node, 19) == %BinarySearchTree.Node{data: 10, left: nil, parent: nil, right: %BinarySearchTree.Node{data: 19, left: nil, right: nil, parent: %BinarySearchTree.Node{data: 10, left: nil, parent: nil, right: nil}}}
  end

  test "insert sets parent" do
    node = BinarySearchTree.insert(nil, 10)
           |> BinarySearchTree.insert(19)

    assert node.data == 10
    assert node.right.data == 19
    assert node.right.parent.data == 10
  end

  test "insert lesser value" do
    node = BinarySearchTree.insert(nil, 10)
    assert BinarySearchTree.insert(node, 9) == %BinarySearchTree.Node{data: 10, parent: nil, right: nil, left: %BinarySearchTree.Node{data: 9, left: nil, right: nil, parent: %BinarySearchTree.Node{data: 10, left: nil, parent: nil, right: nil}}}
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

  test "next smallest from 0 is -6", state do
    assert BinarySearchTree.next_smallest(state.node_0).data == -6
  end

  test "next smallest from 21 is 19", state do
    node_21 = state.tree.right.right
    assert state.tree.data == 10
    assert state.tree.right.data == 19
    assert state.tree.right.parent.data == 10
    assert state.tree.right.parent.right.data == 19
    assert state.tree.right.right == state.node_21
    assert node_21.parent.data == 19
    IO.inspect(node_21)
    # assert BinarySearchTree.next_smallest(state.node_21).data == 19
  end

  test "next smallest from 4 is 0", state do
    tree = BinarySearchTree.insert(state.tree, 4)
    node_4 = BinarySearchTree.find(tree, 4)
    # assert BinarySearchTree.next_smallest(node_4).data = 0
  end
end
