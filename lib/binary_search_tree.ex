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
  def insert(node, data) do
    cond do
      data > node.data ->
        %Node{data: node.data, left: node.left, right: insert(node.right, data)}
      data < node.data ->
        %Node{data: node.data, left: insert(node.left, data), right: node.right}
      true ->
        node
    end
  end

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
  def find(%{data: data}=node, data), do: node
  def find(nil, _), do: nil
  def find(node, data) do
    find(node.left, data) || find(node.right, data)
  end

  @doc """
  Find the element with the next smallest data given a node and the root node.

  """
  def next_smallest(%{left: node}, _) when is_map(node), do: largest(node)
  def next_smallest(node, root), do: next_smallest(node, root, nil)
  defp next_smallest(node, root, successor) do
    cond do
      node.data < root.data ->
        next_smallest(node, root.left, successor)
      node.data > root.data ->
        next_smallest(node, root.right, root)
      true ->
        successor
    end
  end

  @doc """
  Find the element with the next largest data given a node and the root node.

  """
  def next_largest(%{right: node}, _) when is_map(node), do: smallest(node)
  def next_largest(node, root), do: next_largest(node, root, nil)
  defp next_largest(node, root, successor) do
    cond do
      node.data < root.data ->
        next_largest(node, root.left, root)
      node.data > root.data ->
        next_largest(node, root.right, successor)
      true ->
        successor
    end
  end

  @doc """
  Find the element with the largest data in the entire tree.

  """
  def largest(%{right: nil}=node), do: node
  def largest(%{right: node}), do: largest(node)

  @doc """
  Find the element with the smallest data in the entire tree.

  """
  def smallest(%{left: nil}=node), do: node
  def smallest(%{left: node}), do: smallest(node)
end
