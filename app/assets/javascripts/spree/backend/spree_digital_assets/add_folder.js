var Folder = function () {

}

Folder.prototype.init = function () {
  var _this = this;
  $('div.tree-menu-container').on('click', 'ul.dropdown-menu a.add-folder', function() {
    _this.addParentId($(this));
    _this.removeName();
    _this.setCurrentFolder();
    _this.changeFormForCreate($(this));
  });
  $('div.tree-menu-container').on('click', 'ul.dropdown-menu a.rename-folder', function() {
    _this.addName($(this));
    _this.removeParentId();
    _this.setCurrentFolder();
    _this.changeFormForUpdate($(this));
  });
  $('div.tree-menu-container').on('click', 'ul.dropdown-menu a.delete-folder', function(event) {
    event.preventDefault();
    $.ajax({
      'url': $(this).attr('href'),
      'method': $(this).data('method'), 
      'dataType': 'JSON',
      'data': {
        'folder_id': $(this).data('id')
      },
      success: function(data) {
        $('.btn-group').filter('.open').removeClass('open').find('button').attr('aria-expanded', 'false');
        _this.deleteFolderInSideBar(data);
        _this.deleteFolderInCurrentFolder(data);
      }
    });
  });
  $('#wrapper').on('click', '.modal form input[type="submit"]', function(event) {
    event.preventDefault();
    var form = $('.modal').find('form');
    $.ajax({
      'url': form.attr('action'),
      'method': form.attr('method'), 
      'dataType': 'JSON',
      'data': {
        'utf8': form.find('[name="utf8"]').val(),
        'authenticity_token': form.find('[name="authenticity_token"]').val(),
        'commit': $(this).val(),
        'folder_id': form.find('#folder_id').val(),
        'folder': {
          'name': form.find('#folder_name').val(),
          'parent_id': form.find('.parent_id').val()
        }
      },
      success: function(data) {
        $( '.modal' ).modal( 'hide' ).data( 'bs.modal', null );
        if(data['commit'] == 'create') {
          _this.addNewFolderToSideBar(data);
          _this.addNewFolderToCurrentFolder(data);
        }
        else {
          _this.renameFolderInSideBar(data);
          _this.renameFolderInCurrentFolder(data);
        }
      }
    });
  });
  $("body").on('click', '#folder_assets .asset-area a', function(){
    history.pushState('', '', $(this).attr('href'));
  });
}

Folder.prototype.addNewFolderToSideBar = function (data) {
  var $folderElement = $('<li>').append(this.createListElement(data['id'], data['name']));
  $folderElement.append($('<a>').addClass('toggle_list_menu glyphicon glyphicon-chevron-right'));
  $folderElement.append($('<a>').addClass('link sidebar-default-font')
    .attr('data-id', data['id'])
    .attr('data-remote', 'true')
    .text(data['name'])
    .attr('href', '/admin/digital_assets?folder_id=' + data['id']));
  var $parent = $('a[data-id="' + data['parent_id'] + '"]').filter('.link').closest('li');
  if($parent.children('ul.tree-menu').length)
    $parent.children('ul.tree-menu').append($folderElement);
  else
    $parent.append($('<ul>').addClass('tree-menu').append($folderElement));
  $parent.children('ul.tree-menu').css('display', 'block');
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
  $list.append($('<li>').append($('<a>').addClass('add-folder').attr('data-toggle', 'modal').attr('data-target', '#add-subfolder').attr('data-id', id).attr('data-name', name).attr('href', '#').text('Add Folder')));
  $list.append($('<li>').append($('<a>').addClass('rename-folder').attr('data-toggle', 'modal').attr('data-target', '#add-subfolder').attr('data-id', id).attr('data-name', name).attr('href', '#').text('Rename')));
  $list.append($('<li>').addClass('divider').attr('role', 'seperator'));
  $list.append($('<li>').append($('<a>').addClass('delete-folder').attr('data-remote', 'true').attr('data-method', 'delete').attr('data-id', id).attr('href', '/admin/folders/' + id).text('Delete')));
  return $list;
}

Folder.prototype.addNewFolderToCurrentFolder = function (data) {
  var currentFolderId = $('#folder_assets').data('current');
  if(data['parent_id'] == currentFolderId) {
    $('#folder_assets').prepend($('<div>')
      .addClass('text-center asset-area')
      .append($('<div>')
        .addClass('folder-image'))
      .append($('<p>')
        .append($('<a>').attr('data-remote', 'true')
          .attr('data-id', data['id'])
          .attr('href', '/admin/digital_assets?folder_id=' + data['id'])
          .text(data['name']))));
  }
}

Folder.prototype.renameFolderInSideBar = function (data) {
  $('a[data-id="' + data['id'] + '"]').filter('.link').html(data['name']).attr('data-name', data['name']);
}

Folder.prototype.renameFolderInCurrentFolder = function (data) {
  $('.asset-area').find('a[data-id="' + data['id'] + '"]').html(data['name']);
}

Folder.prototype.deleteFolderInSideBar = function (data) {
  $('a[data-id="' + data['id'] + '"]').filter('.link').closest('li').remove();
}

Folder.prototype.deleteFolderInCurrentFolder = function (data) {
  $('.asset-area').find('a[data-id="' + data['id'] + '"]').closest('div.asset-area').remove();
}

Folder.prototype.addParentId = function (link) {
  var parentFolderId = link.data('id');
  $('.modal').find('.parent_id').val(parentFolderId);
}

Folder.prototype.removeParentId = function () {
  $('.modal').find('.parent_id').val('');
}

Folder.prototype.removeName = function () {
  $('.modal').find('#folder_name').val('');
}

Folder.prototype.setCurrentFolder = function () {
  var currentFolderId = $('#folder_assets').data('current');
  $('.modal').find('#folder_id').val(currentFolderId);
}

Folder.prototype.addName = function (link) {
  var folderName = link.data('name');
  $('.modal').find('#folder_name').val(folderName);
}

Folder.prototype.changeFormForUpdate = function (link) {
  var folderId = link.data('id');
  $('.modal').find('form').attr('action', "/admin/folders/" + folderId);
  $('.modal').find('form').attr('method', 'put');
  $('.modal').find('form').find('input[type="submit"]').val('Update Folder');
}

Folder.prototype.changeFormForCreate = function (link) {
  var folderId = link.data('id');
  $('.modal').find('form').attr('action', "/admin/folders/");
  $('.modal').find('form').attr('method', 'post');
  $('.modal').find('form').find('input[type="submit"]').val('Create Folder');
}

$(function () {
  var folder = new Folder();
  folder.init();
});
