import 'package:favorite_places/controllers/places_controller.dart';
import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlace extends ConsumerWidget {
  NewPlace({super.key});

  final _formKey = GlobalKey<FormState>();

  void _savePlace(BuildContext context,WidgetRef ref) {
      if(_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        Place newPlace = Place(title: _enteredTitle);

        final controller = ref.read(placesControllerProvider)  ;

        controller.addPlaces(newPlace);

        Navigator.of(context).pop();
      }
  }

  var _enteredTitle = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new place'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              initialValue: _enteredTitle,
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('title'),
                  
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return ("This field can not empty");
                }
                return null;
              },
              onSaved: (value) {
                _enteredTitle = value!;
              },
            ),
            ElevatedButton.icon(onPressed: (){
              _savePlace(context, ref);
            }, label: const Text('Add place'), icon: const Icon(Icons.add),) ,
          ],
        ),
      ),
    );
  }
}
