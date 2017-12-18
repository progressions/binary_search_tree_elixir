defmodule BinarySearchTree do
  defmodule Node do
    defstruct data: nil, parent: nil, left: nil, right: nil
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
  def insert(node, data), do: insert(node, data, node.parent)

  defp insert(nil, data, parent), do: %Node{data: data, parent: parent}
  defp insert(node, data, parent) do
    cond do
      data > node.data ->
        %Node{data: node.data, parent: parent, left: node.left, right: insert(node.right, data, node)}
      data < node.data ->
        %Node{data: node.data, parent: parent, left: insert(node.left, data, node), right: node.right}
      true ->
        node
    end
  end

  def in_order(node) do
    in_order([], node)
    |> Enum.reverse
  end

  defp in_order(acc, nil), do: acc
  defp in_order(acc, node) do
    [node.data | in_order(acc, node.left)]
    |> in_order(node.right)
  end

  def pre_order(node) do
    pre_order([], node)
    |> Enum.reverse
  end

  defp pre_order(acc, nil), do: acc
  defp pre_order(acc, node) do
    [node.data | acc]
    |> pre_order(node.left)
    |> pre_order(node.right)
  end

  def post_order(node) do
    post_order([], node)
    |> Enum.reverse
  end

  defp post_order(acc, nil), do: acc
  defp post_order(acc, node) do
    [ node.data |
      post_order(acc, node.left)
      |> post_order(node.right) ]
  end

  def level_order(node), do: Enum.reverse(level_order([node], []))

  defp level_order([], acc), do: acc
  defp level_order([nil|queue], acc), do: level_order(queue, acc)
  defp level_order([node|queue], acc) do
    queue = queue ++ [node.left]
    queue = queue ++ [node.right]

    level_order(queue, [node.data|acc])
  end

  def find(%{data: data}=node, data), do: node
  def find(nil, _), do: nil
  def find(node, data) do
    find(node.left, data) || find(node.right, data)
  end

  # def next_smallest(%{left: node}), do: walk_right(node)
  def next_smallest(node) do
    IO.inspect(node)
    IO.puts("\n")
    cond do
      node.left ->
        walk_right(node.left)
      node.parent ->
        walk_up(node)
      true -> nil
    end
  end

  defp walk_right(%{right: nil}=node), do: node
  defp walk_right(%{right: node}), do: walk_right(node)

  defp walk_up(node) do
    IO.inspect(node)
    IO.inspect(node.parent)
    IO.inspect(node.parent.right)
    cond do
      node.parent.right == node ->
        node.parent
      true ->
        raise "WTF"
    end
  end
end
