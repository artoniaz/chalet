class ConveniencesTypes {
  static final ConvenienceType paper = ConvenienceType(type: 'paper', name: 'papier');
  static final ConvenienceType clean = ConvenienceType(type: 'clean', name: 'czystość');
  static final ConvenienceType privacy = ConvenienceType(type: 'privacy', name: 'prywatność');
  static final ConvenienceType is24 = ConvenienceType(type: 'is24', name: 'otwarty 24h');
}

class ConvenienceType {
  final String type;
  final String name;
  ConvenienceType({
    required this.type,
    required this.name,
  });
}
