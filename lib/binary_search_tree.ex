defmodule BinarySearchTree do
  defmodule Node do
    defstruct data: nil, left: nil, right: nil
  end

  @moduledoc """
  Documentation for BinarySearchTree.
  """

  @doc """
  Insert data into a tree.

  ## Examples

      iex> BinarySearchTree.insert(nil, 10)
      %BinarySearchTree.Node{data: 10, left: nil, right: nil}

  """
  def insert(nil, data), do: %Node{data: data}
  def insert(%Node{data: node_data}=node, data) when data > node_data, do:
    %Node{data: node.data, left: node.left, right: insert(node.right, data)}
  def insert(%Node{data: node_data}=node, data) when data < node_data, do:
    %Node{data: node.data, left: insert(node.left, data), right: node.right}
  def insert(node, _), do: node

  @doc """
  Balance a tree into an even distribution of left and right branches.

  """
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

  """
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

  """
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

  """
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

  """
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

  """
  def find(%Node{data: data}=node, data), do: node
  def find(nil, _), do: nil
  def find(%Node{left: left, right: right}, data) do
    find(left, data) || find(right, data)
  end

  @doc """
  Find the element with the next smallest data given a node and the root node.

  """
  def next_smallest(%Node{left: node}, _) when is_map(node), do: largest(node)
  def next_smallest(node, root), do: next_smallest(node, root, nil)

  defp next_smallest(%Node{data: node_data}=node, %Node{data: root_data, left: left}, successor)
    when node_data < root_data, do: next_smallest(node, left, successor)
  defp next_smallest(%Node{data: node_data}=node, %Node{data: root_data, right: right}=root, _)
    when node_data > root_data, do: next_smallest(node, right, root)
  defp next_smallest(_, _, successor), do: successor

  @doc """
  Find the element with the next largest data given a node and the root node.

  """
  def next_largest(%Node{right: node}, _) when is_map(node), do: smallest(node)
  def next_largest(node, root), do: next_largest(node, root, nil)

  defp next_largest(%Node{data: node_data}=node, %Node{data: root_data, left: left}=root, _)
    when node_data < root_data, do: next_largest(node, left, root)
  defp next_largest(%Node{data: node_data}=node, %Node{data: root_data, right: right}, successor)
    when node_data > root_data, do: next_largest(node, right, successor)
  defp next_largest(_, _, successor), do: successor

  @doc """
  Find the element with the largest data in the entire tree.

  """
  def largest(%Node{right: nil}=node), do: node
  def largest(%Node{right: node}), do: largest(node)

  @doc """
  Find the element with the smallest data in the entire tree.

  """
  def smallest(%Node{left: nil}=node), do: node
  def smallest(%Node{left: node}), do: smallest(node)

  @doc """
  Delete a given element from the tree and move its children into place.

  Return a new version of the tree without the element in place.

  """
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

  """
  def compare(nil, nil), do: true
  def compare(nil, _), do: false
  def compare(_, nil), do: false
  def compare(node1, node2) do
    compare(node1.left, node2.left)
    && compare(node1.right, node2.right)
  end

  @doc """
  Sum the values of all the nodes in the tree.

  """
  def sum(node), do: sum(0, node)
  defp sum(acc, nil), do: acc
  defp sum(acc, %Node{data: data, left: left, right: right}) do
    acc + data
    |> sum(left)
    |> sum(right)
  end
end
