function imgError(image) {
  image.onerror = "";
  image.src = '/assets/spree_digital_assets/file_icon.png';
  return true;
}
