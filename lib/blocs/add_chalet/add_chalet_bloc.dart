import 'package:chalet/blocs/add_chalet/add_chalet_event.dart';
import 'package:chalet/blocs/add_chalet/add_chalet_state.dart';
import 'package:chalet/models/image_model_url.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/repositories/chalet_repository.dart';
import 'package:chalet/repositories/storage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddChaletBloc extends Bloc<AddChaletEvent, AddChaletState> {
  final ChaletRepository chaletRepository;
  final StorageRepository storageRepository;
  AddChaletBloc({
    required this.chaletRepository,
    required this.storageRepository,
  }) : super(AddChaletStateInitial());

  AddChaletState get initialState => AddChaletStateInitial();

  @override
  void onTransition(Transition<AddChaletEvent, AddChaletState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<AddChaletState> mapEventToState(AddChaletEvent event) async* {
    if (event is CreateChalet) {
      yield* _handleCreateChalet(event);
    }
  }

  Stream<AddChaletState> _handleCreateChalet(CreateChalet event) async* {
    yield AddChaletStateLoading();
    try {
      String? chaletId = await chaletRepository.createChalet(event.chalet);
      yield AddChaletChaletAddedLoadingImages();
      List<ImageModelUrl> imagesUrls = await storageRepository.addImagesToStorage(chaletId ?? '', event.images);
      ChaletModel _chalet = event.chalet;
      _chalet.id = chaletId!;
      _chalet.images = imagesUrls;

      yield AddChaletStateCreated(chalet: _chalet);
    } catch (e) {
      yield AddChaletStateError('Wystąpił błąd. Dodaj szalet ponownie.');
    }
  }
}
