
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warung_se_appmob/TambahMenu.dart';
import 'package:warung_se_appmob/Dashboard.dart';
import 'package:warung_se_appmob/main.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';


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

  String _selectedStatus = 'tersedia';

  final List<String> _statusOptions = [
    'tersedia',
    'tidak tersedia',
  ];

  @override
  void initState() {
    super.initState();

    // ambil data dari dashboard buat isi form
    _namaController =
        TextEditingController(text: widget.menuData['menu']);
    _deskripsiController =
        TextEditingController(text: widget.menuData['deskripsi'] ?? '');
    _hargaController =
        TextEditingController(text: widget.menuData['harga'].toString());
    _stokController =
        TextEditingController(text: widget.menuData['stok'].toString());

    _selectedKategori = widget.menuData['kategori'] ?? 'makanan';
    _selectedStatus = widget.menuData['status'] ?? 'tersedia';

  }
  Uint8List? _webImage;// buat simpan gambar kalo di flutter web

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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

      // SIDEBAR
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

      
      // APP BAR
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

      
      // BODY 
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

                buildLabel("Status"),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: _statusOptions
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              status,
                              style: TextStyle(
                                color: status == 'tersedia'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                      onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                    decoration: buildInputDecoration(),
                  ),


                buildLabel("Gambar Menu"),
                const SizedBox(height: 8),

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
                          (kIsWeb ? _webImage == null : _selectedImage == null)
                              ? 'Unggah gambar baru'
                              : 'Gambar diunggah',
                            style: TextStyle(
                            color: (kIsWeb ? _webImage == null : _selectedImage == null)
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        if (_selectedImage == null)
                          const Text(
                            'PNG, JPG hingga 10MB',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ),

                

                const SizedBox(height: 16),

                // BUTTON SIMPAN
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

                // BUTTON HAPUS
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


  // HELPER UI biar tidak berulang
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



  // UPDATE MENU
  Future<void> pickImage() async {
  final pickedFile = await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (pickedFile != null) {
    if (kIsWeb) {
      _webImage = await pickedFile.readAsBytes();
    } else {
      _selectedImage = File(pickedFile.path);
    }
    setState(() {});
  }
}
  Future<void> saveForm() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  final id = widget.menuData['id_menu'];

  var request = http.MultipartRequest(
    'POST',
    Uri.parse("http://127.0.0.1:8000/api/menu/$id"),
  );

  request.headers.addAll({
    "Authorization": "Bearer $token",
    "Accept": "application/json",
  });

  request.fields['_method'] = 'POST';
  request.fields['menu'] = _namaController.text;
  request.fields['deskripsi'] = _deskripsiController.text;
  request.fields['kategori'] = _selectedKategori;
  request.fields['harga'] = _hargaController.text;
  request.fields['stok'] = _stokController.text;
  request.fields['status'] = _selectedStatus;



  
  // UPLOAD GAMBAR
  if (kIsWeb && _webImage != null) {
  request.files.add(
    http.MultipartFile.fromBytes(
      'gambar_menu',
      _webImage!,
      filename: 'menu_${DateTime.now().millisecondsSinceEpoch}.png',
    ),
  );
} else if (!kIsWeb && _selectedImage != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'gambar_menu',
      _selectedImage!.path,
    ),
  );
}

  final response = await request.send();

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Menu berhasil diperbarui")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Dashboard()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gagal update menu")),
    );
  }
}



  
  //DELETE MENU
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white,),
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
