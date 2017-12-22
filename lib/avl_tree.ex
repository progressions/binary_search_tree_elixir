defmodule AvlTree do
  defmodule Node do
    defstruct data: nil, left: nil, right: nil
  end
  @type tree :: %BinarySearchTree.Node{}

  @moduledoc """
  Documentation for AvlTree.
  """

  @doc """
  Inserts data into a tree.

  ## Examples

      iex> AvlTree.insert(nil, 10)
      %AvlTree.Node{data: 10, left: nil, right: nil}

  """
  @spec insert(tree :: tree, data :: integer) :: tree
  def insert(tree, data) do
    {result, _} = insert_with_height(tree, data)

    result
  end

  def check_height(left_height, right_height) do
    case left_height - right_height do
      -2 ->
        IO.puts "NEEDS BALANCING ON LEFT"
      2 ->
        IO.puts "NEEDS BALANCING ON RIGHT"
      _ ->
        IO.puts "ITS OK"
    end
  end

  def insert_with_height(nil, data), do: {%Node{data: data}, 1}
  def insert_with_height(%Node{data: node_data}=node, data) when data > node_data do
    {right, right_height} = insert_with_height(node.right, data)
    left_height = height(node.left)

    check_height(left_height, right_height)

    {%Node{data: node.data, left: node.left, right: right}, right_height+1}
  end
  def insert_with_height(%Node{data: node_data}=node, data) when data < node_data do
    {left, left_height} = insert_with_height(node.left, data)
    right_height = height(node.right)

    check_height(left_height, right_height)

    {%Node{data: node.data, left: left, right: node.right}, left_height+1}
  end
  def insert_with_height(node, _), do: {node, height(node)}

  @doc """
  Rotates a node right-right.

  ## Examples

      iex> AvlTree.insert(nil, 20)
      ...> |> AvlTree.insert(30)
      ...> |> AvlTree.insert(40)
      ...> |> AvlTree.rotate_right_right
      %AvlTree.Node{data: 30,
        left: %AvlTree.Node{data: 20, left: nil, right: nil},
        right: %AvlTree.Node{data: 40, left: nil, right: nil}}

  """
  def rotate_right_right(%Node{left: nil, right: nil}=tree), do: tree
  def rotate_right_right(%Node{data: data, left: nil, right: right}) when is_map(right) do
    %Node{data: right.data,
      left: %Node{data: data},
      right: %Node{data: right.right.data}}
  end

  @doc """
  Rotates a node right-left.

  ## Examples

      iex> AvlTree.insert(nil, 20)
      ...> |> AvlTree.insert(40)
      ...> |> AvlTree.insert(30)
      ...> |> AvlTree.rotate_right_left
      %AvlTree.Node{data: 30,
        left: %AvlTree.Node{data: 20, left: nil, right: nil},
        right: %AvlTree.Node{data: 40, left: nil, right: nil}}

  """
  def rotate_right_left(node) do
    %Node{data: node.data,
      left: nil,
      right: %Node{data: node.right.left.data,
        left: nil,
        right: %Node{data: node.right.data}}}
    |> rotate_right_right
  end

  @doc """
  Rotates a node left-left.

  ## Examples

      iex> AvlTree.insert(nil, 40)
      ...> |> AvlTree.insert(30)
      ...> |> AvlTree.insert(20)
      ...> |> AvlTree.rotate_left_left
      %AvlTree.Node{data: 30,
        left: %AvlTree.Node{data: 20, left: nil, right: nil},
        right: %AvlTree.Node{data: 40, left: nil, right: nil}}

  """
  def rotate_left_left(%Node{left: nil, right: nil}=tree), do: tree
  def rotate_left_left(%Node{data: data, left: left, right: nil}) when is_map(left) do
    %Node{data: left.data,
      left: %Node{data: left.left.data},
      right: %Node{data: data}}
  end

  @doc """
  Rotates a node left-right.

  ## Examples

      iex> AvlTree.insert(nil, 40)
      ...> |> AvlTree.insert(20)
      ...> |> AvlTree.insert(30)
      ...> |> AvlTree.rotate_left_right
      %AvlTree.Node{data: 30,
        left: %AvlTree.Node{data: 20, left: nil, right: nil},
        right: %AvlTree.Node{data: 40, left: nil, right: nil}}

  """
  def rotate_left_right(node) do
    %Node{data: node.data,
      right: nil,
      left: %Node{data: node.left.right.data,
        right: nil,
        left: %Node{data: node.left.data}}}
    |> rotate_left_left
  end

  @doc """
  Returns the height of the tree.

  ## Examples

      iex> [2]
      ...> |> BinarySearchTree.create
      ...> |> AvlTree.height
      1

      iex> [2, 1, 3]
      ...> |> BinarySearchTree.create
      ...> |> AvlTree.height
      2

      iex> [1, 2, 3]
      ...> |> BinarySearchTree.create
      ...> |> AvlTree.height
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
end
