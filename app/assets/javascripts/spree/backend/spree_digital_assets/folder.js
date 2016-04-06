var Folder = function (selectors) {
  this.folderAssetsContainer = selectors.folderAssetsContainer;
  this.folderArea = selectors.folderArea;
  this.treeMenuContainer = selectors.treeMenuContainer;
  this.wrapper = selectors.wrapper;
  this.body = selectors.body;
  this.buttonGroup = selectors.buttonGroup;
}

Folder.prototype.init = function () {
  var _this = this;

  this.body.on('click', '#folder_assets a.folder-link', function(){
    history.pushState('', '', $(this).attr('href'));
  });

  this.treeMenuContainer.on('click', 'ul.dropdown-menu a.add-folder', function() {
    _this.addFolder($(this));
  }); 

  this.wrapper.on('click', 'a.add-root-folder', function() {
    _this.addFolder($(this));
  });

  this.treeMenuContainer.on('click', 'ul.dropdown-menu a.rename-folder', function() {
    _this.renameFolder($(this));
  });

  this.treeMenuContainer.on('click', 'ul.dropdown-menu a.delete-folder', function(event) {
    var currentFolderId = _this.wrapper.find('#folder_assets').data('current');
    if($(this).data('id') != currentFolderId) {
      $.ajax(_this.getDeleteRequestParams($(this)));
      return false;
    }
  });

  this.wrapper.on('click', '.modal input[type="submit"]', function(event) {
    event.preventDefault();
    $.ajax(_this.getCreateRequestParams($(this)));
  });

}

Folder.prototype.handleFolderTreeModification = function (data) {
  this.wrapper.find('.modal').modal('hide').data('bs.modal', null);
  if(this.wrapper.find('a[data-id="' + data['id'] + '"]').length) {
    this.renameFolderInSideBar(data);
    this.renameFolderInCurrentFolder(data);
  } else {
    this.addNewFolderToSideBar(data);
    this.addNewFolderToCurrentFolder(data);
  }
};

Folder.prototype.deleteFolder = function (data) {
  this.buttonGroup.filter('.open').removeClass('open').find('button').attr('aria-expanded', 'false');
  if(data['folder']) {
    this.deleteFolderInSideBar(data['folder']);
    this.deleteFolderInCurrentFolder(data['folder']);
  } else {
    show_flash('danger', 'Please make sure folder must be empty before deletion.');
  }
};

Folder.prototype.addFolder = function (link) {
  this.addParentId(link);
  this.removeName();
  this.changeFormForCreate(link);
};

Folder.prototype.renameFolder = function (link) {
  this.addName(link);
  this.removeParentId();
  this.setCurrentFolder();
  this.changeFormForUpdate(link);
};

Folder.prototype.addNewFolderToSideBar = function (data) {
  var $folderElement = this.createFolder(data);
  var $parent = $('a[data-id="' + data['parent_id'] + '"]').filter('.link').parents('li:first');
  if(!$parent.length) {
    $parent = $('div.tree-menu-container');
  }
  if($parent.children('ul.tree-menu').length)
    $parent.children('ul.tree-menu').append($folderElement);
  else
    $parent.append($('<ul>').addClass('tree-menu').append($folderElement));
  $parent.children('ul.tree-menu').css('display', 'block');
}

Folder.prototype.createFolder = function (data) {
  var $folderElement = $('.modification-content').children('li').clone();
  this.addAttributes($folderElement, data);
  return $folderElement;
}

Folder.prototype.addAttributes = function (element, data) {
  element.find('a[data-toggle="modal"]').attr('data-id', data['id']).attr('data-name', data['name']);
  element.find('a.delete-folder').attr('data-id', data['id']).attr('href', '/admin/folders/' + data['id']);
  element.find('a.sidebar-default-font')
    .attr('data-id', data['id'])
    .attr('href', '/admin/digital_assets?folder_id=' + data['id'])
    .text(data['name']);
}

Folder.prototype.getCreateRequestParams = function (link) {
  var _this = this;
  return {
    'url': this.wrapper.find('.modal #new_folder_form').attr('action'),
    'method': this.wrapper.find('.modal #new_folder_form').attr('method'), 
    'dataType': 'JSON',
    'data': {
      'utf8': this.wrapper.find('.modal #new_folder_form').find('[name="utf8"]').val(),
      'authenticity_token': this.wrapper.find('.modal #new_folder_form').find('[name="authenticity_token"]').val(),
      'commit': link.val(),
      'folder_id': this.wrapper.find('.modal #new_folder_form').find('#folder_id').val(),
      'folder': {
        'name': this.wrapper.find('.modal #new_folder_form').find('#folder_name').val(),
        'parent_id': this.wrapper.find('.modal #new_folder_form').find('.parent_id').val()
      }
    },
    success: function(data) {
      _this.handleFolderTreeModification(data['folder']);
    }
  };
};

Folder.prototype.getDeleteRequestParams = function (link) {
  var _this = this;
  return {
    'url': link.attr('href'),
    'method': link.data('method'), 
    'dataType': 'JSON',
    'data': {
      'folder_id': link.data('id')
    },
    success: function(data) {
      _this.deleteFolder(data);
    }
  };
};

Folder.prototype.addNewFolderToCurrentFolder = function (data) {
  var currentFolderId = $('#folder_assets').data('current');
  if(data['parent_id'] == currentFolderId) {
    this.wrapper.find('#folder_assets').prepend(this.createCenterContainerFolderArea(data));
  }
}

Folder.prototype.createCenterContainerFolderArea = function (data) {
  var $folderArea = $('.modification-content').find('.folder-area').clone();
  $folderArea.find('a.folder-link')
    .attr('data-id', data['id'])
    .attr('href', '/admin/digital_assets?folder_id=' + data['id'])
    .text(data['name']);
  return $folderArea;
}

Folder.prototype.renameFolderInSideBar = function (data) {
  $('a[data-id="' + data['id'] + '"]').filter('.link').html(data['name']).attr('data-name', data['name']);
}

Folder.prototype.renameFolderInCurrentFolder = function (data) {
  this.wrapper.find('a[data-id="' + data['id'] + '"]').filter('.folder-link').html(data['name']);
}

Folder.prototype.deleteFolderInSideBar = function (data) {
  $('a[data-id="' + data['id'] + '"]').filter('.link').closest('li').remove();
}

Folder.prototype.deleteFolderInCurrentFolder = function (data) {
  var currentFolderId = this.wrapper.find('#folder_assets').data('current');
  if(data['descendant_ids'].includes(currentFolderId)) {
    this.wrapper.find('#folder_assets').html('');
    history.pushState('', '', '/admin/digital_assets?folder_id=' + data['parent_id']);
  } else {
    history.pushState('', '', '/admin/digital_assets?folder_id=' + currentFolderId);
    this.wrapper.find('a[data-id="' + data['id'] + '"]').closest('div.folder-area').remove();
  }
}

Folder.prototype.addParentId = function (link) {
  var parentFolderId = link.data('id');
  this.wrapper.find('.modal').find('.parent_id').val(parentFolderId);
}

Folder.prototype.removeParentId = function () {
  this.wrapper.find('.modal').find('.parent_id').val('');
}

Folder.prototype.removeName = function () {
  this.wrapper.find('.modal').find('#folder_name').val('');
}

Folder.prototype.addName = function (link) {
  var folderName = link.data('name');
  this.wrapper.find('.modal').find('#folder_name').val(folderName);
}

Folder.prototype.changeFormForUpdate = function (link) {
  var folderId = link.data('id');
  this.wrapper.find('.modal #new_folder_form').attr('action', "/admin/folders/" + folderId);
  this.wrapper.find('.modal #new_folder_form').attr('method', 'put');
  this.wrapper.find('.modal #new_folder_form').find('input[type="submit"]').val('Update Folder');
}

Folder.prototype.changeFormForCreate = function (link) {
  this.wrapper.find('.modal #new_folder_form').attr('action', "/admin/folders/");
  this.wrapper.find('.modal #new_folder_form').attr('method', 'post');
  this.wrapper.find('.modal #new_folder_form').find('input[type="submit"]').val('Create Folder');
}

$(function () {
  var selectors = {
    folderAssetsContainer: $('#folder_assets'),
    folderArea: $('.folder-area'),
    treeMenuContainer: $('div.tree-menu-container'),
    wrapper: $('#wrapper'),
    body: $('body'),
    buttonGroup: $('.btn-group')
  }
  var folder = new Folder(selectors);
  folder.init();
});