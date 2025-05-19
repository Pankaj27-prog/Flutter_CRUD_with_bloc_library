import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/db/database_helper.dart';

/// EVENTS
sealed class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadItems extends ItemsEvent {}

class AddItem extends ItemsEvent {
  final String name;
  const AddItem(this.name);

  @override
  List<Object> get props => [name];
}

class UpdateItem extends ItemsEvent {
  final int id;
  final String name;
  const UpdateItem(this.id, this.name);

  @override
  List<Object> get props => [id, name];
}

class DeleteItem extends ItemsEvent {
  final int id;
  const DeleteItem(this.id);

  @override
  List<Object> get props => [id];
}

/// STATES
sealed class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsInitial extends ItemsState {}

class ItemLoadInProgress extends ItemsState {}

class ItemLoadSuccess extends ItemsState {
  final List<Map<String, dynamic>> items;
  const ItemLoadSuccess(this.items);

  @override
  List<Object> get props => [items];
}

class ItemOperationFailure extends ItemsState {
  final String message;
  const ItemOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}

/// BLOC
class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final DatabaseHelper databaseHelper;

  ItemsBloc(this.databaseHelper) : super(ItemsInitial()) {
    on<LoadItems>(_onLoadItems);
    on<AddItem>(_onAddItem);
    on<UpdateItem>(_onUpdateItem);
    on<DeleteItem>(_onDeleteItem);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ItemsState> emit) async {
    emit(ItemLoadInProgress());
    try {
      final items = await databaseHelper.fetchItems();
      emit(ItemLoadSuccess(items));
    } catch (_) {
      emit(const ItemOperationFailure("Failed to fetch items."));
    }
  }

  Future<void> _onAddItem(AddItem event, Emitter<ItemsState> emit) async {
    await databaseHelper.insertItem(event.name);
    add(LoadItems());
  }

  Future<void> _onUpdateItem(UpdateItem event, Emitter<ItemsState> emit) async {
    await databaseHelper.updateItem(event.id, event.name);
    add(LoadItems());
  }

  Future<void> _onDeleteItem(DeleteItem event, Emitter<ItemsState> emit) async {
    await databaseHelper.deleteItem(event.id);
    add(LoadItems());
  }
}
