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

  def level_order_recur(queue = [@root], data = [], &block)
    root = queue.shift
    queue << root.left unless root.left.nil?
    queue << root.right unless root.right.nil?

    if block_given?
      block.call(root.data)
    else
      data << root.data
    end
    return if queue.empty?

    level_order_recur(queue, data, &block)
    data
  end

  def level_order(&block)
    queue = Array.new(1, @root)
    data = []
    until queue.empty?
      root = queue.shift
      queue << root.left unless root.left.nil?
      queue << root.right unless root.right.nil?

      if block_given?
        block.call(root.data)
      else
        data << root.data
      end
    end
    data
  end

  def preorder(root = @root, data = [], &block)
    return data if root.nil?

    if block_given?
      block.call(root.data)
    else
      data << root.data
    end
    preorder(root.left, data)
    preorder(root.right, data)
  end

  def inorder(root = @root, data = [], &block)
    return data if root.nil?

    inorder(root.left, data)

    if block_given?
      block.call(root.data)
    else
      data << root.data
    end

    inorder(root.right, data)
  end

  def postorder(root = @root, data = [], &block)
    return data if root.nil?

    postorder(root.left, data)
    postorder(root.right, data)

    if block_given?
      block.call(root.data)
    else
      data << root.data
    end
  end

  def depth(node, root = @root)
    return -1 if root.nil?

    dist = -1

    if node == root ||
       (dist = depth(node, root.left)) >= 0 ||
       (dist = depth(node, root.right)) >= 0
      return dist + 1
    end

    dist
  end

  def height_util(node, root)
    return -1 if root.nil?

    left_height = height_util(node, root.left)
    right_height = height_util(node, root.right)

    ans = [left_height, right_height].max + 1

    @height = ans if node == root

    ans
  end

  def height(node = @root, root = @root)
    @height = -1
    height_util(node, root)
    @height
  end

  def balance?
    left_height = height(root.left)
    right_height = height(root.right)
    difference = left_height - right_height
    difference.between?(-1, 1)
  end

  def rebalance
    array = level_order_recur.sort
    @root = build_tree(array, 0, array.length - 1)
  end
end
