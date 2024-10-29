require_relative 'node'

class Tree
  attr_reader :root

  def initialize(array)
    @sorted_array = array.sort.uniq
    @start = 0
    @end = @sorted_array.length - 1
    @root = build_tree(@sorted_array, @start, @end)
  end

  def build_tree(array, start, last)
    return nil if start > last

    mid = (start + last) / 2
    root = Node.new(array[mid])
    root.left = build_tree(array, start, mid - 1)
    root.right = build_tree(array, mid + 1, last)
    root
  end

  def insert(key, root = @root)
    return Node.new(key) if root.nil?

    return root if root.data == key

    if key < root.data
      root.left = insert(key, root.left)
    elsif key > root.data
      root.right = insert(key, root.right)
    end
    root
  end

  def search_successor(root)
    curr = root.right
    loop do
      return curr if curr.left.nil?

      curr = curr.left
    end
  end

  def delete(key, root = @root)
    return root if root.nil?

    if root.data > key
      root.left = delete(key, root.left)
    elsif root.data < key
      root.right = delete(key, root.right)
    else
      return root.right if root.left.nil?
      return root.left if root.right.nil?

      successor = search_successor(root)
      root.data = successor.data
      root.right = delete(successor.data, root.right)
    end
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def find(value, root = @root)
    return root if root.data == value

    return nil if root.nil?

    if value < root.data
      find(value, root.left)
    elsif value > root.data
      find(value, root.right)
    end
  end
end
