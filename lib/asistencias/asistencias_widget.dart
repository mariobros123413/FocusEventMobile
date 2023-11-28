import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../fotos/fotos_widget.dart';
import '../user_session.dart';
import 'asistencias_model.dart'; // Asegúrate de importar tu modelo de asistencias

class AsistenciasWidget extends StatefulWidget {
  const AsistenciasWidget({Key? key}) : super(key: key);

  @override
  _AsistenciasWidgetState createState() => _AsistenciasWidgetState();
}

class _AsistenciasWidgetState extends State<AsistenciasWidget> {
  late AsistenciasModel _model;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    UserSession userSession = Provider.of<UserSession>(context, listen: false);

    _model = Provider.of<AsistenciasModel>(context, listen: false);
    _model.idusuario = userSession.id;
    _model
        .fetchApiSolicitud(); // Puedes cargar las asistencias al inicializar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencias'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _model.procesado != null
                ? ListView.builder(
                    itemCount: _model.procesado!.length,
                    itemBuilder: (context, index) {
                      final asistencia = _model.procesado![index];
                      return _buildAsistenciaCard(asistencia);
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          ElevatedButton(
            onPressed: () {
              // Abre el lector de QR
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScannerScreen(),
                ),
              );
            },
            child: Text('Escanear QR'),
          ),
        ],
      ),
    );
  }

  Widget _buildAsistenciaCard(AsistenciasModel asistencia) {
    return GestureDetector(
      onTap: () {
        // Obtener el ID del evento o proporcionar un valor predeterminado si es nulo
        int eventoId = asistencia.idgaleria ?? 4;
        // Navegar a FotosWidget con el ID del evento como parámetro
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FotosWidget(eventoId: eventoId),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(8),
        child: ListTile(
          title: Text(asistencia.nombre ?? ''),
          subtitle: Text(
            'Fecha: ${asistencia.fecha ?? ''} - Hora Llegada: ${asistencia.horallegada ?? ''}',
          ),
        ),
      ),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScannerScreenState();
}

// ...

class _QRScannerScreenState extends State<QRScannerScreen> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late AsistenciasModel _model;
  String codigoEscaneado = ''; // Variable para almacenar el código escaneado

  @override
  void initState() {
    super.initState();
    _model = Provider.of<AsistenciasModel>(context, listen: false);
    _model.fetchApiSolicitud();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Llamar a la función para registrar la asistencia
                      _model.registrarAsistencia(codigoEscaneado);
                      // Puedes cerrar la pantalla de escaneo cuando obtienes el resultado deseado
                      Navigator.pop(context);
                    },
                    child: Text("Aceptar"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Almacenar el código escaneado
      setState(() {
        codigoEscaneado = scanData.code!;
      });
      // Puedes manejar el resultado del escaneo aquí si es necesario
      print("Código escaneado: $codigoEscaneado");

      // Llamar a la función para registrar la asistencia
      _model.registrarAsistencia(codigoEscaneado);
      // Puedes cerrar la pantalla de escaneo cuando obtienes el resultado deseado
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
