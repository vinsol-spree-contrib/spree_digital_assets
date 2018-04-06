var Folder = function (selectors) {
  this.folderAssetsContainer = selectors.folderAssetsContainer;
  this.folderArea = selectors.folderArea;
  this.treeMenuContainer = selectors.treeMenuContainer;
  this.wrapper = selectors.wrapper;
  this.body = selectors.body;
  this.buttonGroup = selectors.buttonGroup;
  this.modificationContent = selectors.modificationContent;
  this.url = selectors.url
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

  this.wrapper.on('click', '.folder-area .folder-image', function() {
    _this.openFolder($(this));
  });

  this.treeMenuContainer.on('click', 'ul.dropdown-menu a.rename-folder', function() {
    _this.renameFolder($(this));
  });

  this.treeMenuContainer.on('click', 'ul.dropdown-menu a.delete-folder', function(event) {
    var currentFolderId = _this.wrapper.find('#folder_assets').data('current');
    if($(this).closest('.btn-group').siblings('.link').data('id') != currentFolderId) {
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
  var $openFolderLink = this.wrapper.find('a.open-folder-link[data-id="' + data['id'] + '"]');
  if($openFolderLink.length) {
    $openFolderLink.html(data['name']).attr('data-name', data['name']);
  } else {
    this.addNewFolderToSideBar(data);
    this.addNewFolderToCurrentFolder(data);
  }
};

Folder.prototype.deleteFolder = function (data) {
  this.buttonGroup.filter('.open').removeClass('open').find('button').attr('aria-expanded', 'false');
  if(data['folder']) {
    this.wrapper.find('a.open-folder-link[data-id="' + data['folder']['id'] + '"]')
      .closest('.folder-link-container').remove();
  } else {
    show_flash('danger', 'Please make sure folder must be empty before deletion.');
  }
};

Folder.prototype.addFolder = function (link) {
  var dataLink = link.closest('.btn-group').siblings('.link');
  this.addParentId(dataLink);
  this.removeName();
  this.changeFormForCreate();
};

Folder.prototype.renameFolder = function (link) {
  var dataLink = link.closest('.btn-group').siblings('.link');
  this.addName(dataLink);
  this.removeParentId();
  this.changeFormForUpdate(dataLink);
};

Folder.prototype.addNewFolderToSideBar = function (data) {
  var $folderElement = this.createFolder(data);
  var $parent = this.treeMenuContainer.find('a.link[data-id="' + data['parent_id'] + '"]').closest('li');
  if(!$parent.length) {
    $parent = $('div.tree-menu-container');
  }
  $parent.children('.toggle_list_menu').removeClass('glyphicon-chevron-right').addClass('glyphicon-chevron-down');
  if($parent.children('ul.tree-menu').length)
    $parent.children('ul.tree-menu').append($folderElement);
  else
    $parent.append($('<ul>').addClass('tree-menu').append($folderElement));
  $parent.children('ul.tree-menu').css('display', 'block');
}

Folder.prototype.createFolder = function (data) {
  var $folderElement = $('.add-sidebar-folder').clone().removeClass('add-sidebar-folder hide');
  this.addAttributes($folderElement, data);
  return $folderElement;
}

Folder.prototype.openFolder = function (folderImage) {
  folderImage.closest('.folder-area').find('.folder-link').click();
}

Folder.prototype.addAttributes = function (element, data) {
  element.find('a.delete-folder').attr('href', this.url + data['id']);
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
      'folder': this.getFolderAttributes()
    },
    success: function(data) {
      _this.handleFolderTreeModification(data['folder']);
    },
    error: function(data) {
      var error = $('<p>', { id: 'errorModal'} ).text(data.responseJSON["errors"]).css('color', 'red');
      error.insertAfter($('input#folder_name'));
    }
  };
};

Folder.prototype.getFolderAttributes = function () {
  var parentFolderId = this.wrapper.find('.modal #new_folder_form').find('.parent_id').val();
  var folderAttributes = {
    'name': this.wrapper.find('.modal #new_folder_form').find('#folder_name').val()
  };
  if(parentFolderId) {
    folderAttributes['parent_id'] = parentFolderId;
  }
  return folderAttributes;
}

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
  var $folderArea = this.modificationContent.find('.folder-area').clone();
  $folderArea.find('a.folder-link')
    .attr('data-id', data['id'])
    .attr('href', '/admin/digital_assets?folder_id=' + data['id'])
    .text(data['name']);
  return $folderArea;
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
  var folderName = link.text();
  this.wrapper.find('.modal').find('#folder_name').val(folderName);
}

Folder.prototype.changeFormForUpdate = function (link) {
  $('p#errorModal').hide();
  var folderId = link.data('id');
  this.wrapper.find('.modal #new_folder_form').attr('action', this.url + folderId);
  this.wrapper.find('.modal #new_folder_form').attr('method', 'put');
  this.wrapper.find('.modal #new_folder_form').find('input[type="submit"]').val('Update Folder');
}

Folder.prototype.changeFormForCreate = function () {
  $('p#errorModal').hide();
  this.wrapper.find('.modal #new_folder_form').attr('action', this.url);
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
    buttonGroup: $('.btn-group'),
    modificationContent: $('.modification-content'),
    url: $("div[data-hook='submit_url']").attr('value')
  }
  var folder = new Folder(selectors);
  folder.init();
});
