import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final placesRepositoryProvider = Provider((ref) => PlacesRepository());

class PlacesRepository { 
   List<Place> places = [] ; 


    void addPlaces(Place place) {
        places.add(place);
    } 

    Future<List<Place>> allPlaces() async { 
        await Future.delayed(const Duration(milliseconds: 3000)) ;
        return places;
    }
}