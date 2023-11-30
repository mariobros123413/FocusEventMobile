import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../flutter_flow/flutter_flow_util.dart';
import '../fotos/fotos_widget.dart';
import '../user_session.dart';
import 'peticiones_model.dart';
import '../user_session.dart';
import '../httpInstance.dart';
import 'package:dio/dio.dart';

final Dio dio = ApiClient.getDioInstance();

class PeticionesWidget extends StatefulWidget {
  const PeticionesWidget({Key? key}) : super(key: key);

  @override
  _PeticionesWidgetState createState() => _PeticionesWidgetState();
}

// Definir controladores como variables globales
final TextEditingController nombreController = TextEditingController();
final TextEditingController descripcionController = TextEditingController();
final TextEditingController direccionController = TextEditingController();
final TextEditingController fechaController = TextEditingController();
final TextEditingController horaController = TextEditingController();

class _PeticionesWidgetState extends State<PeticionesWidget> {
  late PeticionesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isModalVisible = false;
  final _unfocusNode = FocusNode();
  late UserSession userSession;
  String _qrData = '';

  @override
  void initState() {
    super.initState();
    userSession = Provider.of<UserSession>(context, listen: false);
    _model = Provider.of<PeticionesModel>(context, listen: false);
    _model.idusuario = userSession.id;
    _model.fetchApiSolicitud();
  }

  @override
  void dispose() {
    _model.dispose();
    _unfocusNode.dispose(); // Liberar el FocusNode

    super.dispose();
  }

  Future<void> _refreshPeticiones() async {
    // Lógica para cargar nuevas solicitudes aquí
    _model.fetchApiSolicitud();
    // Esperar un tiempo simulado de 2 segundos (reemplazar con tu lógica de carga real)
    await Future.delayed(Duration(seconds: 2));

    // Actualizar el estado para mostrar las nuevas solicitudes
    setState(() {
      // Actualizar las solicitudes en el modelo o cargar las nuevas solicitudes aquí
    });
  }

  Future<void> _generarQR(String data, String nombre) async {
    setState(() {
      _qrData = data;
      _isModalVisible = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Código QR de $nombre : $data'),
          content: SizedBox(
            width: 200,
            height: 200,
            child: QrImageView(
              data: _qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.purple, // Cambia a tu color femenino preferido
              size: 30,
            ),
            onPressed: () {
              FocusScope.of(context)
                  .unfocus(); // Liberar el enfoque antes de retroceder
              Navigator.of(context).pop(); // Navegar hacia atrás
            },
          ),
          title: Text(
            'Eventos Registrados',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.normal,
              color: Colors.deepPurple,
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            onRefresh: _refreshPeticiones,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _model.procesado?.length ?? 0,
                            itemBuilder: (context, index) {
                              final cardData = _model.procesado![index];
                              return Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF4F4F4),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8, 0, 0, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  cardData.nombre ?? '',
                                                  style: TextStyle(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 0),
                                                  child: AutoSizeText(
                                                    cardData.descripcion ?? '',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color(0xFF606A85),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 0),
                                                  child: AutoSizeText(
                                                    cardData.fecha ?? '',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color(0xFF606A85),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 0),
                                                  child: AutoSizeText(
                                                    cardData.codigo ?? '',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color(0xFF606A85),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        // Lógica para generar el QR
                                                        _generarQR(
                                                          cardData.codigo ?? '',
                                                          cardData.nombre ?? '',
                                                        );
                                                      },
                                                      child: Text(
                                                        'Generar QR',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .purple, // Cambia a tu color femenino preferido
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .white, // Color de fondo del botón
                                                        elevation:
                                                            5, // Elevación del botón
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15), // Bordes redondeados
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        // Navegar a la pantalla de fotos (FotosWidget)
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    FotosWidget(
                                                              eventoId: cardData
                                                                      .idgaleria ??
                                                                  0,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        'Ver Fotos',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .white, // Cambia a tu color femenino preferido
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .purple, // Color de fondo del botón
                                                        elevation:
                                                            5, // Elevación del botón
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15), // Bordes redondeados
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 118, 20, 154),
                          ),
                          if (_model.procesado == null)
                            Text(
                              'Al parecer no has creado ningún evento',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                color: Color(0xFF606A85),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCrearEventoModal(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFFED5470),
        ),
      ),
    );
  }
}

void _showCrearEventoModal(BuildContext context) {
  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController fechaHoraController = TextEditingController();
  TextEditingController direccionController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Crear evento'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(nombreController, 'Nombre del Evento'),
            _buildTextField(descripcionController, 'Descripción'),
            _buildTextField(direccionController, 'Dirección'),
            _buildFechaHoraTextField(
                context, fechaHoraController, 'Fecha y Hora'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            int? idUsuario =
                Provider.of<UserSession>(context, listen: false).id;

            // Puedes realizar la lógica de guardar el evento aquí
            await crearEvento(
                nombre: nombreController.text,
                descripcion: descripcionController.text,
                direccion: direccionController.text,
                fecha: fechaHoraController.text,
                idUsuario: idUsuario);
            // Cierra el modal
            Navigator.of(context).pop();
          },
          child: Text('Guardar'),
        ),
        TextButton(
          onPressed: () {
            // Cierra el modal sin realizar ninguna acción
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
      ],
    ),
  );
}

Widget _buildFechaHoraTextField(
    BuildContext context, TextEditingController controller, String labelText) {
  return Padding(
    padding: EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 5),
        );

        if (pickedDate != null) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (pickedTime != null) {
            DateTime selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );

            // Formatear la fecha y hora en el formato deseado
            String formattedDate =
                DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);

            // Actualizar el controlador con la fecha y hora formateadas
            controller.text = formattedDate;
          }
        }
      },
    ),
  );
}

Widget _buildTextField(TextEditingController controller, String labelText) {
  return Padding(
    padding: EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    ),
  );
}

Future<void> crearEvento({
  required String? nombre,
  required String? descripcion,
  required String? direccion,
  required String? fecha,
  required int? idUsuario,
}) async {
  // Construir el objeto para el cuerpo de la solicitud
  Map<String, dynamic> requestBody = {
    "nombre": nombre,
    "descripcion": descripcion,
    "direccion": direccion,
    "fecha": fecha,
    "idusuario": idUsuario,
  };

  // Configurar y realizar la solicitud HTTP
  final response = await dio.post('/evento', data: requestBody);

  // Verificar el código de respuesta
  if (response.statusCode == 201) {
    // El evento se creó exitosamente
    print('Evento creado con éxito');
  } else {
    // Hubo un error al crear el evento
    print(
        'Error al crear el evento. Código de respuesta: ${response.statusCode}');
    print('Mensaje de error: ${response.data}');
  }
}
