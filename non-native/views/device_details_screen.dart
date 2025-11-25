import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device.dart';
import '../viewmodels/device_viewmodel.dart';
import 'update_device_screen.dart';

class DeviceDetailsScreen extends StatelessWidget {
  final int deviceId;

  const DeviceDetailsScreen({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DeviceViewModel>();
    final device = viewModel.getById(deviceId);

    if (device == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: const Center(child: Text('Device not found')),
      );
    }

    final bool canDelete = device.status == DeviceStatus.retired;

    
    String getStatusText(DeviceStatus status) {
      switch (status) {
        case DeviceStatus.available:
          return 'Available';
        case DeviceStatus.inUse:
          return 'In Use';
        case DeviceStatus.retired:
          return 'Retired';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text(
          'Device Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF0F0F0),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Model', device.model),
              const SizedBox(height: 12),
              _buildDetailRow('OS', device.os),
              const SizedBox(height: 12),
              _buildDetailRow('Screen Resolution', device.screenResolution),
              const SizedBox(height: 12),
              _buildDetailRow('Status', getStatusText(device.status)),
              const SizedBox(height: 12),
              _buildDetailRow('Used By', device.usedBy ?? '-'),
              const SizedBox(height: 12),
              _buildDetailRow('Notes', device.notes ?? '-'),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UpdateDeviceScreen(device: device),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Edit Device'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canDelete
                          ? () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: const Color(0xFFF0F0F0),
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to remove this device?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'No',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  viewModel.deleteDevice(device.localId);
                                  Navigator.pop(context); 
                                  Navigator.pop(context); 
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        canDelete ? Colors.red : Colors.red.shade200,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Remove Device'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}
