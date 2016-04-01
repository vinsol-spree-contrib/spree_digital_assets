var Folder = function (selectors) {
  this.folderAssetsContainer = selectors.folderAssetsContainer;
  this.assetArea = selectors.assetArea;
  this.treeMenuContainer = selectors.treeMenuContainer;
  this.wrapper = selectors.wrapper;
  this.body = selectors.body;
  this.openButtonGroup = selectors.openButtonGroup;
}

Folder.prototype.init = function () {
  var _this = this;

  this.body.on('click', '#folder_assets .asset-area a', function(){
    history.pushState('', '', $(this).attr('href'));
  });

  this.treeMenuContainer.on('click', 'ul.dropdown-menu a.add-folder', function() {
    event.preventDefault();
    _this.addFolder($(this));
  });

  this.treeMenuContainer.on('click', 'ul.dropdown-menu a.rename-folder', function() {
    event.preventDefault();
    _this.renameFolder($(this));
  });

  this.treeMenuContainer.on('click', 'ul.dropdown-menu a.delete-folder', function(event) {
    event.preventDefault();
    $.ajax(_this.getDeleteRequestParams($(this)));
  });

  this.wrapper.on('click', '.modal form input[type="submit"]', function(event) {
    event.preventDefault();
    $.ajax(_this.getCreateRequestParams($(this)));
  });
}

Folder.prototype.handleFolderTreeModification = function (data) {
  this.wrapper.find('.modal').modal('hide').data('bs.modal', null);
  if(data['commit'] == 'create') {
    this.addNewFolderToSideBar(data);
    this.addNewFolderToCurrentFolder(data);
  }
  else {
    this.renameFolderInSideBar(data);
    this.renameFolderInCurrentFolder(data);
  }
};

Folder.prototype.deleteFolder = function (data) {
  this.openButtonGroup.removeClass('open').find('button').attr('aria-expanded', 'false');
  this.deleteFolderInSideBar(data);
  this.deleteFolderInCurrentFolder(data);
};

Folder.prototype.addFolder = function (link) {
  this.addParentId(link);
  this.removeName();
  this.setCurrentFolder();
  this.changeFormForCreate(link);
};

Folder.prototype.renameFolder = function (link) {
  this.addName(link);
  this.removeParentId();
  this.setCurrentFolder();
  this.changeFormForUpdate(link);
};

Folder.prototype.addNewFolderToSideBar = function (data) {
  var $parent = $('a[data-id="' + data['parent_id'] + '"]').filter('.link').closest('li');
  var $folderElement = this.createFolder(data);
  if($parent.children('ul.tree-menu').length)
    $parent.children('ul.tree-menu').append($folderElement);
  else
    $parent.append($('<ul>').addClass('tree-menu').append($folderElement));
  $parent.children('ul.tree-menu').css('display', 'block');
}

Folder.prototype.createFolder = function (data) {
  var $folderElement = $('<li>').append(this.createListElement(data['id'], data['name']));
  $folderElement.append($('<a>').addClass('toggle_list_menu glyphicon glyphicon-chevron-right'));
  $folderElement.append($('<a>').addClass('link sidebar-default-font')
    .attr('data-id', data['id'])
    .attr('data-remote', 'true')
    .text(data['name'])
    .attr('href', '/admin/digital_assets?folder_id=' + data['id']));
  return $folderElement;
}

Folder.prototype.createListElement = function (id, name) {
  var $sideButtonContainer = $('<div>').addClass('btn-group').append(this.createButton(id));
  $sideButtonContainer.append(this.createOptionList(id, name));
  return $sideButtonContainer;
}

Folder.prototype.createButton = function (id) {
  var $button = $('<button>').addClass('btn btn-xs dropdown-toggle')
                             .attr('type', 'button')
                             .attr('aria-expanded', 'false')
                             .attr('aria-haspopup', 'true')
                             .attr('data-toggle', 'dropdown');
  $button.append($('<span>').addClass('glyphicon glyphicon-option-vertical'));
  return $button;
}

Folder.prototype.createOptionList = function (id, name) {
  var $list = $('<ul>').addClass('dropdown-menu');
  $list.append($('<li>').append(this.addAttributes($('<a>'), 'New Folder', this.getCreateLinkAttributes(id, name, 'add-folder'))));
  $list.append($('<li>').append(this.addAttributes($('<a>'), 'Rename', this.getCreateLinkAttributes(id, name, 'rename-folder'))));
  $list.append($('<li>').addClass('divider').attr('role', 'seperator'));
  $list.append($('<li>').append(this.addAttributes($('<a>'), 'Delete', this.getDeleteLinkAttributes(id))));
  return $list;
}

Folder.prototype.getDeleteLinkAttributes = function (id) {
  return { 
    'class': 'delete-folder',
    'data-remote': 'true',
    'data-method': 'delete',
    'data-id': id,  
    'href': '/admin/folders/' + id
  };
};

Folder.prototype.getCreateRequestParams = function (link) {
  var _this = this;
  return {
    'url': this.wrapper.find('.modal form').attr('action'),
    'method': this.wrapper.find('.modal form').attr('method'), 
    'dataType': 'JSON',
    'data': {
      'utf8': this.wrapper.find('.modal form').find('[name="utf8"]').val(),
      'authenticity_token': this.wrapper.find('.modal form').find('[name="authenticity_token"]').val(),
      'commit': link.val(),
      'folder_id': this.wrapper.find('.modal form').find('#folder_id').val(),
      'folder': {
        'name': this.wrapper.find('.modal form').find('#folder_name').val(),
        'parent_id': this.wrapper.find('.modal form').find('.parent_id').val()
      }
    },
    success: function(data) {
      _this.handleFolderTreeModification(data);
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

Folder.prototype.getCreateLinkAttributes = function (id, name, klass) {
  return { 
    'class': klass,
    'data-toggle': 'modal',
    'data-target': '#add-subfolder',
    'data-id': id, 
    'data-name': name, 
    'href': '#'
  };
};

Folder.prototype.addAttributes = function (element, text, attrs) {
  element.text(text);
  $.each(attrs, function(key, value) {
    element.attr(key, value);
  });
  return element;
};

Folder.prototype.addNewFolderToCurrentFolder = function (data) {
  var currentFolderId = $('#folder_assets').data('current');
  if(data['parent_id'] == currentFolderId) {
    this.folderAssetsContainer.prepend(this.createCenterContainerFolderArea(data));
  }
}

Folder.prototype.createCenterContainerFolderArea = function (data) {
  var $assetArea = $('<div>').addClass('text-center asset-area');
  var $folderLink = $('<a>').attr('data-remote', 'true')
          .attr('data-id', data['id'])
          .attr('href', '/admin/digital_assets?folder_id=' + data['id'])
          .text(data['name']);
  $assetArea.append($('<div>').addClass('folder-image'));
  $assetArea.append($('<p>').append($folderLink));
  return $assetArea;
}

Folder.prototype.renameFolderInSideBar = function (data) {
  $('a[data-id="' + data['id'] + '"]').filter('.link').html(data['name']).attr('data-name', data['name']);
}

Folder.prototype.renameFolderInCurrentFolder = function (data) {
  this.assetArea.find('a[data-id="' + data['id'] + '"]').html(data['name']);
}

Folder.prototype.deleteFolderInSideBar = function (data) {
  $('a[data-id="' + data['id'] + '"]').filter('.link').closest('li').remove();
}

Folder.prototype.deleteFolderInCurrentFolder = function (data) {
  this.assetArea.find('a[data-id="' + data['id'] + '"]').closest('div.asset-area').remove();
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

Folder.prototype.setCurrentFolder = function () {
  var currentFolderId = $('#folder_assets').data('current');
  this.wrapper.find('.modal').find('#folder_folder_id').val(currentFolderId);
}

Folder.prototype.addName = function (link) {
  var folderName = link.data('name');
  this.wrapper.find('.modal').find('#folder_name').val(folderName);
}

Folder.prototype.changeFormForUpdate = function (link) {
  var folderId = link.data('id');
  this.wrapper.find('.modal form').attr('action', "/admin/folders/" + folderId);
  this.wrapper.find('.modal form').attr('method', 'put');
  this.wrapper.find('.modal form').find('input[type="submit"]').val('Update Folder');
}

Folder.prototype.changeFormForCreate = function (link) {
  var folderId = link.data('id');
  this.wrapper.find('.modal form').attr('action', "/admin/folders/");
  this.wrapper.find('.modal form').attr('method', 'post');
  this.wrapper.find('.modal form').find('input[type="submit"]').val('Create Folder');
}

$(function () {
  var selectors = {
    folderAssetsContainer: $('#folder_assets'),
    assetArea: $('.asset-area'),
    treeMenuContainer: $('div.tree-menu-container'),
    wrapper: $('#wrapper'),
    body: $('body'),
    openButtonGroup: $('.btn-group').filter('.open')
  }
  var folder = new Folder(selectors);
  folder.init();
});

