import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ta_prak_mobile_final/Model/account_model.dart';
import 'package:ta_prak_mobile_final/login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Controller untuk input username
  final _usernameController = TextEditingController();

  // Controller untuk input password
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menambahkan gambar dari assets
            Image.asset(
              'assets/picture.png',
              height: 150,
            ),
            SizedBox(height: 20),
            // Menyusun form field ke tengah dan mengatur lebar
            Container(
              width: 400,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ),
            SizedBox(height: 20),
            // Menyesuaikan lebar tombol dengan form field
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () {
                  _registerAccount();
                },
                child: Text('Register'),
              ),
            ),
            SizedBox(height: 10),
            // Menambahkan pertanyaan "Sudah memiliki akun?"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sudah memiliki akun?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) {
                      return LoginPage();
                    }));
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk melakukan registrasi akun
  void _registerAccount() async {
    try {
      // Dapatkan referensi ke Hive Box
      final box = await Hive.openBox<AccountModel>('accounts');

      // Buat objek AccountModel baru
      final newAccount = AccountModel(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      // Simpan objek AccountModel ke dalam Hive Box
      await box.add(newAccount);

      // Tutup Hive Box
      await box.close();

      // Tampilkan Snackbar jika registrasi berhasil
      _showSnackbar("Registrasi berhasil!");

      // Navigasi kembali ke halaman sebelumnya atau lakukan tindakan lainnya
      Navigator.pop(context);
    } catch (e) {
      // Tangani pengecualian jika registrasi gagal
      _showSnackbar("Registrasi gagal. $e");
    }
  }

  // Fungsi untuk menampilkan Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
