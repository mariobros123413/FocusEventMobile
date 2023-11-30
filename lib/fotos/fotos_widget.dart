import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'fotos_model.dart';

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
        title: Text(
          'Fotos del Evento',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink, // Color femenino
        elevation: 0, // Sin sombra en la barra de navegación
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCamera(),
        tooltip: 'Buscar fotos similares',
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.pink, // Color femenino
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<FotosModel>(
      builder: (context, model, child) {
        if (model.procesado == null) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            ),
          );
        }

        if (model.procesado!.isEmpty) {
          return Center(
            child: Text(
              'No hay fotos disponibles',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
            ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
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
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink, // Color femenino
                  ),
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

      await _model.buscarFotosSimilares(_selectedImage);

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
    _initModel();
  }
}
