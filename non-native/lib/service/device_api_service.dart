import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../models/device.dart';

class SyncConflictException implements Exception {
  final Device serverDevice;
  SyncConflictException(this.serverDevice);
}

class ServerException implements Exception {
  final int statusCode;
  final String message;
  ServerException(this.message, this.statusCode);

  @override
  String toString() => '$message (Code: $statusCode)';
}

class DeviceApiService {
  static final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  final _socketController = StreamController<Map<String, dynamic>>.broadcast();
  late io.Socket _socket;

  Stream<Map<String, dynamic>> get socketStream => _socketController.stream;

  DeviceApiService() {
    _initSocket();
  }

  void _initSocket() {
    _socket = io.io(_baseUrl, io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());

    _socket.connect();

    _socket.onConnect((_) {
      print('[CLIENT] WebSocket Connected');
      _socketController.add({'type': 'connection_restored'});
    });

    _socket.on('device_added', (data) =>
        _socketController.add({'type': 'add', 'data': data}));

    _socket.on('device_updated', (data) =>
        _socketController.add({'type': 'update', 'data': data}));

    _socket.on('device_deleted', (id) =>
        _socketController.add({'type': 'delete', 'id': id}));
  }

  Future<List<Device>> fetchDevices() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/devices'));
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((e) => Device.fromJson(e)).toList();
      }
      throw ServerException('Server error fetching devices', response.statusCode);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw Exception('Failed to connect to server');
    }
  }

  Future<Device> createDevice(Device device) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/devices'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(device.toJson()),
    );

    if (response.statusCode == 200) {
      return Device.fromJson(jsonDecode(response.body));
    } else {

      final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw ServerException(error, response.statusCode);
    }
  }

  Future<Device> updateDevice(Device device) async {
    if (device.serverId == null) throw Exception("Missing Server ID");

    final response = await http.put(
      Uri.parse('$_baseUrl/devices/${device.serverId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(device.toJson()),
    );

    if (response.statusCode == 200) {
      return Device.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 409) {

      final body = jsonDecode(response.body);
      final serverDevice = Device.fromJson(body['serverData']);
      throw SyncConflictException(serverDevice);
    } else {

      final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
      throw ServerException(error, response.statusCode);
    }
  }

  Future<void> deleteDevice(int serverId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/devices/$serverId'));

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      final error = body['error'] ?? 'Failed to delete on server';
      throw ServerException(error, response.statusCode);
    }
  }

  void dispose() {
    _socket.dispose();
    _socketController.close();
  }
}