import 'package:flutter/material.dart';
import 'package:zyro_flux/presentation/login/splash_page.dart';
import 'core/app_dependencies.dart';
import 'core/storage/local_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorage = LocalStorageService();
  final dependencies = AppDependencies(localStorage);

  runApp(ZyroFluxApp(dependencies: dependencies));
}

class ZyroFluxApp extends StatelessWidget {
  final AppDependencies dependencies;

  const ZyroFluxApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZYRO & FLUX',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: SplashPage(dependencies: dependencies),
    );
  }
}
