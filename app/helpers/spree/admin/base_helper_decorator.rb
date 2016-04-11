Spree::Admin::BaseHelper.class_eval do

  def build_nested_set_tree(node, &block)

    child_nodes = node.is_a?(ActiveRecord::Relation) ? node.roots : node.children

    if node.try(:leaf?)
      ''
    else
      output = ' '
      output << "<ul class = 'tree-menu'>"
      child_nodes.each do |child|
        li_with_class = (@current_folder.try(:id) == child.id) ? "<li class='active folder-link-container'>" :  "<li class='folder-link-container'>"
        output << [li_with_class, capture(child, &block), build_nested_set_tree(child, &block), '</li>'].join('').html_safe
      end

      (output << '</ul>').html_safe
    end
  end

  def digital_assets_next_page_path(digital_assets, current_folder)
    digital_assets.last_page? ? '' : spree.admin_digital_assets_path(folder_id: current_folder.try(:id), page: (digital_assets.next_page), view_more: true)
  end

  def digital_assets_index?
    params[:controller] == 'spree/admin/digital_assets' && params[:action] == 'index'
  end

  def folder_link(folder, options)
    if folder.persisted?
      link_to folder.name, spree.admin_digital_assets_path(folder_id: folder.id), options
    else
      link_to '', '', options
    end
  end

  def delete_folder_link(folder, options)
    if folder.persisted?
      link_to 'Delete', admin_folder_path(folder), options
    else
      link_to 'Delete', '', options
    end
  end

end
