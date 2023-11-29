import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ta_prak_mobile_final/data_makeup.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DetailProductPage extends StatefulWidget {
  final int productId;

  DetailProductPage({required this.productId});

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  // Future untuk mendapatkan detail produk dari API
  late Future<ClassCosmetic> futureProduct;

  // Variabel untuk menyimpan status produk favorit
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Menginisialisasi futureProduct saat widget pertama kali dibuat
    futureProduct = fetchProduct(widget.productId);
  }

  // Fungsi untuk mengambil detail produk dari API
  Future<ClassCosmetic> fetchProduct(int productId) async {
    final response = await http.get(
        Uri.parse('https://makeup-api.herokuapp.com/api/v1/products/$productId.json'));

    if (response.statusCode == 200) {
      // Decode data JSON menjadi objek ClassCosmetic
      Map<String, dynamic> jsonData = json.decode(response.body);
      return ClassCosmetic.fromJson(jsonData);
    } else {
      throw Exception('Failed to load product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: FutureBuilder<ClassCosmetic>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Menampilkan indikator loading jika data belum selesai diambil
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Menampilkan pesan error jika terjadi kesalahan
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            // Mendapatkan objek ClassCosmetic dari hasil future
            ClassCosmetic product = snapshot.data!;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan gambar produk di bagian atas halaman
                  Center(
                    child: Image.network(
                      product.imageLink!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Informasi produk seperti brand, nama, dan harga
                  Text(
                    'Brand: ${product.brand}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Name: ${product.name}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Price: ${product.price}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  // Deskripsi produk
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    product.description!,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  // Daftar warna produk
                  const Text(
                    'Colors:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  buildColorList(product.productColors),
                  SizedBox(height: 16.0),
                  // Tombol untuk membuka tautan produk
                  ElevatedButton(
                    onPressed: () {
                      if (product.productLink != null) {
                        launchUrl(product.productLink!);
                      } else {
                        showSnackbar(context, 'Product link not found');
                      }
                    },
                    child: Text('Open Product Link'),
                    style: ElevatedButton.styleFrom(
                      // Gaya tombol
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk membangun daftar warna produk
  Widget buildColorList(List<ProductColors>? colors) {
    if (colors != null && colors.isNotEmpty) {
      // Menggunakan widget Wrap untuk menempatkan warna dalam baris dan kolom
      return Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: colors.map((color) {
          // Menggunakan widget Container untuk menampilkan warna
          return Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: HexColor(color.hexValue!),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
          );
        }).toList(),
      );
    } else {
      // Menampilkan teks jika daftar warna kosong
      return Text('No colors available');
    }
  }
}

// Kelas untuk mengubah string hex warna menjadi objek Color
class HexColor extends Color {
  // Konstruktor untuk HexColor, menerima string hexColor
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  // Fungsi untuk mendapatkan nilai warna dari string hex
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor; // Menambahkan opasitas jika string hex tidak menyertakan opasitas
    }
    return int.parse(hexColor, radix: 16); // Mengonversi string hex ke nilai warna
  }
}

// Fungsi untuk membuka tautan URL
void launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// Fungsi untuk menampilkan Snackbar
void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ),
  );
}
