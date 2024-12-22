import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'services/api_service.dart'; // Pastikan file ini sudah sesuai dengan penggunaan http

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isFlashOn = false;
  List<Map<String, String>> _data = []; // Sesuaikan dengan struktur data yang Anda perlukan
  String? lastScannedData;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendakota', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xffca0c64),
        actions: [
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
            onPressed: () {
              if (controller != null) {
                controller!.toggleFlash();
                setState(() {
                  isFlashOn = !isFlashOn;
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Color(0xffca0c64),
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  result != null
                      ? 'Data: ${result!.code}'
                      : 'Pindai kode QR',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_data[index]['Nama'] ?? ''),
                  subtitle: Text(_data[index]['Status'] ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isProcessing = false;

// Contoh fungsi untuk mengirim data setelah memindai QR code
  Future<void> scanQRCode(String scannedData) async {
    // Mengonversi string JSON menjadi Map
    Map<String, dynamic> ticketData = jsonDecode(scannedData);

    // Memformat data agar sesuai dengan kolom di database
    final formattedData = {
      "Nama": ticketData["Nama"],
      "No_KTP": ticketData["Nomor KTP"], // Ubah sesuai dengan nama kolom di database
      "Status": ticketData["Status"],
    };

    // Kirim data ke server
    final response = await http.post(
      Uri.parse('http://192.168.14.245:1337/api/scan-ticket'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(formattedData),
    );

    if (response.statusCode == 200) {
      print('Data berhasil dikirim');
    } else {
      print('Gagal mengirim data: ${response.body}');
    }
  }


  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (!_isProcessing && result!.code != lastScannedData) {
          _isProcessing = true;
          lastScannedData = result!.code;
          _processScannedData(result!.code.toString());
        }
      });
    });
  }

  void _processScannedData(String scannedData) {
    try {
      Map<String, dynamic> decodedData = jsonDecode(scannedData);
      _processJsonData(decodedData);
    } catch (e) {
      print('Error decoding JSON: $e');
    }
  }

  void _processJsonData(Map<String, dynamic> jsonData) {
    try {
      String nama = jsonData['Nama'];
      String nomorKTP = jsonData['Nomor KTP'];
      String status = jsonData['Status'];

      // Kirim data ke backend
      _sendDataToBackend(nama, nomorKTP, status); // Menggunakan fungsi ini

      // Cek dan tambahkan data ke list jika belum ada
      if (!_data.any((element) => element['Nama'] == nama && element['Nomor KTP'] == nomorKTP && element['Status'] == status)) {
        _data.add({'Nama': nama, 'Nomor KTP': nomorKTP, 'Status': status});
      }
    } catch (e) {
      print('Error processing JSON data: $e');
    } finally {
      // Reset flag pemrosesan
      _isProcessing = false;
    }
  }



  void _sendDataToBackend(String nama, String nomorKTP, String status) async {
    try {
      final url = Uri.parse('http://192.168.1.72:1337/api/scan-ticket');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'Nama': nama,
          'No_KTP': nomorKTP,
          'Status': status,
        }),
      );

      if (response.statusCode == 200) {
        print('Data berhasil dikirim ke backend');
        _showSuccessMessage('Data berhasil dikirim ke server dan diterima');
      } else {
        print('Gagal mengirim data ke backend');
        _showErrorMessage('Gagal mengirim data ke backend');
      }
    } catch (e) {
      print('Error sending data to backend: $e');
      _showErrorMessage('Error sending data to backend: $e');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
