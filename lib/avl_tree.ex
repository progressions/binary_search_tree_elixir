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
    left_height = height(tree.left)
    right_height = height(tree.right)

    {result, _} = insert_with_height({tree, {left_height, right_height}}, data)

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

  def insert_with_height(nil, data), do: {%Node{data: data}, {0,0}}
  def insert_with_height(%Node{data: node_data}=node, data) when data > node_data do
    {right, {l,r}} = insert_with_height(node.right, data)

    IO.inspect {l, r}

    {%Node{data: node.data, left: node.left, right: right}, {l ,r+1}}
  end
  def insert_with_height(%Node{data: node_data}=node, data) when data < node_data do
    {left, {l,r}} = insert_with_height(node.left, data)

    IO.inspect {l, r}

    {%Node{data: node.data, left: left, right: node.right}, {l+1, r}}
  end
  def insert_with_height(node, _), do: {node, {0,0}}

  @doc """
  Rotates a tree right-right.

  A tree requires right-right rotation when the difference between the height of its
  left and right trees is more than one, with the larger number being on the right side,
  and then the difference of the right tree's left and right trees is more than one,
  with the larger number being on the right tree's right side.

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
  Rotates a tree right-left.

  A tree requires right-left rotation when the difference between the height of its
  left and right trees is more than one, with the larger number being on the right side,
  and then the difference of the right tree's left and right trees is more than one,
  with the larger number being on the right tree's left side.

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
  Rotates a tree left-left.

  A tree requires left-left rotation when the difference between the height of its
  left and right trees is more than one, with the larger number being on the left side,
  and then the difference of the left tree's left and right trees is more than one,
  with the larger number being on the left tree's left side.

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

  A tree requires left-left rotation when the difference between the height of its
  left and right trees is more than one, with the larger number being on the left side,
  and then the difference of the left tree's left and right trees is more than one,
  with the larger number being on the left tree's right side.

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
