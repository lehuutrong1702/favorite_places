import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

final placesRepositoryProvider = Provider((ref) {
  final localDatabaseHandler = ref.watch(localDatabaseHandlerProvider);

  return PlacesRepository(localDatabaseHandler: localDatabaseHandler);
});


final localDatabaseHandlerProvider = Provider(
  (ref) => LocalDatabaseHandler(),
);

class LocalDatabaseHandler {
  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();

    final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    }, version: 1);
    return db;
  }
}

class PlacesRepository {
  PlacesRepository({required this.localDatabaseHandler});

  List<Place> places = [];
  final LocalDatabaseHandler localDatabaseHandler;

  void addPlaces(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    final filename = path.basename(place.image.path);

    final copiedFile = await place.image.copy('${appDir.path}/$filename');

    final newPlace =
        Place(title: place.title, image: copiedFile, location: place.location);

    print(newPlace.image.path.toString());

    final db = await localDatabaseHandler._getDatabase();

    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location!.latitude,
      'lng': newPlace.location!.longitude,
      'address': newPlace.location!.address
    });

    places.add(newPlace);
  }

  Future<List<Place>> allPlaces() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    final db = await localDatabaseHandler._getDatabase();
    final data = await db.query('user_places');
    places = data.map(
      (row) => Place(
          id: row['id'] as String,
          title: row['title'] as String,
          image: File(row['image'] as String),
          location: LocationPlace(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String)),
    ).toList();

    return places;
  }
}
