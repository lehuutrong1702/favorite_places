import 'package:favorite_places/controllers/places_controller.dart';
import 'package:favorite_places/widgets/new_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Places"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return NewPlace();
                  }),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ref.watch(placesProvider).when(
            data: (placeItems) {
              dynamic content = Center(
                child: Text(
                  "Not place found",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              );

              if (placeItems.isNotEmpty) {
                content = Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: placeItems.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          child: Text(
                            placeItems[index].title,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground),
                          ),
                        );
                      }),
                );
              }

              return content;
            },
            error: (error, trace) => Center(child: Text(error.toString())),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
