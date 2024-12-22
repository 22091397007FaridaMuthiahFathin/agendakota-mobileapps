import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class QRGeneratorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRGeneratorViewState();
}

class _QRGeneratorViewState extends State<QRGeneratorView> {
  final _formKey = GlobalKey<FormState>();
  String _nama = '';
  String _nomorKTP = '';
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
        backgroundColor: Color(0xffca0c64),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => _nama = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nomor KTP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nomor KTP tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => _nomorKTP = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Status tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => _status = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _generateQRCode();
                  }
                },
                child: Text('Generate QR Code'),
              ),
              SizedBox(height: 20),
              _qrCode != null
                  ? QrImageView(
                data: _qrCode ?? '',
                version: QrVersions.auto,
                size: 200.0,
                gapless: false,
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  String? _qrCode;

  void _generateQRCode() {
    Map<String, dynamic> data = {
      'Nama': _nama,
      'Nomor KTP': _nomorKTP,
      'Status': _status,
    };

    String jsonData = jsonEncode(data);
    setState(() {
      _qrCode = jsonData;
    });
  }
}