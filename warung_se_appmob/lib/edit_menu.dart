import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warung_se_appmob/TambahMenu.dart';
import 'package:warung_se_appmob/Dashboard.dart';
import 'package:warung_se_appmob/main.dart';

class EditMenu extends StatefulWidget {
  final Map<String, dynamic> menuData;

  const EditMenu({
    super.key,
    required this.menuData,
  });

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;

  String _selectedKategori = 'makanan';

  final List<String> _kategoriOptions = [
    'makanan',
    'minuman',
    'paket',
  ];

  @override
  void initState() {
    super.initState();

    // 🔥 ISI FORM DARI DATA DASHBOARD
    _namaController =
        TextEditingController(text: widget.menuData['menu']);
    _deskripsiController =
        TextEditingController(text: widget.menuData['deskripsi'] ?? '');
    _hargaController =
        TextEditingController(text: widget.menuData['harga'].toString());
    _stokController =
        TextEditingController(text: widget.menuData['stok'].toString());

    _selectedKategori = widget.menuData['kategori'] ?? 'makanan';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      // ======================
      // 💠 DRAWER
      // ======================
      endDrawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Beranda"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Dashboard()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Tambah Menu"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const TambahMenu()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>  HomePage()),
                );
              },
            ),
          ],
        ),
      ),

      // ======================
      // 💠 APP BAR
      // ======================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 190,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Image.asset(
              'assets/images/Pelopor.png',
              height: 40,
            ),

            SizedBox(height: 20),
            Text(
              'Edit Menu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Ubah menu sesuai keinginan Anda',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => Transform.translate(
              offset: const Offset(0, -35),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ),
        ],
      ),

      // ======================
      // 💠 BODY FORM
      // ======================
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 370,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFEDECEC),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel("Nama Menu"),
                buildTextField(_namaController),
                const SizedBox(height: 16),

                buildLabel("Deskripsi"),
                buildTextField(_deskripsiController, maxLines: 3),
                const SizedBox(height: 16),

                buildLabel("Kategori"),
                DropdownButtonFormField(
                  value: _selectedKategori,
                  items: _kategoriOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedKategori = v!),
                  decoration: buildInputDecoration(),
                ),
                const SizedBox(height: 16),

                buildLabel("Harga"),
                buildTextField(
                  _hargaController,
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                buildLabel("Stok"),
                buildTextField(
                  _stokController,
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                // 🔥 SIMPAN
                ElevatedButton(
                  onPressed: saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Simpan"),
                ),

                const SizedBox(height: 12),

                // 🔥 HAPUS
                ElevatedButton(
                  onPressed: _confirmDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Hapus Menu"),
                ),

                const SizedBox(height: 12),

                // 🔥 BATAL
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Dashboard()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Batal"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================
  // 🔧 HELPERS
  // ======================
  Widget buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  Widget buildTextField(
    TextEditingController c, {
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      keyboardType: inputType,
      decoration: buildInputDecoration(),
    );
  }

  InputDecoration buildInputDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(),
    );
  }

  // ======================
  // 🔥 UPDATE MENU
  // ======================
  Future<void> saveForm() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final id = widget.menuData['id_menu'];

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/menu/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "menu": _namaController.text,
        "deskripsi": _deskripsiController.text,
        "kategori": _selectedKategori,
        "harga": int.parse(_hargaController.text),
        "stok": int.parse(_stokController.text),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Menu berhasil diperbarui")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Dashboard()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal update menu")));
    }
  }

  // ======================
  // 🔥 DELETE MENU
  // ======================
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Menu"),
        content: const Text("Yakin ingin menghapus menu ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _deleteMenu,
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMenu() async {
    Navigator.pop(context);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final id = widget.menuData['id_menu'];

    final response = await http.delete(
      Uri.parse("http://127.0.0.1:8000/api/menu/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Menu berhasil dihapus")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Dashboard()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal menghapus menu")));
    }
  }
}
