// import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import 'dart:ffi';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:focusevent/httpInstance.dart';
import 'package:dio/dio.dart';

/// Initialization and disposal methods.
import 'package:http/http.dart' as http;
import 'dart:convert';

final Dio dio = ApiClient.getDioInstance();

class ComentarioValoracion {
  final String? comentario;
  final int? valoracion;

  ComentarioValoracion({this.comentario, this.valoracion});
}

//
class HomeModel extends ChangeNotifier {
  FocusNode? unfocusNode; // Declaración con nullable
  int? id;
  int? idfotografo;
  String? correo;
  String? nombre;
  String? direccion;
  List<HomeModel>? apiDataList;
  int? valoracion;
  String? comentario;
  bool isLoading = false;
  List<HomeModel>? procesado;
  HomeModel(
      {this.id,
      this.idfotografo,
      this.correo,
      this.nombre,
      this.direccion,
      this.valoracion,
      this.apiDataList,
      this.comentario,
      this.procesado});
  // final unfocusNode = FocusNode();

// Dentro de la clase HomeModel
  Future<void> fetchApiData() async {
    try {
      final response = await dio.get('/usuario/getFotografos');

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> apiDataList = List.from(response.data);
        this.procesado = apiDataList
            .map((data) => HomeModel(
                  id: data['id'],
                  idfotografo: data['idfotografo'],
                  correo: data['correo'],
                  nombre: data['nombre'],
                  direccion: data['direccion'],
                  valoracion: int.parse(data['valoracion']),
                  comentario: data['comentario'],
                ))
            .toList();

        // Procesar datos y calcular promedios
        print(procesado);
        List<HomeModel> processedData = procesarDatos(apiDataList);
        this.apiDataList = processedData;
      } else {
        // Manejar error de la solicitud
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar otros errores
      print('Error: $error');
    }
  }

  List<ComentarioValoracion> getComentariosValoracionesPorUsuario(
      int? idusuario) {
    List<ComentarioValoracion> comentariosValoraciones = [];

    // Asegúrate de ajustar el nombre de la propiedad en Procesado
    if (procesado != null) {
      for (var item in procesado!) {
        print(
            'ID: ${item.valoracion}, Correo: ${item.comentario}, Nombre: ${item.idfotografo}');
        print(idusuario);
        if (item.idfotografo == idusuario) {
          // Corregir aquí para comparar con idusuario
          comentariosValoraciones.add(
            ComentarioValoracion(
              comentario: item.comentario,
              valoracion: item.valoracion,
            ),
          );
        }
      }
      print(procesado
          .toString()); // Imprimirá la lista completa (para verificar su contenido)
    }

    return comentariosValoraciones;
  }

  List<HomeModel> procesarDatos(List<Map<String, dynamic>> datos) {
    // Mapa para realizar un seguimiento de las valoraciones por usuario
    Map<int, List<int>> valoracionesPorUsuario = {};

    // Procesar datos originales y agrupar valoraciones por usuario
    for (var data in datos) {
      int idfotografo = data['idfotografo'];
      int valoracion = int.parse(data['valoracion']);
      if (!valoracionesPorUsuario.containsKey(idfotografo)) {
        valoracionesPorUsuario[idfotografo] = [valoracion];
      } else {
        valoracionesPorUsuario[idfotografo]!.add(valoracion);
      }
    }

    // Crear una lista de ValoracionData con promedios de valoraciones
    List<HomeModel> resultados = [];
    valoracionesPorUsuario.forEach((idfotografo, valoraciones) {
      double promedio =
          valoraciones.reduce((a, b) => a + b) / valoraciones.length;

      // Buscar datos originales correspondientes al idUsuario
      var datosUsuario =
          datos.firstWhere((data) => data['idfotografo'] == idfotografo);

      // Crear objeto ValoracionData con promedio y datos originales
      HomeModel valoracionData = HomeModel(
          correo: datosUsuario['correo'],
          nombre: datosUsuario['nombre'],
          direccion: datosUsuario['direccion'],
          idfotografo: datosUsuario['idfotografo'],
          valoracion: promedio.round(),
          comentario: datosUsuario['comentario']);

      resultados.add(valoracionData);
    });

    return resultados;
  }

// ...

  String formatTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

// ...

// Dentro de tu clase HomeModel:
  String? getFormattedTime(DateTime? dateTime) {
    if (dateTime != null) {
      return formatTime(dateTime);
    }
    return null;
  }

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode?.dispose(); // Llama a dispose si unfocusNode no es null
    unfocusNode = null; // Establece unfocusNode en null
    super.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
