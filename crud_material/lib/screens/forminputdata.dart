import 'package:crud_material/screens/lihatdata.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'formadddata.dart';

class TambahDataScreen extends StatelessWidget {
  final corref = FirebaseFirestore.instance.collection('Material');

  Future<void> _addData(String kodeMtl, String namaMtl, String jenisMtl,
      String stokMtl, String hargaMtl, BuildContext context) async {
    if (kodeMtl.isNotEmpty &&
        namaMtl.isNotEmpty &&
        jenisMtl.isNotEmpty &&
        stokMtl.isNotEmpty &&
        hargaMtl.isNotEmpty) {
      try {
        // Tambah ke Firebase
        DocumentReference docRef = await corref.add({
          'kode_material': kodeMtl,
          'nama_material': namaMtl,
          'jenis_material': jenisMtl,
          'stok': stokMtl,
          'harga': hargaMtl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Tambah ke MySQL
        final response = await http.post(
          Uri.parse('http://192.168.1.5/add_material.php'),
          body: {
            'kode_material': kodeMtl,
            'nama_material': namaMtl,
            'jenis_material': jenisMtl,
            'stok': stokMtl,
            'harga': hargaMtl,
          },
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result['success']) {
            print('Data berhasil ditambahkan ke Firebase dan MySQL');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Data berhasil ditambahkan')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Lihatdata()),
            );
          } else {
            print('Kesalahan menambahkan ke MySQL: ${result['error']}');
            await docRef.delete();
            throw Exception('Gagal menambahkan data ke MySQL');
          }
        } else {
          print('Kesalahan HTTP: ${response.statusCode}');
          await docRef.delete();
          throw Exception(
              'Gagal menambahkan data: HTTP ${response.statusCode}');
        }
      } catch (e) {
        print('Terjadi pengecualian: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan data: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 255, 246),
      body: FormInputScreen(
        onSave: (kodeMtl, namaMtl, jenisMtl, stokMtl, hargaMtl) {
          _addData(kodeMtl, namaMtl, jenisMtl, stokMtl, hargaMtl, context);
        },
      ),
    );
  }
}
