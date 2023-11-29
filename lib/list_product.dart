import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_prak_mobile_final/Model/cosmetic_model.dart';
import 'dart:convert';
import 'package:ta_prak_mobile_final/data_makeup.dart';
import 'package:ta_prak_mobile_final/detail_product.dart';
import 'package:ta_prak_mobile_final/favorite.dart';
import 'package:ta_prak_mobile_final/login_page.dart';

class ProductGrid extends StatefulWidget {
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  // Future untuk mendapatkan data produk dari API
  late Future<List<ClassCosmetic>> futureProducts;

  // SharedPreferences untuk menyimpan username yang sudah login
  late SharedPreferences _preferences;

  // Variabel untuk menyimpan username yang sudah login
  String _storedUsername = "";

  @override
  void initState() {
    super.initState();

    // Mendapatkan data produk dari API saat inisialisasi
    futureProducts = fetchProducts();

    // Inisialisasi SharedPreferences
    _initSharedPreferences();
  }

  // Fungsi untuk inisialisasi SharedPreferences
  Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();

    // Memuat username yang sudah disimpan dari SharedPreferences
    _loadStoredUsername();
  }

  // Fungsi untuk memuat username yang sudah disimpan dari SharedPreferences
  void _loadStoredUsername() {
    setState(() {
      _storedUsername = _preferences.getString("username") ?? "";
    });
  }

  // Fungsi untuk melakukan logout
  void _logout() async {
    // Menghapus username yang tersimpan di SharedPreferences
    await _preferences.remove("username");

    // Navigasi kembali ke halaman Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Fungsi untuk mengambil data produk dari API
  Future<List<ClassCosmetic>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://makeup-api.herokuapp.com/api/v1/products.json'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      // Mapping data JSON ke dalam list objek ClassCosmetic
      return jsonResponse.map((data) => ClassCosmetic.fromJson(data)).toList();
    } else {
      throw Exception('Gagal Memuat Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MakeUp List'),
        actions: [
          // Tombol Logout
          IconButton(
            onPressed: () {
              _logout();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menampilkan username di atas GridView
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Selamat Datang, $_storedUsername !',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ClassCosmetic>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Menampilkan indikator loading jika data belum selesai diambil
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Menampilkan pesan error jika terjadi kesalahan
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Menampilkan GridView produk jika data sudah diterima
                  List<ClassCosmetic> products = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,  // Jumlah kolom dalam grid
                      crossAxisSpacing: 8.0,  // Ruang antara elemen-elemen dalam kolom
                      mainAxisSpacing: 8.0,  // Ruang antara elemen-elemen dalam baris
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // Navigasi ke halaman detail produk saat item di-tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailProductPage(productId: products[index].id!),
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Menampilkan gambar produk dari URL
                                  Image.network(
                                    products[index].imageLink!,
                                    height: 90,
                                    width: double.infinity,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Menampilkan informasi produk
                                        Text('Brand: ${products[index].brand}'),
                                        Text('Name: ${products[index].name}'),
                                        Text('Price: ${products[index].price}'),
                                        SizedBox(height: 20,),
                                        // Tombol untuk menambahkan produk ke favorit
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Ambil data produk yang terkait
                                            ClassCosmetic product = products[index];

                                            // Buka kotak Hive yang sesuai dengan model data
                                            var box = await Hive.openBox<CosmeticModel>('cosmeticBox');

                                            // Cek apakah produk sudah ada di dalam database
                                            bool isProductExist = box.values.any((element) => element.id == product.id);

                                            // Jika belum ada, simpan produk ke dalam database
                                            if (!isProductExist) {
                                              var cosmeticModel = CosmeticModel(
                                                id: product.id,
                                                brand: product.brand,
                                                name: product.name,
                                                price: product.price,
                                                priceSign: product.priceSign,
                                                imageLink: product.imageLink,
                                                productLink: product.productLink,
                                                websiteLink: product.websiteLink,
                                                description: product.description,
                                              );

                                              await box.add(cosmeticModel);

                                              // Tampilkan Snackbar bahwa produk berhasil ditambahkan ke dalam database Hive
                                              _showSnackbar('Produk ${product.name} ditambahkan ke dalam database');
                                            } else {
                                              // Jika sudah ada, tampilkan Snackbar bahwa produk sudah ada di dalam database Hive
                                              _showSnackbar('Produk ${product.name} sudah ada di dalam database');
                                            }
                                          },
                                          child: Text('Favorite'),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      // Floating Action Button untuk menuju halaman Favorit
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritePage()),
          );
        },
        child: Icon(Icons.favorite),
      ),
    );
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
