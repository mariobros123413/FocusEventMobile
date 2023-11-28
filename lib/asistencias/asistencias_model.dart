import 'package:flutter/material.dart';
import '../httpInstance.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl para formatear la hora

class AsistenciasModel extends ChangeNotifier {
  ///  State fields for stateful widgets in this page.
  int? id;
  String? horallegada;
  int? eventoId;
  int? idusuario;
  bool? iscamarografo;
  String? nombre;
  String? descripcion;
  String? direccion;
  String? fecha;
  int? idgaleria;
  List<AsistenciasModel>? procesado;
  AsistenciasModel(
      {this.id,
      this.eventoId,
      this.horallegada,
      this.iscamarografo,
      this.idgaleria,
      this.descripcion,
      this.direccion,
      this.fecha,
      this.nombre});
  final Dio dio = ApiClient.getDioInstance();

  Future<void> fetchApiSolicitud() async {
    try {
      print(idusuario);
      final response = await dio.get('/evento/getAsistencias/${idusuario}');
      print(response.data);
      final List<Map<String, dynamic>> apiDataList = List.from(response.data);
      this.procesado = apiDataList
          .map((data) => AsistenciasModel(
              id: data['id'],
              horallegada: data['horallegada'],
              eventoId: data['idevento'],
              idgaleria: data['idgaleria'],
              iscamarografo: data['iscamarografo'],
              descripcion: data['descripcion'],
              direccion: data['direccion'],
              fecha: data['fecha'],
              nombre: data['nombre']))
          .toList();
    } catch (error) {
      // Manejar el error de la solicitud HTTP
      print('ERROR fetchApiSolicitud() : $error');
    }
  }

  Future<void> registrarAsistencia(String? code) async {
    String horaActual = DateFormat('HH:mm').format(DateTime.now());
    print('code : $code');
    try {
      print(idusuario);
      Map<String, dynamic> postData = {
        'codigo': code,
        'idusuario': idusuario,
        "horallegada": horaActual
      };

      final response = await dio.post('/evento/ingresarEvento', data: postData);
      print(response.data);
    } catch (error) {
      // Manejar el error de la solicitud HTTP
      print('ERROR fetchApiSolicitud() : $error');
    }
  }

  void initState(BuildContext context) {}

  void dispose() {}
}
