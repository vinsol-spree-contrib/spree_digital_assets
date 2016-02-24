Spree::Admin::BaseHelper.class_eval do

  def build_nested_set_tree(node, &block)

    child_nodes = node.is_a?(ActiveRecord::Relation) ? node.roots : node.children

    if node.try(:leaf?)
      ''
    else
      string = ' '
      string << "<ul class = 'tree-menu'>"
      child_nodes.each do |child|
        li_class = (child == @folder) ? 'active' : 'inactive'
        string << ["<li class='#{li_class}'>", capture(child, &block), build_nested_set_tree(child, &block), '</li>'].join('').html_safe
      end

      (string << '</ul>').html_safe
    end
  end


  def digital_assets_list
    @folder.try(:digital_assets) || @digital_asset.try(:folder).try(:digital_assets) || Spree::DigitalAsset.all
  end

end
