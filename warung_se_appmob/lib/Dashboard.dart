import 'package:flutter/material.dart';
import 'package:warung_se_appmob/TambahMenu.dart';
import 'package:warung_se_appmob/main.dart';
import 'package:warung_se_appmob/EditMenu.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      // BAGIAN SIDEBAR
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Beranda"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Tambah Menu"),
              onTap: () {
    Navigator.of(context).pop(); // tutup drawer
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => TambahMenu()), 
    );
  },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit Menu"),
              onTap: () {
                Navigator.of(context).pop(); // tutup drawer
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => EditMenu()), 
    );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
    Navigator.of(context).pop(); // tutup drawer
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()), 
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
            Image.asset(
              'assets/images/Pelopor.png',
              height: 40,
            ),
            const SizedBox(height: 20),
            const Text(
              'Menu Saya',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              'Lihat menu yang anda miliki',
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
                  Scaffold.of(context).openEndDrawer(); // Drawer dari kanan
                },
              ),
            ),
          ),
          const SizedBox(width: 10), 
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Daftar Menu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (_, __) => Divider(color: const Color.fromARGB(255, 251, 251, 251)),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(item['image']),
                      radius: 25,
                    ),
                    title: Text(
                      item['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Text(
                      item['price'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
          ),
          ),
        ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> menuItems = [
  {
    'name': 'Ayam Geprek Sambal Matah',
    'price': 'Rp. 10.000',
    'image': 'assets/ayam_geprek_1.jpg',
  },
  {
    'name': 'Ayam Geprek Lada Hitam',
    'price': 'Rp. 10.000',
    'image': 'assets/ayam_geprek_2.jpg',
  },
  {
    'name': 'Ayam Geprek Keju',
    'price': 'Rp. 10.000',
    'image': 'assets/ayam_geprek_3.jpg',
  },
];
