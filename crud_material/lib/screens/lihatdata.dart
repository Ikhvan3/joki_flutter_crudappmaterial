import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'formadddata.dart';

class Lihatdata extends StatefulWidget {
  @override
  State<Lihatdata> createState() => _LihatdataState();
}

class _LihatdataState extends State<Lihatdata> {
  final corref = FirebaseFirestore.instance.collection('Material');
  late List<Map<String, dynamic>> listdata = [];

  _tampildata() async {
    // Kosongkan listdata terlebih dahulu
    listdata = [];

    // Ambil data dari Firebase
    final firebaseData = await corref.get();
    List<Map<String, dynamic>> firebaseList = firebaseData.docs.map((doc) {
      var docData = doc.data() as Map<String, dynamic>;
      docData['id'] = doc.id;
      docData['source'] = 'firebase';
      return docData;
    }).toList();

    // Ambil data dari MySQL
    List<Map<String, dynamic>> mysqlList = await _tampilDataMySQL();

    // Gabungkan data dari kedua sumber
    listdata.addAll(firebaseList);
    listdata.addAll(mysqlList);

    // Hapus duplikat berdasarkan kode_barang, prioritaskan data dari Firebase
    final Map<String, Map<String, dynamic>> uniqueMap = {};
    for (var item in listdata) {
      String key = item['kode_material'];
      if (!uniqueMap.containsKey(key) || item['source'] == 'firebase') {
        uniqueMap[key] = item;
      }
    }
    listdata = uniqueMap.values.toList();

    setState(() {});
  }

  Future<List<Map<String, dynamic>>> _tampilDataMySQL() async {
    List<Map<String, dynamic>> mysqlList = [];
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.5/get_material.php'));

      if (response.statusCode == 200) {
        // Tambahkan logging untuk melihat respons dari server
        print("Raw response from MySQL: ${response.body}");

        // Decode respons JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Periksa apakah operasi berhasil
        if (responseData['success'] == true) {
          // Ambil data dari kunci 'data'
          List<dynamic> data = responseData['data'];
          print("Data dari MySQL: $data");

          mysqlList = data
              .where((item) =>
                  item['kode_material'] != null &&
                  item['kode_material'] != '0' &&
                  item['nama_material'] != null &&
                  item['nama_material'] != '0' &&
                  item['jenis_material'] != null &&
                  item['jenis_material'] != '0' &&
                  item['stok'] != null &&
                  item['stok'] != '0' &&
                  item['harga'] != null &&
                  item['harga'] != '0')
              .map((item) => {
                    'id': item['id'].toString(),
                    'kode_material': item['kode_material'],
                    'nama_material': item['nama_material'],
                    'jenis_material': item['jenis_material'],
                    'stok': item['stok'],
                    'harga': item['harga'],
                    'source': 'mysql'
                  })
              .toList();
        } else {
          print('Gagal mengambil data dari MySQL: ${responseData['error']}');
        }
      } else {
        print('Gagal mengambil data dari MySQL: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error dalam _tampilDataMySQL: $e');
    }
    return mysqlList;
  }

  @override
  void initState() {
    super.initState();
    _tampildata();
  }

  void _deleteData(String docId, String kodeMaterial) async {
    try {
      // Hapus dari Firebase
      await corref.doc(docId).delete();
      _tampildata();

      // Hapus dari MySQL
      final response = await http.post(
        Uri.parse('http://192.168.1.5/delete_material.php'),
        body: {'kode_material': kodeMaterial},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('Data berhasil dihapus dari Firebase dan MySQL');
        } else {
          print('Kesalahan menghapus dari MySQL: ${result['error']}');
        }
      } else {
        print(
            'Kesalahan HTTP saat menghapus dari MySQL: ${response.statusCode}');
      }

      await _tampildata(); // Gunakan await di sini
    } catch (e) {
      print('Terjadi pengecualian saat menghapus data: $e');
    }
  }

  void _addData(String kodeMtl, String namaMtl, String jenisMtl, String stokMtl,
      String hargaMtl) async {
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
            _tampildata();
          } else {
            print('Kesalahan menambahkan ke MySQL: ${result['error']}');
            await docRef.delete();
          }
        } else {
          print('Kesalahan HTTP: ${response.statusCode}');
          await docRef.delete();
        }
      } catch (e) {
        print('Terjadi pengecualian: $e');
      }
    } else {
      print('Kode barag dan nama barang tidak boleh kosong');
    }
  }

  void _editData(String docId, String oldKodeMtl, String newKodeMtl,
      String namaMtl, String jenisMtl, String stokMtl, String hargaMtl) async {
    if (newKodeMtl.isNotEmpty &&
        namaMtl.isNotEmpty &&
        jenisMtl.isNotEmpty &&
        stokMtl.isNotEmpty &&
        hargaMtl.isNotEmpty) {
      try {
        // Perbarui data di Firebase
        await corref.doc(docId).update({
          'kode_material': newKodeMtl,
          'nama_material': namaMtl,
          'jenis_material': jenisMtl,
          'stok': stokMtl,
          'harga': hargaMtl,
        });

        // Perbarui data di MySQL
        final response = await http.post(
          Uri.parse('http://192.168.1.5/edit_material.php'),
          body: {
            'old_kode_material': oldKodeMtl,
            'new_kode_material': newKodeMtl,
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
            print('Data berhasil diubah di Firebase dan MySQL');
            await _tampildata();
          } else {
            print('Kesalahan mengubah data di MySQL: ${result['error']}');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Gagal mengubah data: ${result['error']}')),
            );
          }
        } else {
          print(
              'Kesalahan HTTP saat mengubah data di MySQL: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal mengubah data. Status: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Terjadi pengecualian saat mengubah data: $e');
      }
    } else {
      print('Kode barang dan nama barang tidak boleh kosong');
    }
  }

  Future<void> _navigateToForm({
    String? docId,
    String? oldKodeMtl,
    String? kodeMtl,
    String? namaMtl,
    String? jenisMtl,
    String? stokMtl,
    String? hargaMtl,
  }) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FormInputScreen(
        docId: docId,
        oldKodeMtl: oldKodeMtl,
        kodeMtl: kodeMtl,
        namaMtl: namaMtl,
        jenisMtl: jenisMtl,
        stokMtl: stokMtl,
        hargaMtl: hargaMtl,
        onSave: (
          newKodemtl,
          newNamaMtl,
          newJenisMtl,
          newStokMtl,
          newHargaMtl,
        ) async {
          if (docId == null) {
            _addData(
                newKodemtl, newNamaMtl, newJenisMtl, newStokMtl, newHargaMtl);
          } else {
            _editData(docId, oldKodeMtl!, newKodemtl, newNamaMtl, newJenisMtl,
                newStokMtl, newHargaMtl);
          }
          await _tampildata(); // Refresh data setelah edit
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 255, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 210, 252),
        title: Text(
          'LIHAT DATA MATERIAL',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: ListView.builder(
        itemCount: listdata.length,
        itemBuilder: (context, index) {
          final data = listdata[index];
          return Card(
            color: Color.fromARGB(255, 125, 233, 255),
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['kode_material'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\Nama Material : ${data['nama_material']}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\Jenis Material : ${data['jenis_material']}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\Stok : ${data['stok']}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\Harga : ${data['harga']}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _navigateToForm(
                      docId: data['id'],
                      oldKodeMtl: data['kode_material'],
                      kodeMtl: data['kode_material'],
                      namaMtl: data['nama_material'],
                      jenisMtl: data['jenis_material'],
                      stokMtl: data['stok'],
                      hargaMtl: data['harga'],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _deleteData(data['id'], data['kode_material']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
