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

  """
  @spec insert(tree :: tree, data :: integer) :: tree
  def insert(nil, data), do: %Node{data: data}
  def insert(%Node{data: node_data}=node, data) when data > node_data, do:
    %Node{data: node.data, left: node.left, right: insert(node.right, data)}
  def insert(%Node{data: node_data}=node, data) when data < node_data, do:
    %Node{data: node.data, left: insert(node.left, data), right: node.right}
  def insert(node, _), do: node

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
  def create(list), do: list |> Enum.reduce(nil, &(insert(&2, &1)))

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
  def balance(node) when is_map(node), do: balance(in_order(node))
  def balance([]), do: nil
  def balance([node]), do: %Node{data: node.data, left: nil, right: nil}
  def balance(list) do
    mid = div(length(list), 2)
    {left, [node|right]} = Enum.split(list, mid)

    %Node{data: node.data, left: balance(left), right: balance(right)}
  end

  @doc """
  Compile an in-order collection of the tree's data.

  An in-order collection is made by recursively collecting:

    - the current node's left tree
    - the current node
    - the current node's right tree

  ## Examples

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.in_order
      ...> |> Enum.map(&(&1.data))
      [1, 2, 3]

  """
  @spec in_order(tree) :: tree
  def in_order(node) do
    in_order([], node)
    |> Enum.reverse
  end

  defp in_order(acc, nil), do: acc
  defp in_order(acc, node) do
    [node | in_order(acc, node.left)]
    |> in_order(node.right)
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
  def pre_order(node) do
    pre_order([], node)
    |> Enum.reverse
  end

  defp pre_order(acc, nil), do: acc
  defp pre_order(acc, node) do
    [node | acc]
    |> pre_order(node.left)
    |> pre_order(node.right)
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
  def post_order(node) do
    post_order([], node)
    |> Enum.reverse
  end

  defp post_order(acc, nil), do: acc
  defp post_order(acc, node) do
    [ node |
      post_order(acc, node.left)
      |> post_order(node.right) ]
  end

  @doc """
  Compile a level-order collection of the tree's data.

  An level-order collection is made by recursively collecting each
  level of the tree.

  ## Examples

      iex> [2, 1, 3, 4, -5]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.level_order
      ...> |> Enum.map(&(&1.data))
      [2, 1, 3, -5, 4]

  """
  @spec level_order(tree) :: tree
  def level_order(node), do: Enum.reverse(level_order([node], []))

  defp level_order([], acc), do: acc
  defp level_order([nil|queue], acc), do: level_order(queue, acc)
  defp level_order([node|queue], acc) do
    queue = queue ++ [node.left]
    queue = queue ++ [node.right]

    level_order(queue, [node|acc])
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
  def find(%Node{data: data}=node, data), do: node
  def find(nil, _), do: nil
  def find(%Node{left: left, right: right}, data) do
    find(left, data) || find(right, data)
  end

  @doc """
  Find the element with the next smallest data given a node and the root node.

  ## Examples

      iex> tree = [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> BinarySearchTree.find(tree, 2)
      ...> |> BinarySearchTree.next_smallest(tree)
      %BinarySearchTree.Node{data: 1, left: nil, right: nil}

      iex> tree = [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> BinarySearchTree.next_smallest(2, tree)
      %BinarySearchTree.Node{data: 1, left: nil, right: nil}

  """
  @spec next_smallest(node :: tree, root :: tree) :: tree
  @spec next_smallest(data :: integer, root :: tree) :: tree
  def next_smallest(%Node{left: node}, _) when is_map(node), do: largest(node)
  def next_smallest(%Node{}=node, root), do: next_smallest(node, root, nil)
  def next_smallest(data, root), do: find(root, data) |> next_smallest(root)

  defp next_smallest(%Node{data: node_data}=node, %Node{data: root_data, left: left}, successor)
    when node_data < root_data, do: next_smallest(node, left, successor)
  defp next_smallest(%Node{data: node_data}=node, %Node{data: root_data, right: right}=root, _)
    when node_data > root_data, do: next_smallest(node, right, root)
  defp next_smallest(_, _, successor), do: successor

  @doc """
  Find the element with the next largest data given a node and the root node.

  ## Examples

      iex> tree = [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> BinarySearchTree.find(tree, 1)
      ...> |> BinarySearchTree.next_largest(tree)
      %BinarySearchTree.Node{data: 2,
        left: %BinarySearchTree.Node{data: 1, left: nil, right: nil},
        right: %BinarySearchTree.Node{data: 3, left: nil, right: nil}}

      iex> tree = [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> BinarySearchTree.next_largest(1, tree)
      %BinarySearchTree.Node{data: 2,
        left: %BinarySearchTree.Node{data: 1, left: nil, right: nil},
        right: %BinarySearchTree.Node{data: 3, left: nil, right: nil}}
  """
  @spec next_largest(node :: tree, root :: tree) :: tree
  @spec next_largest(data :: integer, root :: tree) :: tree
  def next_largest(%Node{right: node}, _) when is_map(node), do: smallest(node)
  def next_largest(%Node{}=node, root), do: next_largest(node, root, nil)
  def next_largest(data, root), do: find(root, data) |> next_largest(root)

  defp next_largest(%Node{data: node_data}=node, %Node{data: root_data, left: left}=root, _)
    when node_data < root_data, do: next_largest(node, left, root)
  defp next_largest(%Node{data: node_data}=node, %Node{data: root_data, right: right}, successor)
    when node_data > root_data, do: next_largest(node, right, successor)
  defp next_largest(_, _, successor), do: successor

  @doc """
  Find the element with the largest data in the entire tree.

  ## Examples

      iex> [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.largest
      %BinarySearchTree.Node{data: 3, left: nil, right: nil}

  """
  @spec largest(tree) :: tree
  def largest(%Node{right: nil}=node), do: node
  def largest(%Node{right: node}), do: largest(node)

  @doc """
  Find the element with the smallest data in the entire tree.

  ## Examples

      iex> [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.smallest
      %BinarySearchTree.Node{data: 1, left: nil, right: nil}

  """
  @spec smallest(tree) :: tree
  def smallest(%Node{left: nil}=node), do: node
  def smallest(%Node{left: node}), do: smallest(node)

  @doc """
  Delete a given element from the tree and move its children into place.

  Return a new version of the tree without the element in place.

  ## Examples

      iex> [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.delete(2)
      %BinarySearchTree.Node{data: 3,
        left: %BinarySearchTree.Node{data: 1, left: nil, right: nil},
        right: nil}

      iex> [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.delete(2)
      ...> |> BinarySearchTree.find(2)
      nil

  """
  @spec delete(root :: tree, data :: integer) :: tree
  def delete(root, data), do: delete(nil, root, data)
  defp delete(acc, nil, _), do: acc
  defp delete(acc, %Node{data: data, left: nil, right: nil}, data), do: acc
  defp delete(acc, %Node{data: data, left: nil, right: right}, data), do: delete(acc, right, data)
  defp delete(acc, %Node{data: data, left: left, right: nil}, data), do: delete(acc, left, data)
  defp delete(acc, %Node{data: data, left: left, right: right}, data) do
    %{data: d} = smallest(right)

    insert(acc, d)
    |> delete(left, data)
    |> delete(right, data)
  end

  defp delete(acc, root, data) do
    insert(acc, root.data)
    |> delete(root.left, data)
    |> delete(root.right, data)
  end

  @doc """
  Compare two trees and return true if they are identical in values and structure.

  ## Examples

      iex> tree_a = [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...>
      iex> tree_b = [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> BinarySearchTree.compare(tree_a, tree_b)
      true

      iex> tree_a = [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...>
      iex> tree_b = [3, 2, 1]
      ...> |> BinarySearchTree.create
      ...> BinarySearchTree.compare(tree_a, tree_b)
      false

      # Trees with the same structure but different values
      # are not the same.

      iex> tree_a = [3, 4, 2]
      ...> |> BinarySearchTree.create
      ...>
      iex> tree_b = [2, 3, 1]
      ...> |> BinarySearchTree.create
      ...> BinarySearchTree.compare(tree_a, tree_b)
      false

  """
  @spec compare(tree, tree) :: tree
  def compare(tree_a, tree_b), do: compare(true, tree_a, tree_b)

  defp compare(acc, nil, nil), do: acc
  defp compare(_, nil, _), do: false
  defp compare(_, _, nil), do: false
  defp compare(_, %Node{data: data_a}, %Node{data: data_b}) when data_a != data_b, do: false
  defp compare(acc, node1, node2) do
    compare(acc, node1.left, node2.left)
    |> compare(node1.right, node2.right)
  end

  @doc """
  Sum the values of all the nodes in the tree.

  ## Examples

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.sum
      6

      iex> []
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.sum
      0

  """
  @spec sum(tree) :: integer
  def sum(node), do: sum(0, node)
  defp sum(acc, nil), do: acc
  defp sum(acc, %Node{data: data, left: left, right: right}) do
    acc + data
    |> sum(left)
    |> sum(right)
  end

  @doc """
  Return the height of the tree.

  ## Examples

      iex> [2]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.height
      1

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.height
      2

      iex> [1, 2, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.height
      3

  """
  @spec height(tree) :: integer
  def height(nil), do: 0
  def height(tree) do
    1 + max(
      height(tree.left),
      height(tree.right)
    )
  end

  @doc """
  Return the number of nodes in the tree.

  ## Examples

      iex> [2]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.size
      1

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.size
      3

  """
  @spec size(tree) :: integer
  def size(tree), do: size(0, tree)

  defp size(acc, nil), do: acc
  defp size(acc, tree) do
    acc + 1
    |> size(tree.left)
    |> size(tree.right)
  end
end
