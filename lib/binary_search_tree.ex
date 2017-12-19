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
  def create(list), do: Enum.reduce(list, nil, &(insert(&2, &1)))

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

  ## Examples

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> BinarySearchTree.in_order
      ...> |> Enum.map(&(&1.data))
      [1, 2, 3]

  """
  @spec in_order(tree) :: tree
  def in_order(tree), do: nil

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
  def pre_order(tree), do: nil

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
  def post_order(tree), do: nil

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
  def level_order(tree), do: nil

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
  def next_smallest(tree, root), do: nil

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
  def next_largest(tree, root), do: nil

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
  def largest(tree), do: nil

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
  def smallest(tree), do: nil

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
