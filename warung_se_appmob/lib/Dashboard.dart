import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warung_se_appmob/TambahMenu.dart';
import 'package:warung_se_appmob/main.dart';
import 'package:warung_se_appmob/edit_menu.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? token;
  List<dynamic> menuItems = [];

  @override
  void initState() {
    super.initState();
    loadTokenAndGetMenu();
    
  }

  // pengambilan token dan request menu
  Future<void> loadTokenAndGetMenu() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    fetchMenu();
  }

  // ambil menu daru BE
  Future<void> fetchMenu() async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/menu"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          menuItems = json.decode(response.body);
        });
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      // SIDEBAR
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
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => TambahMenu()),
                );
              },
            ),
            
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                Navigator.of(context).pop();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('access_token');

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),

      // APPBAR 
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
            SizedBox(height: 20),
            Text(
              'Menu Saya',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
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
              offset: Offset(0, -35),
              child: IconButton(
                icon: Icon(Icons.menu, color: Colors.black, size: 28),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),


      // BODY 
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Daftar Menu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Jika menu belum ada (loading)
            Expanded(
              child: menuItems.isEmpty
                  ? Center(child: CircularProgressIndicator()) // masih loading
                  : ListView.separated( //sudah tampil menu
                      itemCount: menuItems.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.grey.shade200),

                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                          
                        return ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: item['gambar_menu'] != null
                                  ? NetworkImage(
                                      "http://127.0.0.1:8000/api/menu-image/${item['gambar_menu']}",
                                    )
                                  : AssetImage('') as ImageProvider,
                            ),

                            title: Text(
                              item['menu'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['kategori']),
                                const SizedBox(height: 4),
                                Text(
                                  "Rp ${item['harga']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue), //ambil material
                              onPressed: () {
                                //arahin ke halaman edit menu
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditMenu(
                                      menuData: item,
                                    ),
                                  ),
                                );
                              },
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
