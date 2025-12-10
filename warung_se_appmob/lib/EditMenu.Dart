import 'package:flutter/material.dart';
import 'package:warung_se_appmob/Dashboard.dart';
import 'package:warung_se_appmob/main.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({super.key});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  String _selectedKategori = 'Ayam';
  String? _uploadedImage;

  final List<String> _kategoriOptions = [
    'Ayam',
    'Daging',
    'Ikan',
    'Sayuran',
    'Minuman',
    'Dessert',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      // ======================
      // 💠 SIDE MENU / DRAWER
      // ======================
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Beranda"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Tambah Menu"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit Menu"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()),
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
          children: [
            Image.asset(
              'assets/images/Pelopor.png',
              height: 40,
            ),
            const SizedBox(height: 20),
            const Text(
              'Edit Menu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              'Ubah menu sesuai keinginan Anda',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => Transform.translate(
              offset: const Offset(0, -35),
              child: IconButton(
                icon: Icon(Icons.menu, color: Colors.black, size: 28),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      // ======================
      // 💠 BODY FORM
      // ======================
      body: Container(
        width: double.infinity, 
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 370, 
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(top: 10, bottom: 30),

              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 236, 236),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
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
                  
                  buildLabel("Nama"),
                  buildTextField(_namaController, "Cth : Ayam Goreng"),
                  SizedBox(height: 20),

                  buildLabel("Deskripsi"),
                  TextField(
                    controller: _deskripsiController,
                    maxLines: 3,
                    decoration: buildInputDecoration("Cth : Deskripsi"),
                  ),
                  SizedBox(height: 20),

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
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),

                  buildLabel("Harga"),
                  buildTextField(_hargaController, "Rp. 12.000",
                      inputType: TextInputType.number),
                  SizedBox(height: 20),

                  buildLabel("Stock"),
                  buildTextField(_stockController, "15",
                      inputType: TextInputType.number),
                  SizedBox(height: 20),

                  buildLabel("Foto Makanan"),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _uploadedImage = 'assets/images/sample_food.jpg';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(255, 209, 207, 207)!),
                        borderRadius: BorderRadius.circular(19),
                        color: Colors.grey[50],
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.upload_file, color: Colors.grey, size: 32),
                          SizedBox(height: 8),
                          Text(
                            _uploadedImage == null
                                ? 'Unggah gambar baru'
                                : 'Gambar diunggah',
                            style: TextStyle(
                              color: _uploadedImage == null
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_uploadedImage == null)
                            Text(
                              'PNG, JPG, GIF hingga 10MB',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // BUTTON SIMPAN
                  ElevatedButton(
                    onPressed: saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    child: Text('Simpan', style: TextStyle(fontSize: 16)),
                  ),

                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      _confirmDelete(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    child: Text("Hapus Menu", style: TextStyle(fontSize: 16)),
                  ),
                  
                  SizedBox(height: 12),

                  // BUTTON BATAL
                  OutlinedButton(
                    onPressed: resetForm,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    child: Text('Batal', style: TextStyle(fontSize: 16)),
                  ),
                  

                  // 🚨 BUTTON HAPUS (BARU DITAMBAHKAN)
                  

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================
  // 🔧 Helper Components
  // ============================

  Widget buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    );
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

  void saveForm() {
    if (_namaController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _hargaController.text.isEmpty ||
        _stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field wajib diisi!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Menu berhasil disimpan!')),
    );

    resetForm();
  }

  void resetForm() {
    _namaController.clear();
    _deskripsiController.clear();
    _hargaController.clear();
    _stockController.clear();
    setState(() {
      _uploadedImage = null;
    });
  }

  // ============================
  // 🔥 KONFIRMASI HAPUS
  // ============================
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hapus Menu"),
        content: Text("Apakah Anda yakin ingin menghapus menu ini?"),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white,),
            child: Text("Hapus"),
            onPressed: () {
              Navigator.pop(context);
              _deleteMenu();
            },
          ),
        ],
      ),
    );
  }

  // ============================
  // 🔥 FUNGSI HAPUS MENU
  // ============================
  void _deleteMenu() {
    // TODO: nanti isi API hapus di sini (Laravel)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Menu berhasil dihapus")),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }
}
