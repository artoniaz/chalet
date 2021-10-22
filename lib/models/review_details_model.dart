class ReviewDetailsModel {
  double clean;
  double paper;
  double privacy;
  String describtionExtended;

  ReviewDetailsModel({
    required this.clean,
    required this.paper,
    required this.privacy,
    required this.describtionExtended,
  });

  factory ReviewDetailsModel.fromJson(Object? json) {
    return ReviewDetailsModel(
      clean: (json as dynamic)['clean'] ?? 0.0,
      paper: (json as dynamic)['paper'] ?? 0.0,
      privacy: (json as dynamic)['privacy'] ?? 0.0,
      describtionExtended: (json as dynamic)['describtionExtended'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'clean': clean,
        'paper': paper,
        'privacy': privacy,
        'describtionExtended': describtionExtended,
      };
}
