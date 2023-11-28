import 'dart:convert';

import 'package:flutter/material.dart';

class UserSession with ChangeNotifier {
  int? id;
  String? uuid;
  String? nombre;
  String? correo;
  String? fotoperfil;
  String? direccion;
  int? idtipousuario;
  String? token;
  UserSession({
    this.uuid,
    this.nombre,
    this.correo,
    this.fotoperfil,
    this.direccion,
    this.idtipousuario,
    this.token,
  }) {}
}
