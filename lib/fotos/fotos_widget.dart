import 'package:image_picker/image_picker.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'fotos_model.dart';
export 'fotos_model.dart';

class FotosWidget extends StatefulWidget {
  const FotosWidget({Key? key, required this.eventoId}) : super(key: key);
  final int eventoId;

  @override
  _FotosWidgetState createState() => _FotosWidgetState();
}

class _FotosWidgetState extends State<FotosWidget> {
  late FotosModel _model;
  late File _selectedImage;
  @override
  void initState() {
    super.initState();
    _model = Provider.of<FotosModel>(context, listen: false);
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotos del Evento'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCamera(),
        tooltip: 'Buscar fotos similares',
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<FotosModel>(
      builder: (context, model, child) {
        if (model.procesado == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (model.procesado!.isEmpty) {
          return Center(
            child: Text('No hay fotos disponibles'),
          );
        }

        return ListView.builder(
          itemCount: model.procesado!.length,
          itemBuilder: (context, index) {
            final foto = model.procesado![index];
            return _buildFotoCard(foto);
          },
        );
      },
    );
  }

  Widget _buildFotoCard(FotosModel foto) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            if (foto.usuariomostrar == true)
              Image.network(
                foto.urlwm ?? '',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            if (foto.usuariomostrar == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Fotógrafo: ${foto.correo ?? ''}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      // Lógica para enviar la imagen al backend y realizar la búsqueda de fotos similares
      await _model.buscarFotosSimilares(_selectedImage);

      // Actualizar la interfaz de usuario con los resultados de la búsqueda
      setState(() {
        // Puedes hacer algo con los resultados si es necesario
      });
    }
  }

  void _initModel() {
    _model.eventoId = widget.eventoId;
    _model.fetchApiSolicitud();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initModel(); // Llama a _initModel en cada cambio de dependencias
  }
}
