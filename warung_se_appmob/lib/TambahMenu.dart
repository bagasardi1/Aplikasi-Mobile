import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:warung_se_appmob/Dashboard.dart';
import 'package:warung_se_appmob/main.dart';
import 'package:warung_se_appmob/edit_menu.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;


class TambahMenu extends StatefulWidget {
  const TambahMenu({super.key});

  @override
  State<TambahMenu> createState() => _TambahMenuState();
}

class _TambahMenuState extends State<TambahMenu> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  String _selectedKategori = 'makanan';
  String _selectedStatus = 'tersedia';   // <- TAMBAHAN
  File? _selectedImage;  // Untuk Android/iOS
  Uint8List? _webImage;         // Untuk Flutter Web

  final ImagePicker _picker = ImagePicker();

  final List<String> _kategoriOptions = ['makanan', 'minuman', 'paket'];

  final List<String> _statusOptions = ['tersedia', 'tidak tersedia']; // <- TAMBAHAN

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  // ======================
  // PICK IMAGE
  // ======================
  Future<void> pickImage() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    if (kIsWeb) {
      // Web menyimpan bytes
      _webImage = await image.readAsBytes();
    } else {
      // Mobile menyimpan file path
      _selectedImage = File(image.path);
    }
    setState(() {});
  }
  }

  // ======================
  // SAVE FORM TO API
  // ======================
  Future<void> saveForm() async {
    if (_namaController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _hargaController.text.isEmpty ||
        _stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi!')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan, silakan login ulang!')),
      );
      return;
    }

    try {
      final url = Uri.parse("http://127.0.0.1:8000/api/menu");

      var request = http.MultipartRequest("POST", url);
      request.headers["Authorization"] = "Bearer $token";
      request.headers["Accept"] = "application/json";

      request.fields["menu"] = _namaController.text;
      request.fields["deskripsi"] = _deskripsiController.text;
      request.fields["harga"] = _hargaController.text;
      request.fields["kategori"] = _selectedKategori;
      request.fields["stok"] = _stockController.text;
      request.fields["status"] = _selectedStatus; // <- TAMBAHAN

      // Mobile upload (File)
if (!kIsWeb && _selectedImage != null) {
  request.files.add(await http.MultipartFile.fromPath(
    "gambar_menu",
    _selectedImage!.path,
  ));
}

// Web upload (Bytes)
if (kIsWeb && _webImage != null) {
  request.files.add(
    http.MultipartFile.fromBytes(
      "gambar_menu",
      _webImage!,
      filename: "gambar_menu.png",
    ),
  );
}

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("STATUS: ${response.statusCode}");
      print("BODY: $responseBody");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Menu berhasil ditambahkan!')),
        );
        resetForm();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $responseBody')),
        );
      }
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi error: $e')),
      );
    }
  }

  // ======================
  // RESET FORM
  // ======================
  void resetForm() {
    _namaController.clear();
    _deskripsiController.clear();
    _hargaController.clear();
    _stockController.clear();
    setState(() {
      _selectedImage = null;
      _selectedKategori = _kategoriOptions[0];
      _selectedStatus = _statusOptions[0]; // <- TAMBAHAN
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Beranda"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Dashboard()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Tambah Menu"),
              onTap: () {},
            ),
          
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 190,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/Pelopor.png', height: 40),
            const SizedBox(height: 20),
            const Text(
              'Tambah Menu Baru',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const Text(
              'Tambahkan menu baru ke daftar menu Anda',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => Transform.translate(
              offset: const Offset(0, -35),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black, size: 28),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 370,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(top: 10, bottom: 30),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 236, 236),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabel("Nama"),
                  buildTextField(_namaController, "Cth : Ayam Goreng"),
                  const SizedBox(height: 20),
                  buildLabel("Deskripsi"),
                  TextField(
                    controller: _deskripsiController,
                    maxLines: 3,
                    decoration: buildInputDecoration("Cth : Deskripsi"),
                  ),
                  const SizedBox(height: 20),
                  buildLabel("Kategori"),
                  DropdownButtonFormField<String>(
                    value: _selectedKategori,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedKategori = newValue!;
                      });
                    },
                    decoration: buildInputDecoration("Pilih kategori"),
                    items: _kategoriOptions.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase()),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                  buildLabel("Status"), // <- TAMBAHAN
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue!;
                      });
                    },
                    decoration: buildInputDecoration("Pilih status"),
                    items: _statusOptions.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase()),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                  buildLabel("Harga"),
                  buildTextField(_hargaController, "Cth : 15000",
                      inputType: TextInputType.number),
                  const SizedBox(height: 20),
                  buildLabel("Stock"),
                  buildTextField(_stockController, "Cth : 15",
                      inputType: TextInputType.number),
                  const SizedBox(height: 20),

                  buildLabel("Foto Makanan"),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(19),
                        color: Colors.grey[50],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.upload_file,
                              color: Colors.grey, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            _selectedImage == null
                                ? 'Unggah gambar baru'
                                : 'Gambar diunggah',
                            style: TextStyle(
                              color: _selectedImage == null
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_selectedImage == null)
                            const Text(
                              'PNG, JPG, GIF hingga 10MB',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child:
                        const Text('Simpan', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Dashboard()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child:
                        const Text('Batal', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }

  Widget buildTextField(TextEditingController controller, String hint,
      {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: buildInputDecoration(hint),
    );
  }

  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
