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
    index_action? && digital_assets_controller?
  end

  def digital_assets_controller?
    controller_name == 'digital_assets'
  end

  def index_action?
    action_name == 'index'
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

  def asset_details(digital_asset)
    { 
      id: digital_asset.id,
      name: digital_asset.name,
      size: number_to_human_size(digital_asset.attachment_file_size), 
      created_on: digital_asset.created_at.to_date.to_formatted_s(:long), 
      modified_on: digital_asset.updated_at.to_date.to_formatted_s(:long), 
      related_products: related_products(digital_asset)
    }
  end

  def related_products(digital_asset)
    products = {}
    digital_asset.assets.each do |asset|
      product = asset.viewable.product
      products[product.id] = { slug: product.slug, name: product.name }
    end
    products.values
  end

end
