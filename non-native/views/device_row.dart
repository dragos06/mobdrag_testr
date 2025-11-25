import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceRow extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;

  const DeviceRow({super.key, required this.device, required this.onTap});

  Color _statusColor(DeviceStatus status) {
    switch (status) {
      case DeviceStatus.available:
        return Colors.green;
      case DeviceStatus.inUse:
        return Colors.amber;
      case DeviceStatus.retired:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Card(
                color: const Color(0xFFF0F0F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.phone_android, color: Colors.black),
                ),
              ),
              const SizedBox(width: 12),

              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.model,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device.os,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              
              CircleAvatar(
                radius: 8,
                backgroundColor: _statusColor(device.status),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
