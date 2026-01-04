import 'dart:async';
import 'package:flutter/material.dart';
import '../repositories/device_repository.dart';
import '../models/device.dart';

class DeviceViewModel extends ChangeNotifier {
  final DeviceRepository repository;

  final StreamController<List<Device>> _uiStreamController = StreamController<List<Device>>.broadcast();
  Stream<List<Device>> get devicesStream => _uiStreamController.stream;

  Stream<Device?> watchDeviceById(int id) {
    return repository.watchById(id);
  }

  List<Device> _allDevices = [];
  StreamSubscription<List<Device>>? _dbSubscription;
  String _searchQuery = '';
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DeviceViewModel({required this.repository}) {
    _initSubscription();
  }

  void _initSubscription() {
    _dbSubscription = repository.getAll().listen(
          (devices) {
        _allDevices = devices;
        _emitFilteredList();
      },
      onError: (error) {
        print("Stream Error: $error");
        _setError('Error listening to device updates: $error');
        if (!_uiStreamController.isClosed) {
          _uiStreamController.add([]);
        }
      },
    );
  }
  
  void _emitFilteredList() {
    if (_uiStreamController.isClosed) return;

    if (_searchQuery.isEmpty) {
      _uiStreamController.add(_allDevices);
    } else {
      final query = _searchQuery.toLowerCase();
      final filtered = _allDevices.where((device) {
        return device.model.toLowerCase().contains(query) ||
            device.os.toLowerCase().contains(query) ||
            (device.usedBy?.toLowerCase().contains(query) ?? false);
      }).toList();
      _uiStreamController.add(filtered);
    }
  }

  void search(String query) {
    _searchQuery = query;
    _emitFilteredList();
  }

  Future<void> addDevice(Device device) async {
    try {
      _errorMessage = null;
      await repository.add(device);
      
    } catch (e) {
      print("Add Error: $e");
      rethrow;
    }
  }
  
  Future<void> updateDevice(Device device) async {
    try {
      _errorMessage = null;
      await repository.update(device);
    } catch (e) {
      print("Update Error: $e");
      rethrow;
    }
  }
  
  Future<void> deleteDevice(int id) async {
    try {
      _errorMessage = null;
      await repository.delete(id);
    } catch (e) {
      print("Delete Error: $e");
      _setError('Failed to delete device: $e');
      rethrow;
    }
  }

  Future<Device?> getDeviceById(int id) async {
    try {
      _errorMessage = null;
      return await repository.getById(id);
    } catch (e) {
      _setError('Failed to fetch device details: $e');
      return null;
    }
  }

  void _setError(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    _uiStreamController.close();
    super.dispose();
  }
}