function imgError(image) {
  image.onerror = "";
  image.src = '/assets/default_file_icon.png';
  return true;
}
