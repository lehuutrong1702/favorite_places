import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/repositories/place_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final placesProvider = FutureProvider((ref) {
  final repository = ref.watch(placesRepositoryProvider); 
  return repository.allPlaces(); 
}) ;


final placesControllerProvider = Provider((ref) {
  final repository = ref.watch(placesRepositoryProvider);
  return PlacesController(ref, repository) ;
}) ; 

class PlacesController  {
  
  ProviderRef ref;
  PlacesRepository repository;

  PlacesController(this.ref, this.repository);

  void addPlaces(Place value) {
    repository.addPlaces(value);
    ref.refresh(placesProvider);
  }

}