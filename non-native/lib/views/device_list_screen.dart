import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device.dart';
import '../viewmodels/device_viewmodel.dart';
import 'offline_banner.dart';
import 'add_device_screen.dart';
import 'device_details_screen.dart';
import 'device_row.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceViewModel>().addListener(_onError);
    });
  }

  @override
  void dispose() {
    context.read<DeviceViewModel>().removeListener(_onError);
    _searchController.dispose();
    super.dispose();
  }

  void _onError() {
    final vm = context.read<DeviceViewModel>();
    if (vm.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      vm.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DeviceViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text('Devices', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF0F0F0),
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black.withOpacity(0.05), height: 1),
        ),
      ),
      body: Column(
        children: [


          const OfflineBanner(),


          Container(
            color: const Color(0xFFF0F0F0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search model, OS, or user...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    context.read<DeviceViewModel>().search('');
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => context.read<DeviceViewModel>().search(value),
            ),
          ),


          Expanded(
            child: StreamBuilder<List<Device>>(
              stream: viewModel.devicesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final devices = snapshot.data ?? [];

                if (devices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text('No devices found', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: devices.length,
                  itemBuilder: (_, index) {
                    final device = devices[index];
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
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(color: Colors.black.withOpacity(0.05), height: 1),
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
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}