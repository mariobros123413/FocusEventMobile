import 'dart:io';

import 'package:flutter/material.dart';
import '../httpInstance.dart';
import 'package:dio/dio.dart';

class FotosModel extends ChangeNotifier {
  ///  State fields for stateful widgets in this page.
  int? id;
  int? eventoId;
  String? url;
  int? precio;
  int? idgaleria;
  String? uuid;
  String? uuidpersona;
  int? idfotografo;
  bool? usuariomostrar;
  String? urlwm;
  String? correo;
  String? nombre;
  List<FotosModel>? procesado;
  FotosModel(
      {this.id,
      this.eventoId,
      this.url,
      this.precio,
      this.idgaleria,
      this.uuid,
      this.uuidpersona,
      this.idfotografo,
      this.usuariomostrar,
      this.urlwm,
      this.correo,
      this.nombre});
  final unfocusNode = FocusNode();
  final Dio dio = ApiClient.getDioInstance();

  Future<void> fetchApiSolicitud() async {
    try {
      print(eventoId);
      final response = await dio.get('/galeria/${eventoId}');
      print(response.data);
      final List<Map<String, dynamic>> apiDataList = List.from(response.data);
      this.procesado = apiDataList
          .map((data) => FotosModel(
              id: data['id'],
              url: data['url'],
              precio: data['precio'],
              idgaleria: data['idgaleria'],
              uuid: data['uuid'],
              uuidpersona: data['uuidpersona'],
              idfotografo: data['idfotografo'],
              usuariomostrar: data['usuariomostrar'],
              urlwm: data['urlwm'],
              correo: data['correo'],
              nombre: data['nombre']))
          .toList();
    } catch (error) {
      // Manejar el error de la solicitud HTTP
      print('ERROR fetchApiSolicitud() : ${error.toString()}');
    }
  }

  Future<void> buscarFotosSimilares(File image) async {
    try {
      // Convierte la imagen a bytes antes de enviarla al servidor
      List<int> imageBytes = await image.readAsBytes();

      // Crea un FormData para enviar la imagen al servidor
      FormData formData = FormData.fromMap({
        'foto': MultipartFile.fromBytes(
          imageBytes,
          filename: 'foto.png',
        ),
      });

      // Realiza la solicitud al servidor para buscar fotos similares
      final response =
          await dio.post('/galeria/buscarFotosSimilares', data: formData);

      // Maneja la respuesta del servidor
      if (response.statusCode == 200) {
        // Procesa los resultados de la búsqueda, por ejemplo, actualiza el estado con las fotos encontradas
        final List<Map<String, dynamic>> apiDataList = List.from(response.data);
        this.procesado = apiDataList
            .map((data) => FotosModel(
                id: data['id'],
                url: data['url'],
                precio: data['precio'],
                idgaleria: data['idgaleria'],
                uuid: data['uuid'],
                uuidpersona: data['uuidpersona'],
                idfotografo: data['idfotografo'],
                usuariomostrar: data['usuariomostrar'],
                urlwm: data['urlwm'],
                correo: data['correo'],
                nombre: data['nombre']))
            .toList();
        notifyListeners(); // Notifica a los oyentes que el estado ha cambiado
      } else {
        // Maneja el error de la solicitud HTTP
        print(
            'ERROR buscarFotosSimilares() - Código de estado no válido: ${response.statusCode}');
      }
    } catch (error) {
      // Maneja el error de la solicitud HTTP
      print('ERROR buscarFotosSimilares() : $error');
    }
  }

  void initState(BuildContext context) {}

  void dispose() {}
}
