import 'dart:convert';
import 'dart:ffi';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../httpInstance.dart';
import 'package:dio/dio.dart';

import '../user_session.dart';

class PeticionesModel extends ChangeNotifier {
  int? id;
  String? nombre;
  String? descripcion;
  String? direccion;
  String? fecha;
  String? codigo;
  int? idusuario;
  int? idgaleria;
  List<PeticionesModel>? procesado;
  PeticionesModel({
    this.id,
    this.nombre,
    this.descripcion,
    this.direccion,
    this.fecha,
    this.codigo,
    this.idusuario,
    this.idgaleria,
    this.procesado,
  });
  final unfocusNode = FocusNode();
  final Dio dio = ApiClient.getDioInstance();

  Future<void> fetchApiSolicitud() async {
    try {
      print(idusuario);
      final response = await dio.get('/evento/obtenerEventos/${idusuario}');
      print(response.data);
      final List<Map<String, dynamic>> apiDataList = List.from(response.data);
      this.procesado = apiDataList
          .map((data) => PeticionesModel(
                id: data['id'],
                nombre: data['nombre'],
                descripcion: data['descripcion'],
                direccion: data['direccion'],
                fecha: data['fecha'],
                codigo: data['codigo'],
                idusuario: data['idusuario'],
                idgaleria: data['idgaleria'],
              ))
          .toList();
    } catch (error) {
      // Manejar el error de la solicitud HTTP
      print('ERROR fetchApiSolicitud() : $error');
    }
  }

  String formatTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  /// Initialization and disposal methods.
  String? getFormattedTime(DateTime? dateTime) {
    if (dateTime != null) {
      return formatTime(dateTime);
    }
    return null;
  }

  void initState(BuildContext context) {}

  void dispose() {}

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
