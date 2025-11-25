import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/device_viewmodel.dart';
import 'add_device_screen.dart';
import 'device_details_screen.dart';
import 'device_row.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DeviceViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text('Devices', style: TextStyle(fontWeight: FontWeight.w600),),
        centerTitle: true,
        backgroundColor: const Color(0xFFF0F0F0),
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black.withOpacity(0.05),
            height: 1,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: viewModel.devices.length,
        itemBuilder: (_, index) {
          final device = viewModel.devices[index];
          return DeviceRow(
            device: device,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeviceDetailsScreen(deviceId: device.localId),
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Container(
              color: Colors.black.withOpacity(0.05),
              height: 1,
            ),
            Container(
              color: const Color(0xFFF0F0F0),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                  _BottomBarButton(
                    icon: Icons.phone_android,
                    label: 'Devices',
                    color: Colors.blue,
                    onTap: () {},
                  ),
                  
                  _BottomBarButton(
                    icon: Icons.add_circle_outline,
                    label: 'Add Device',
                    color: Colors.black54,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddDeviceScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BottomBarButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
