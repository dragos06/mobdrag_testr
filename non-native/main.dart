import 'package:flutter/material.dart';
import './repositories/in_memory_device_repository.dart';
import 'package:provider/provider.dart';
import 'viewmodels/device_viewmodel.dart';
import 'views/device_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = InMemoryDeviceRepository();

    return ChangeNotifierProvider(
      create: (_) => DeviceViewModel(repository: repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Device CRUD MVVM',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const DeviceListScreen(),
      ),
    );
  }
}
