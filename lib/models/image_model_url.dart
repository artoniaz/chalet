class ImageModelUrl {
  String imageUrlOriginalSize;
  // String imageUrlMinSize;
  bool isDefault;

  ImageModelUrl({
    required this.imageUrlOriginalSize,
    // required this.imageUrlMinSize,
    required this.isDefault,
  });

  Map<String, dynamic> toJson() => {
        'imageUrlOriginalSize': imageUrlOriginalSize,
        // 'imageUrlMinSize': imageUrlMinSize,
        'isDefault': isDefault,
      };

  fromJson(Map parsedJson) {
    imageUrlOriginalSize = parsedJson['imageUrlOriginalSize'];
    // imageUrlMinSize = parsedJson['imageUrlMinSize'];
    isDefault = parsedJson['isDefault'];
  }
}
