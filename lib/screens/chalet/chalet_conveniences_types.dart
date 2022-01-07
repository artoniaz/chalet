class ConveniencesTypes {
  static final ConvenienceType paper = ConvenienceType(type: 'paper', name: 'papier');
  static final ConvenienceType clean = ConvenienceType(type: 'clean', name: 'czystość');
  static final ConvenienceType privacy = ConvenienceType(type: 'privacy', name: 'prywatność');
  static final ConvenienceType is24Green = ConvenienceType(type: 'is24_green', name: 'otwarty 24h');
  static final ConvenienceType is24Red = ConvenienceType(type: 'is24_red', name: 'otwarty 24h');
}

class ConvenienceType {
  final String type;
  final String name;
  ConvenienceType({
    required this.type,
    required this.name,
  });
}
