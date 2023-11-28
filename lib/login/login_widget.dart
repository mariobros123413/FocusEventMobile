// ignore_for_file: prefer_const_constructors, unused_import, avoid_print

import 'package:provider/provider.dart';
import 'package:focusevent/home/home_widget.dart';
import 'package:local_auth/local_auth.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../menu_profile/mprofile_widget.dart';
import '../user_session.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
// import 'package:provider/provider.dart';
import 'login_model.dart';
export 'login_model.dart';
import '../httpInstance.dart';
import 'package:dio/dio.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;
  LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final Dio dio = ApiClient.getDioInstance();

  Future<bool> login(String correo, String password) async {
    Map<String, dynamic> postData = {
      'correo': correo,
      'password': password,
    };

    try {
      final response = await dio.post('/usuario/login', data: postData);

      // Verifica si el inicio de sesión fue exitoso en base a la respuesta de la API
      if (response.data != null && response.data.containsKey('user')) {
        // Accede a los atributos del usuario
        UserSession userSession =
            Provider.of<UserSession>(context, listen: false);
        Map<String, dynamic> userData = response.data['user'];
        userSession.id = userData['id'];
        userSession.uuid = userData['uuid'];
        userSession.nombre = userData['nombre'];
        userSession.correo = userData['correo'];
        userSession.fotoperfil = userData['fotoperfil'];
        userSession.direccion = userData['direccion'];
        userSession.idtipousuario = userData['idtipousuario'];
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _model = LoginModel(nroregistro: 0, password: '');
    _localAuth = LocalAuthentication();
    _localAuth.canCheckBiometrics.then((b) {
      setState(() {
        _isBiometricAvailable = b;
      });
    });
  }

  @override
  void dispose() {
    _model.dispose(); // Llamada al método dispose() de LoginModel
    super.dispose();
  }

  Future<void> _delayedPop(BuildContext context) async {
    unawaited(
      Navigator.of(context, rootNavigator: true).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Color(0xFF101213),
              body: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
          transitionDuration: Duration.zero,
          barrierDismissible: false,
          barrierColor: Colors.black45,
          opaque: false,
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context)
      ..pop()
      ..pop();
  }

  Future<void> _authenticateWithFingerprint() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Por favor, autentifíquese',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      if (authenticated) {
        // Realizar alguna acción después de la autenticación exitosa
      } else {
        // Realizar alguna acción en caso de autenticación fallida
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF101213),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 1,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.network(
              'https://t3.ftcdn.net/jpg/04/98/66/02/360_F_498660266_nGfbwh1lr2vReDHPPV1ZCAYlTxnX6lXi.jpg',
            ).image,
          ),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://scontent.fvvi1-1.fna.fbcdn.net/v/t1.15752-9/398308058_806063907871492_736907878499778318_n.png?_nc_cat=101&ccb=1-7&_nc_sid=8cd0a2&_nc_ohc=5fI_Ae40GF8AX-wyhNc&_nc_ht=scontent.fvvi1-1.fna&oh=03_AdSM4Q890TxWdXK-FXyZOep9Zzq_vUMU1lkzAoGw1pIttQ&oe=658AA1ED',
                            width: MediaQuery.sizeOf(context).width * 0.823,
                            height: MediaQuery.sizeOf(context).height * 0.2,
                            fit: BoxFit.fitWidth,
                          )),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.00, 0.00),
                      child: Text(
                        'Bienvenido!',
                        textAlign: TextAlign.start,
                        style:
                            FlutterFlowTheme.of(context).displaySmall.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).alternate,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 24),
                        child: Text(
                          'Enfócate en tu evento, nosotros capturamos el momento!',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Outfit',
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _model.correoController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Outfit',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                          hintText: 'Escribe tu correo aquí ',
                          hintStyle: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 14,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Outfit',
                              color: Color(0xFF101213),
                            ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _model.passwordController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                            hintText: 'Escribe tu contraseña aquí',
                            hintStyle:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 14,
                                    ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF101213),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Crear cuenta',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFFF9F9F9),
                                ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: FFButtonWidget(
                          onPressed: () {
                            // Obtener los valores ingresados en los campos de correo y contraseña
                            String correo = _model.correoController.text;

                            String password = _model.passwordController.text;
                            // Llamar a la función de inicio de sesión
                            login(correo, password).then((success) {
                              if (success) {
                                UserSession userSession;
                                try {
                                  userSession = UserSession(correo: correo);

                                  userSession.correo = correo;
                                } catch (e) {
                                  print('Excepción durante la solicitud: $e');
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      // builder: (_) => LoginWidget()),
                                      builder: (context) => HomeWidget()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Inicio de sesión fallido'),
                                  ),
                                );
                              }
                            });
                          },
                          text: 'Iniciar Sesión',
                          options: FFButtonOptions(
                            width: 130,
                            height: 50,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: Color(0xFF39E6EF),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Lexend Deca',
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class NextScreen extends StatelessWidget {
//   const NextScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Next Screen'),
//       ),
//       body: Center(
//         child: Text('Welcome to the next screen!'),
//       ),
//     );
//   }
// }
