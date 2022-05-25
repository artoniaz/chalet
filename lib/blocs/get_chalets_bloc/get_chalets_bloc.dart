import 'dart:async';
import 'package:chalet/blocs/get_chalets_bloc/get_chalets_event.dart';
import 'package:chalet/blocs/get_chalets_bloc/get_chalets_state.dart';
import 'package:chalet/config/functions/sorting_chalet_list.dart';
import 'package:chalet/models/index.dart';
import 'package:chalet/repositories/chalet_repository.dart';
import 'package:chalet/screens/chalet/chalet_list/sorting_values.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetChaletsBloc extends Bloc<GetChaletsEvent, GetChaletsState> {
  final ChaletRepository chaletRepository;

  GetChaletsBloc({required this.chaletRepository}) : super(GetChaletsStateInitial());

  StreamSubscription? chaletsSubscription;

  String currentSorting = SortingValues.NEAREST;

  GetChaletsState get initialState => GetChaletsStateInitial();

  @override
  void onTransition(Transition<GetChaletsEvent, GetChaletsState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<GetChaletsState> mapEventToState(GetChaletsEvent event) async* {
    if (event is GetChalets) {
      yield* _handleGetChalets(event);
    }
    if (event is UpdateChalets) {
      yield* _handleUpdateChalets(event);
    }
    if (event is ChangeChaletsSorting) {
      yield* _handleChangeChaletsSorting(event);
    }
  }

  Stream<GetChaletsState> _handleGetChalets(GetChalets event) async* {
    chaletsSubscription?.cancel();
    chaletsSubscription = chaletRepository.getChaletStream(event.subject).listen(
      (chalets) => add(UpdateChalets(chalets)),
      onError: (e) async* {
        yield GetChaletsStateError(errorMessage: 'Błąd pobierania listy Szaletów');
      },
    );
  }

  Stream<GetChaletsState> _handleUpdateChalets(UpdateChalets event) async* {
    yield GetChaletsStateLoaded(
      chaletList: event.chaletList,
      sortingValue: currentSorting,
    );
  }

  Stream<GetChaletsState> _handleChangeChaletsSorting(ChangeChaletsSorting event) async* {
    yield GetChaletsStateSorting();
    List<ChaletModel> chalets = event.chaletList;
    if (event.sortingValue == SortingValues.BEST_RATED) {
      sortChaletsByRatingDesc(chalets);
    } else if (event.sortingValue == SortingValues.NEAREST) {
      sortChaletsByLocationAsc(chalets, event.userLocation);
    } else if (event.sortingValue == SortingValues.IS24) {
      sortChaletsByIs24(chalets);
    }
    currentSorting = event.sortingValue;
    yield GetChaletsStateLoaded(
      chaletList: chalets,
      sortingValue: currentSorting,
    );
  }
}
