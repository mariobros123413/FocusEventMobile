import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../fotos/fotos_widget.dart';
import '../user_session.dart';
import 'asistencias_model.dart';

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
    _model.fetchApiSolicitud();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registro de Asistencias',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink, // Color femenino
        elevation: 0, // Sin sombra en la barra de navegación
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
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                    ),
                  ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScannerScreen(),
                ),
              );
            },
            child: Text(
              'Escanear Código QR',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.pink, // Color femenino
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAsistenciaCard(AsistenciasModel asistencia) {
    return GestureDetector(
      onTap: () {
        int eventoId = asistencia.idgaleria ?? 4;
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: Text(
            asistencia.nombre ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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

class _QRScannerScreenState extends State<QRScannerScreen> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late AsistenciasModel _model;
  String codigoEscaneado = '';

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
                      _model.registrarAsistencia(codigoEscaneado);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Aceptar',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink, // Color femenino
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
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
      setState(() {
        codigoEscaneado = scanData.code!;
      });
      print("Código escaneado: $codigoEscaneado");

      _model.registrarAsistencia(codigoEscaneado);
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
