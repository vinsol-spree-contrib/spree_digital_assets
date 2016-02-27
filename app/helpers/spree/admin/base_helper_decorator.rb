Spree::Admin::BaseHelper.class_eval do

  def build_nested_set_tree(node, &block)

    child_nodes = node.is_a?(ActiveRecord::Relation) ? node.roots : node.children

    if node.try(:leaf?)
      ''
    else
      output = ' '
      output << "<ul class = 'tree-menu'>"
      child_nodes.each do |child|
        li_with_class = (@current_folder.try(:id) == child.id) ? "<li class='active'>" :  '<li>'
        output << [li_with_class, capture(child, &block), build_nested_set_tree(child, &block), '</li>'].join('').html_safe
      end

      (output << '</ul>').html_safe
    end
  end

end
