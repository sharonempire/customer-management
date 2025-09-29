import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});

final snackbarServiceProvider = Provider<SnackbarService>((ref) {
  return const SnackbarService();
});

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class SnackbarService {
  const SnackbarService();

  void showError(BuildContext? context, String message) {
    final messenger = _resolveMessenger(context);
    if (messenger == null) {
      debugPrint(
        'SnackbarService.showError skipped: no ScaffoldMessenger available. Message: $message',
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showSuccess(BuildContext? context, String message) {
    final messenger = _resolveMessenger(context);
    if (messenger == null) {
      debugPrint(
        'SnackbarService.showSuccess skipped: no ScaffoldMessenger available. Message: $message',
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  ScaffoldMessengerState? _resolveMessenger(BuildContext? context) {
    if (context != null) {
      try {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          return messenger;
        }
      } catch (error) {
        debugPrint('SnackbarService context lookup failed: $error');
      }
    }

    return rootScaffoldMessengerKey.currentState;
  }
}

class NetworkService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<bool> rowExists({required String table, required String id}) async {
    try {
      final response =
          await supabase.from(table).select('id').eq('id', id).maybeSingle();

      return response != null; // true if row exists
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return false; // No row found
      throw parseError(e.message, 'Failed to check row');
    } catch (e) {
      throw 'Failed to check row: ${e.toString()}';
    }
  }

  Future<bool> emailExists({
    required String table,
    required String email,
  }) async {
    try {
      final response =
          await supabase
              .from(table)
              .select('id')
              .eq('email', email)
              .maybeSingle();

      return response != null; // true if row exists
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return false; // No row found
      throw parseError(e.message, 'Failed to check row');
    } catch (e) {
      throw 'Failed to check row: ${e.toString()}';
    }
  }

  Future<bool> recordExists({
    required String table,
    required Map<String, dynamic> filters,
  }) async {
    try {
      // Start the query
      var query = supabase.from(table).select('id');

      // Apply all filters dynamically
      filters.forEach((key, value) {
        if (value != null) {
          query = query.eq(key, value);
        }
      });

      // maybeSingle → returns null if no matching row
      final response = await query.maybeSingle();

      return response != null; // ✅ True if record exists
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return false; // No row found
      throw parseError(e.message, 'Failed to check record');
    } catch (e) {
      throw 'Failed to check record: ${e.toString()}';
    }
  }

  Future<dynamic> pull({
    required String table,
    Map<String, dynamic>?
    filters, // Supports operators like gte, lte, eq, neq, like, etc.
    int? limit,
    String? orderBy,
    bool ascending = true,
    String? columns,
  }) async {
    try {
      dynamic query = supabase.from(table).select(columns ?? '*');

      // ✅ Apply multiple filters with support for operators
      if (filters != null && filters.isNotEmpty) {
        filters.forEach((key, value) {
          if (value == null) return;

          // If value is a Map → supports operators like gte, lte, neq
          if (value is Map<String, dynamic>) {
            value.forEach((operator, val) {
              if (val == null) return;

              switch (operator) {
                case 'eq':
                  query = query.eq(key, val);
                  break;
                case 'neq':
                  query = query.neq(key, val);
                  break;
                case 'gte':
                  query = query.gte(key, val);
                  break;
                case 'lte':
                  query = query.lte(key, val);
                  break;
                case 'gt':
                  query = query.gt(key, val);
                  break;
                case 'lt':
                  query = query.lt(key, val);
                  break;
                case 'like':
                  query = query.like(key, val);
                  break;
                case 'ilike':
                  query = query.ilike(key, val);
                  break;
                default:
                  throw 'Unsupported operator: $operator';
              }
            });
          } else {
            query = query.eq(key, value);
          }
        });
      }

      // ✅ Apply ordering if provided
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      // ✅ Apply limit if provided
      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw parseError(e.message, 'Failed to fetch data');
    } catch (e) {
      throw 'Failed to fetch data: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>?> pullById({
    required String table,
    required String id,
  }) async {
    try {
      final response =
          await supabase.from(table).select().eq('id', id).single();

      return response as Map<String, dynamic>?;
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return null; // No data found
      }
      throw parseError(e.message, 'Failed to fetch item');
    } catch (e) {
      throw 'Failed to fetch item: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>> push({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response =
          await supabase.from(table).insert(data).select().single();

      return response;
    } on PostgrestException catch (e) {
      throw parseError(e.message, 'Failed to create item');
    } catch (e) {
      throw 'Failed to create item: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>?> update({
    required String table,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    log(id.toString());
    try {
      final response =
          await supabase
              .from(table)
              .update(data)
              .eq('id', id)
              .select()
              .maybeSingle();
      return response;
    } on PostgrestException catch (e) {
      throw parseError(e.message, 'Failed to update item');
    } catch (e) {
      throw 'Failed to update item: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>?> updateWithEmail({
    required String table,
    required String email,
    required Map<String, dynamic> data,
  }) async {
    log(AutofillHints.email.toString());
    try {
      final response =
          await supabase
              .from(table)
              .update(data)
              .eq('email', email)
              .select()
              .maybeSingle();
      return response;
    } on PostgrestException catch (e) {
      throw parseError(e.message, 'Failed to update item');
    } catch (e) {
      throw 'Failed to update item: ${e.toString()}';
    }
  }

  Future<bool> delete({required String table, required String id}) async {
    try {
      final bool deleted = await supabase.from(table).delete().eq('id', id);

      return deleted;
    } on PostgrestException catch (e) {
      throw parseError(e.message, 'Failed to delete item');
    } catch (e) {
      throw 'Failed to delete item: ${e.toString()}';
    }
  }

  Stream<List<Map<String, dynamic>>> subscribeToTable({
    required String table,
    String? filterColumn,
    dynamic filterValue,
  }) {
    try {
      final baseStream = supabase.from(table).stream(primaryKey: ['id']);

      // Apply filter if provided
      if (filterColumn != null && filterValue != null) {
        return baseStream.map(
          (list) =>
              list
                  .where((item) => item[filterColumn] == filterValue)
                  .map((item) => item)
                  .toList(),
        );
      }

      return baseStream.map((list) => list.map((item) => item).toList());
    } catch (e) {
      return Stream.error(e);
    }
  }

  RealtimeChannel subscribeToRealtime({
    required String table,
    String schema = 'public',
    PostgresChangeFilter? filter,
    void Function(PostgresChangePayload payload)? onInsert,
    void Function(PostgresChangePayload payload)? onUpdate,
    void Function(PostgresChangePayload payload)? onDelete,
  }) {
    final channel = supabase.channel('realtime:$schema:$table');

    void register(
      PostgresChangeEvent event,
      void Function(PostgresChangePayload payload)? handler,
    ) {
      if (handler == null) return;
      channel.onPostgresChanges(
        event: event,
        schema: schema,
        table: table,
        filter: filter,
        callback: handler,
      );
    }

    register(PostgresChangeEvent.insert, onInsert);
    register(PostgresChangeEvent.update, onUpdate);
    register(PostgresChangeEvent.delete, onDelete);

    channel.subscribe();
    return channel;
  }

  Future<String> uploadFile({
    required String bucketName,
    required String filePath,
    required Uint8List? fileBytes,
  }) async {
    if (fileBytes == null) return '';
    try {
      await supabase.storage.from(bucketName).uploadBinary(filePath, fileBytes);

      return supabase.storage.from(bucketName).getPublicUrl(filePath);
    } on StorageException catch (e) {
      throw parseError(e.message, 'Failed to upload file');
    } catch (e) {
      throw 'Failed to upload file: ${e.toString()}';
    }
  }

  Future<Uint8List> downloadFile({
    required String bucketName,
    required String filePath,
  }) async {
    try {
      return await supabase.storage.from(bucketName).download(filePath);
    } on StorageException catch (e) {
      throw parseError(e.message, 'Failed to download file');
    } catch (e) {
      throw 'Failed to download file: ${e.toString()}';
    }
  }

  String parseError(String error, String defaultMessage) {
    if (error.contains('violates foreign key constraint')) {
      return 'Related item not found';
    } else if (error.contains('duplicate key value')) {
      return 'Item already exists';
    } else if (error.contains('network error')) {
      return 'Network connection failed';
    } else if (error.contains('JWT')) {
      return 'Authentication failed. Please login again.';
    }
    return '$defaultMessage: ${error.split(']').last.trim()}';
  }

  Future<bool> checkConnection() async {
    try {
      await supabase
          .from('_dummy')
          .select()
          .limit(1)
          .timeout(const Duration(seconds: 5));
      return true;
    } catch (e) {
      return false;
    }
  }

  String? get currentUserId {
    return supabase.auth.currentUser?.id;
  }

  bool get isAuthenticated {
    return supabase.auth.currentUser != null;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await SharedPrefsHelper(prefs).setLoggedIn(false, id: '');
  }

  GoTrueClient get auth => supabase.auth;
}

final todosProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((
  ref,
) {
  final networkService = ref.watch(networkServiceProvider);
  final userId = networkService.currentUserId;

  if (userId == null) {
    return const Stream.empty();
  }

  return networkService.subscribeToTable(
    table: 'todos',
    filterColumn: 'user_id',
    filterValue: userId,
  );
});
