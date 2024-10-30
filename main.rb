require_relative 'lib/tree'

tree = Tree.new(Array.new(15) { rand(1..100) })

puts tree.balance?
# => true

p tree.level_order_recur
p tree.preorder
p tree.inorder
p tree.postorder

unbalance_arr = [150, 160, 532, 321, 481]

unbalance_arr.each do |n|
  tree.insert(n)
end

puts tree.balance?
# => false

tree.rebalance unless tree.balance?

puts tree.balance?
# => true

p tree.level_order_recur
p tree.preorder
p tree.inorder
p tree.postorder
