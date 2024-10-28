class Tree
  def initialize(array)
    @array = array
    @start = 0
    @end = @array.length - 1
    @root = build_tree(@array, @start, @end)
  end

  def build_tree(array, start, last)
    sorted_array = @array.sort.uniq
    return nil if start > last

    @mid = start + last / 2
    @root = Node.new(array[@mid])
    @root.left = build_tree(array, start, mid - 1)
    @root.right = build_tree(array, mid + 1, last)
    @root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
   pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
   puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
   pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
 end

end
