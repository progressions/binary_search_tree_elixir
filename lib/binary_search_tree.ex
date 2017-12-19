defmodule BinarySearchTree do
  defmodule Node do
    defstruct data: nil, left: nil, right: nil
  end
  @type tree :: %BinarySearchTree.Node{}

  @moduledoc """
  Documentation for BinarySearchTree.
  """

  @doc """
  Insert data into a tree.

  ## Examples

      iex> BinarySearchTree.insert(nil, 10)
      %BinarySearchTree.Node{data: 10, left: nil, right: nil}

      iex> BinarySearchTree.insert(nil, 10)
      ...> |> BinarySearchTree.insert(15)
      %BinarySearchTree.Node{data: 10, left: nil,
                right: %BinarySearchTree.Node{data: 15, left: nil, right: nil}}

      iex> BinarySearchTree.insert(nil, 10)
      ...> |> BinarySearchTree.insert(10)
      %BinarySearchTree.Node{data: 10, left: nil, right: nil}

  """
  @spec insert(tree :: tree, data :: integer) :: tree
  def insert(nil, data), do: %Node{data: data}
  def insert(%Node{data: node_data}=tree, data)
    when data < node_data, do: %Node{data: node_data, left: insert(tree.left, data), right: tree.right}
  def insert(%Node{data: node_data}=tree, data)
    when data > node_data, do: %Node{data: node_data, left: tree.left, right: insert(tree.right, data)}
  def insert(tree, _data), do: tree

  @doc """
  Create a tree from a list.

  ## Examples

      iex> [3, 4, 2]
      ...> |> BinarySearchTree.create
      %BinarySearchTree.Node{data: 3,
                    left: %BinarySearchTree.Node{data: 2, left: nil, right: nil},
                    right: %BinarySearchTree.Node{data: 4, left: nil, right: nil}}
  """
  @spec create(list) :: tree
  def create(list) when is_list(list), do: Enum.reduce(list, nil, &(insert(&2, &1)))

  @doc """
  Balance a tree into an even distribution of left and right branches.

  ## Examples

      iex> [1, 2, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.balance
      ...> |> BinarySearchTree.level_order
      ...> |> Enum.map(&(&1.data))
      [2, 1, 3]

  """
  @spec balance(tree) :: tree
  def balance(tree), do: nil

  @doc """
  Compile an in-order collection of the tree's data.

  An in-order collection is made by recursively collecting:

    - the current node's left tree
    - the current node
    - the current node's right tree

  An inefficient version looks like this:

  `in_order(node.left) ++ [node] ++ in_order(node.right)`

  ## Examples

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.in_order
      ...> |> Enum.map(&(&1.data))
      [1, 2, 3]

  """
  @spec in_order(tree) :: tree
  def in_order(tree), do: in_order([], tree) |> Enum.reverse

  #
  # [tree + LEFT] goes into +in_order(tree.right)+
  # which adds itself to the head:
  # [RIGHT + tree + LEFT]
  # then we reverse it.
  #
  defp in_order(acc, nil), do: acc
  defp in_order(acc, tree) do
    [tree | in_order(acc, tree.left)]
    |> in_order(tree.right)
  end

  @doc """
  Compile a pre-order collection of the tree's data.

  An pre-order collection is made by recursively collecting:

    - the current node
    - the current node's left tree
    - the current node's right tree

  ## Examples

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.pre_order
      ...> |> Enum.map(&(&1.data))
      [2, 1, 3]

  """
  @spec pre_order(tree) :: tree
  def pre_order(tree), do: pre_order([], tree) |> Enum.reverse

  defp pre_order(acc, nil), do: acc
  defp pre_order(acc, tree) do
    # we're collecting the nodes in reverse:
    # RIGHT + LEFT + node
    #
    [tree | acc]
    |> pre_order(tree.left)
    |> pre_order(tree.right)
  end

  @doc """
  Compile a post-order collection of the tree's data.

  An post-order collection is made by recursively collecting:

    - the current node's left tree
    - the current node's right tree
    - the current node

  ## Examples

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.post_order
      ...> |> Enum.map(&(&1.data))
      [1, 3, 2]

  """
  @spec post_order(tree) :: tree
  def post_order(tree), do: post_order([], tree) |> Enum.reverse

  defp post_order(acc, nil), do: acc
  defp post_order(acc, tree) do
    [ tree |
      post_order(acc, tree.left)
      |> post_order(tree.right)
    ]
  end

  @doc """
  Compile a level-order collection of the tree's data.

  An level-order collection is made by recursively collecting each
  level of the tree.

  If the current tree is not null, then add tree.left and tree.right
  to the queue. Then pass that queue to +level_order+ with tree itself
  added to the head of the accumulator.

  ## Examples

      iex> [2, 1, 3, 4, -5]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.level_order
      ...> |> Enum.map(&(&1.data))
      [2, 1, 3, -5, 4]

  """
  @spec level_order(tree) :: tree
  def level_order(tree), do: level_order([tree], []) |> Enum.reverse

  defp level_order([], acc), do: acc
  defp level_order([nil|queue], acc), do: level_order(queue, acc)
  defp level_order([tree|queue], acc) do
    queue ++ [tree.left, tree.right]
    |> level_order([tree|acc])
  end

  @doc """
  Find an element in the tree with the given data.

  ## Examples

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.find(3)
      %BinarySearchTree.Node{data: 3, left: nil, right: nil}

  """
  @spec find(node :: tree, data :: integer) :: tree
  def find(nil, data), do: nil
  def find(%Node{data: data}=tree, data), do: tree
  def find(%Node{left: left, right: right}, data) do
    find(left, data) || find(right, data)
  end

  @doc """
  Find the element with the next smallest data given a node and the root node.

  ## Examples

      iex> tree = [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> node = BinarySearchTree.find(tree, 2)
      ...> |> BinarySearchTree.next_smallest(tree)
      ...> node.data
      1

      iex> tree = [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> node = BinarySearchTree.next_smallest(2, tree)
      ...> node.data
      1

  """
  @spec next_smallest(node :: tree, root :: tree) :: tree
  @spec next_smallest(data :: integer, root :: tree) :: tree
  def next_smallest(%Node{left: node}, _) when is_map(node), do: largest(node)
  def next_smallest(%Node{}=node, root), do: next_smallest(node, root, nil)
  def next_smallest(data, root), do: find(root, data) |> next_smallest(root)

  defp next_smallest(%Node{data: node_data}=tree, %Node{data: root_data, left: left}, successor)
    when node_data > root_data, do: next_smallest(tree, left, successor)
  defp next_smallest(%Node{data: node_data}=tree, %Node{data: root_data, right: right}=root, _)
    when node_data < root_data, do: next_smallest(tree, right, root)
  defp next_smallest(_, _, successor), do: successor

  @doc """
  Find the element with the next largest data given a node and the root node.

  ## Examples

      iex> tree = [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> node = BinarySearchTree.find(tree, 1)
      ...> |> BinarySearchTree.next_largest(tree)
      ...> node.data
      2

      iex> tree = [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> node = BinarySearchTree.next_largest(1, tree)
      ...> node.data
      2
  """
  @spec next_largest(node :: tree, root :: tree) :: tree
  @spec next_largest(data :: integer, root :: tree) :: tree
  def next_largest(%Node{right: node}, _) when is_map(node), do: smallest(node)
  def next_largest(%Node{}=node, root), do: next_largest(node, root, nil)
  def next_largest(data, root), do: find(root, data) |> next_largest(root)

  defp next_largest(%Node{data: node_data, right: nil}=tree, %Node{data: root_data, right: right}=root, _)
    when node_data > root_data, do: next_largest(tree, right, root)
  defp next_largest(%Node{data: node_data, right: nil}=tree, %Node{data: root_data, left: left}, successor)
    when node_data < root_data, do: next_largest(tree, left, successor)
  defp next_largest(_, _, successor), do: successor

  @doc """
  Find the element with the largest data in the entire tree.

  ## Examples

      iex> node = [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.largest
      ...> node.data
      3

  """
  @spec largest(tree) :: tree
  def largest(nil), do: nil
  def largest(%Node{right: nil}=tree), do: tree
  def largest(%Node{right: right}), do: largest(right)

  @doc """
  Find the element with the smallest data in the entire tree.

  ## Examples

      iex> node = [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.smallest
      ...> node.data
      1

  """
  @spec smallest(tree) :: tree
  def smallest(nil), do: nil
  def smallest(%Node{left: nil}=tree), do: tree
  def smallest(%Node{left: left}), do: smallest(left)

  @doc """
  Delete a given element from the tree and move its children into place.

  Return a new version of the tree without the element in place.

  ## Examples

      iex> [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.delete(2)
      ...> |> BinarySearchTree.in_order
      ...> |> Enum.map(&(&1.data))
      [1, 3]

      iex> [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.delete(2)
      ...> |> BinarySearchTree.find(2)
      nil

  """
  @spec delete(root :: tree, data :: integer) :: tree
  def delete(root, data), do: nil

  @doc """
  Compare two trees and return true if they are identical in values and structure.

  ## Examples

      iex> tree_a = [2, 3, 1]
      ...> |> BinarySearchTree.create
      iex> tree_b = [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> BinarySearchTree.compare(tree_a, tree_b)
      true

      iex> tree_a = [2, 3, 1]
      ...> |> BinarySearchTree.create
      iex> tree_b = [3, 2, 1]
      ...> |> BinarySearchTree.create
      ...> BinarySearchTree.compare(tree_a, tree_b)
      false

      # Trees with the same structure but different values
      # are not the same.

      iex> tree_a = [3, 4, 2]
      ...> |> BinarySearchTree.create
      iex> tree_b = [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> BinarySearchTree.compare(tree_a, tree_b)
      false


  """
  @spec compare(tree, tree) :: tree

  def compare(nil, nil), do: true
  def compare(nil, _), do: false
  def compare(_, nil), do: false
  def compare(%Node{data: data_a}, %Node{data: data_b}) when data_a != data_b, do: false
  def compare(tree_a, tree_b) do
    compare(tree_a.left, tree_b.left) && compare(tree_a.right, tree_b.right)
  end

  @doc """
  Sum the values of all the nodes in the tree.

  ## Examples

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.sum
      6

  """
  @spec sum(tree) :: integer
  def sum(nil), do: 0
  def sum(%Node{data: data, left: left, right: right}) do
    data + sum(left) + sum(right)
  end
end
