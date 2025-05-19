import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/items_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite with Bloc")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter item name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ItemsBloc>().add(AddItem(controller.text));
              controller.clear();
            },
            child: const Text("Add Item"),
          ),
          Expanded(
            child: BlocBuilder<ItemsBloc, ItemsState>(
              builder: (context, state) {
                if (state is ItemLoadInProgress) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ItemLoadSuccess) {
                  final items = state.items;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item['name']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<ItemsBloc>().add(DeleteItem(item['id']));
                          },
                        ),
                      );
                    },
                  );
                } else if (state is ItemOperationFailure) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
