import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'repositories/drift_device_repository.dart';
import 'repositories/sync_device_repository.dart';
import 'service/device_api_service.dart';
import 'viewmodels/device_viewmodel.dart';
import 'views/device_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final database = AppDatabase();
  final localRepo = DriftDeviceRepository(database);
  final apiService = DeviceApiService();


  final syncRepository = SyncDeviceRepository(localRepo, apiService);

  runApp(MyApp(repository: syncRepository));
}

class MyApp extends StatelessWidget {
  final SyncDeviceRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeviceViewModel(repository: repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Device Sync',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const DeviceListScreen(),
      ),
    );
  }
}