import 'package:flutter/material.dart';
import 'package:focusevent/asistencias/asistencias_model.dart';
import 'package:focusevent/fotos/fotos_widget.dart';
import 'package:focusevent/peticiones/peticiones_model.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'fotos/fotos_model.dart';
import 'home/home_model.dart';
import 'login/login_widget.dart';
import 'menu_profile/mprofile_model.dart';
import 'profile/profile_model.dart';
import 'user_session.dart';
import 'dart:io';

void main() {
  //Remove this method to stop OneSignal Debugging
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.initialize("ea34778f-52c6-43f2-815f-cf73c6812d1a");
  HttpOverrides.global = MyHttpOverrides();

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserSession>(
          create: (_) => UserSession(),
        ),
        ChangeNotifierProvider<HomeModel>(
          create: (_) => HomeModel(),
        ),
        ChangeNotifierProvider<ProfileWidgetModel>(
          create: (_) => ProfileWidgetModel(),
        ),
        ChangeNotifierProvider<FotosModel>(
          create: (_) => FotosModel(),
        ),
        ChangeNotifierProvider<PeticionesModel>(
          create: (_) => PeticionesModel(),
        ),
        ChangeNotifierProvider<ProfileModel>(
          create: (_) => ProfileModel(),
        ),
        ChangeNotifierProvider<AsistenciasModel>(
          create: (_) => AsistenciasModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FocusEvent',
      theme: ThemeData(
          // Configura el tema
          ),
      home: LoginWidget(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
