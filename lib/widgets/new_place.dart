import 'dart:io';

import 'package:favorite_places/controllers/places_controller.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/add_image.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlace extends ConsumerWidget {
  NewPlace({super.key});

  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  final _enteredTitleController = TextEditingController();
  void _savePlace(BuildContext context, WidgetRef ref) {
    if (_formKey.currentState!.validate() && _pickedImage != null) {
      _formKey.currentState!.save();

      Place newPlace =
          Place(title: _enteredTitleController.text, image: _pickedImage!);

      final controller = ref.read(placesControllerProvider);

      controller.addPlaces(newPlace);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new place'),
      ),
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _enteredTitleController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  // initialValue: _enteredTitleController.text,
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
                    _enteredTitleController.text = value!;
                  },
                ),
                const SizedBox(height: 10),
                ImageInput(
                  onPickImage: (image) {
                    _pickedImage = image;
                  },
                ),
                const SizedBox(height: 10),
                LocationInput(),
                  const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    _savePlace(context, ref);
                  },
                  label: const Text('Add place'),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
