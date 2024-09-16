import 'package:crud_material/screens/lihatdata.dart';
import 'package:flutter/material.dart';

class FormInputScreen extends StatelessWidget {
  final String? docId;
  final String? oldKodeMtl;
  final String? kodeMtl;
  final String? namaMtl;
  final String? jenisMtl;
  final String? stokMtl;
  final String? hargaMtl;
  final Function(String, String, String, String, String) onSave;

  FormInputScreen({
    this.docId,
    this.oldKodeMtl,
    this.kodeMtl,
    this.namaMtl,
    this.jenisMtl,
    this.stokMtl,
    this.hargaMtl,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final kodeMtlController = TextEditingController(text: kodeMtl);
    final namaMtlController = TextEditingController(text: namaMtl);
    final jenisMtlController = TextEditingController(text: jenisMtl);
    final stokMtlController = TextEditingController(text: stokMtl);
    final hargaMtlController = TextEditingController(text: hargaMtl);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 255, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 210, 252),
        title: Text(
          docId == null ? 'Tambah Data Barang' : 'Edit Data Barang',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Color.fromARGB(255, 125, 233, 255),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: kodeMtlController,
                  decoration: InputDecoration(
                    labelText: 'Kode Material',
                  ),
                ),
              ),
            ),
            Card(
              color: Color.fromARGB(255, 125, 233, 255),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: namaMtlController,
                  decoration: InputDecoration(labelText: 'Nama Material'),
                ),
              ),
            ),
            Card(
              color: Color.fromARGB(255, 125, 233, 255),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: jenisMtlController,
                  decoration: InputDecoration(labelText: 'Jenis Material'),
                ),
              ),
            ),
            Card(
              color: Color.fromARGB(255, 125, 233, 255),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: stokMtlController,
                  decoration: InputDecoration(labelText: 'Stok'),
                ),
              ),
            ),
            Card(
              color: Color.fromARGB(255, 125, 233, 255),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: hargaMtlController,
                  decoration: InputDecoration(labelText: 'Harga'),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onSave(
                    kodeMtlController.text,
                    namaMtlController.text,
                    jenisMtlController.text,
                    stokMtlController.text,
                    hargaMtlController.text);
                Navigator.of(context).pop();
              },
              child: Text(
                'Simpan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
