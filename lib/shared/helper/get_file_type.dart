

String getFileType(String type) {
  print("Get File type $type");
  if (type == "pdf") {
    return 'application/pdf';
  } else if (type == 'jpeg') {
    return 'image/jpeg';
  } else if (type == 'png') {
    return 'image/png';
  } else {
    return '';
  }
}
