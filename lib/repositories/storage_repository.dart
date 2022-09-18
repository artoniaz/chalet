import 'package:chalet/models/image_model_file.dart';
import 'package:chalet/models/image_model_url.dart';
import 'package:chalet/services/storage_service.dart';

class StorageRepository {
  final _storageService = StorageService();
  Future<List<ImageModelUrl>> addImagesToStorage(String chaletId, List<ImageModelFile> imageFileList) =>
      _storageService.addImagesToStorage(chaletId, imageFileList);
}
