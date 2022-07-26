import 'dart:typed_data';

class FilePickedModel{
  
  String name;
  Uint8List bytes;
  String contentType;

  FilePickedModel(this.bytes, this.name, this.contentType);
}