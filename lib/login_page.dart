import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_prak_mobile_final/Model/account_model.dart';
import 'package:ta_prak_mobile_final/list_product.dart';
import 'package:ta_prak_mobile_final/ragistration.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk input username
  final _usernameController = TextEditingController();

  // Controller untuk input password
  final _passwordController = TextEditingController();

  // Objek SharedPreferences untuk menyimpan data lokal
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    // Inisialisasi SharedPreferences saat widget pertama kali dibuat
    _initSharedPreferences();
  }

  // Fungsi untuk inisialisasi SharedPreferences
  Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/picture.png',
              height: 150,
            ),
            SizedBox(height: 20),
            // Input field untuk username
            Container(
              width: 400,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ),
            SizedBox(height: 20),
            // Input field untuk password
            Container(
              width: 400,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ),
            SizedBox(height: 20),
            // Tombol untuk melakukan login
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () {
                  _login();
                },
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 10),
            // Text dan tombol untuk pindah ke halaman registrasi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Belum memiliki akun?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) {
                      return RegistrationPage();
                    }));
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk melakukan login
  void _login() async {
    // Dapatkan referensi ke Hive Box
    final box = await Hive.openBox<AccountModel>('accounts');

    // Inisialisasi existingAccount dengan null
    AccountModel? existingAccount;

    try {
      // Ambil AccountModel dari database berdasarkan username yang dimasukkan
      existingAccount = box.values.firstWhere(
            (account) => account.username == _usernameController.text,
      );

      // Periksa apakah password yang dimasukkan cocok dengan password di database
      if (existingAccount != null &&
          existingAccount.password == _passwordController.text) {
        // Login berhasil
        // Simpan username ke SharedPreferences
        await _preferences.setString("username", existingAccount.username ?? "");

        // Pindah ke halaman produk setelah login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductGrid()),
        );

        // Tampilkan Snackbar jika login berhasil
        _showSnackbar("Login berhasil!");
        print('Login berhasil!');
      } else {
        // Login gagal
        // Tampilkan Snackbar jika login gagal
        _showSnackbar("Login gagal. Periksa username dan password Anda.");
      }
    } catch (e) {
      // Tangani pengecualian (mis., akun tidak ditemukan)
      // Tampilkan Snackbar jika terjadi kesalahan
      _showSnackbar("Pengguna tidak ditemukan");
    } finally {
      // Tutup Hive Box
      await box.close();
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
