$(document).ready(function() {
  $('#associate_asset_modal').on('click', '.asset-area', function() {
    $('#digital_asset_id_field').val($(this).find('.attachment').attr('data-id'));
    $('#digital_asset_file_name').val($(this).find('.attachment').attr('data-name'));
    $(this).siblings().removeClass('active');
    $(this).addClass('active');
  });

  $('#associate_asset_modal').on('dblclick', '.asset-area', function() {
    $('#associate_asset_modal').modal('hide');
  });
});
