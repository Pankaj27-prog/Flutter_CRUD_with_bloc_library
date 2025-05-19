import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/items_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showItemDialog(BuildContext context, {int? id, String initialName = ''}) {
    final TextEditingController controller = TextEditingController(text: initialName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Item' : 'Update Item'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter item name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                final bloc = context.read<ItemsBloc>();
                if (id == null) {
                  bloc.add(AddItem(name));
                } else {
                  bloc.add(UpdateItem(id, name));
                }

                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Load items only once using a BlocListener or initState (if StatefulWidget)
    // But for StatelessWidget, we avoid loading every rebuild by using addPostFrameCallback.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemsBloc>().add(LoadItems());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter CRUD with Bloc'),
      ),
      body: BlocBuilder<ItemsBloc, ItemsState>(
        builder: (context, state) {
          if (state is ItemLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ItemLoadSuccess) {
            if (state.items.isEmpty) {
              return const Center(child: Text('No items found.'));
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(item['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showItemDialog(
                            context,
                            id: item['id'],
                            initialName: item['name'],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => context.read<ItemsBloc>().add(DeleteItem(item['id'])),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ItemOperationFailure) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Welcome!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
