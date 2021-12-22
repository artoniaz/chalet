import 'package:chalet/models/image_model_file.dart';
import 'package:chalet/models/image_model_url.dart';
import 'package:chalet/models/index.dart';
import 'package:equatable/equatable.dart';

abstract class AddChaletEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateChalet extends AddChaletEvent {
  final ChaletModel chalet;
  final List<ImageModelFile> images;
  CreateChalet(this.chalet, this.images);
}
