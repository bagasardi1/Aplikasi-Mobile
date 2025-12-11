import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:warung_se_appmob/Dashboard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    routes: {
      '/dashboard': (context) => Dashboard(),
    },
  ),
);

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  bool loading = false;

  Future<void> login() async {
    if (emailC.text.isEmpty || passC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email dan Password harus diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    const String url = "http://127.0.0.1:8000/api/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email_user": emailC.text,
          "password": passC.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);

        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Login gagal"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tidak bisa terhubung ke server"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView( 
        children: [

          // HEADER IMAGE
          FadeInUp(
            duration: Duration(milliseconds: 2000),
            child: Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Restaurant.png'),
                  fit: BoxFit.contain,
                  alignment: Alignment(0, -1),
                ),
              ),

              child: Stack(
                children: [
                  Positioned(
                    left: 60,
                    top: 190,
                    child: FadeInUp(
                      duration: Duration(milliseconds: 1600),
                      child: Container(
                        width: 300,
                        height: 200,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            // LOGO
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/Logo.png'),
                                  fit: BoxFit.contain,
                                  alignment: Alignment(0, -0.5),
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Selamat Datang di Warung SE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FORM LOGIN
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [

                FadeInUp(
                  duration: Duration(milliseconds: 1800),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color.fromRGBO(234, 39, 39, 1)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ],
                    ),

                    child: Column(
                      children: [
                        // EMAIL
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color.fromRGBO(174, 27, 19, 1)),
                            ),
                          ),
                          child: TextField(
                            controller: emailC,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ),

                        // PASSWORD
                        Container(
                          padding: EdgeInsets.all(8),
                          child: TextField(
                            controller: passC,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),

                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: GestureDetector(
                    onTap: loading ? null : login,              
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(209, 16, 3, 1),
                            Color.fromRGBO(210, 55, 55, 0.6),
                          ],
                        ),
                      ),
                      child: Center(
                        child: loading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 70),

                FadeInUp(
                  duration: Duration(milliseconds: 2000),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color.fromRGBO(168, 36, 0, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
