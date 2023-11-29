import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ta_prak_mobile_final/Model/cosmetic_model.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products'),
      ),
      body: FutureBuilder<List<CosmeticModel>>(
        future: getFavoriteProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Menampilkan indikator loading jika data belum selesai diambil
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Menampilkan pesan error jika terjadi kesalahan
            return Text('Error: ${snapshot.error}');
          } else {
            // Mendapatkan daftar produk favorit
            List<CosmeticModel> favoriteProducts = snapshot.data ?? [];

            if (favoriteProducts.isEmpty) {
              // Menampilkan pesan jika tidak ada produk favorit
              return Center(
                child: Text('No favorite products.'),
              );
            }

            // Menampilkan daftar produk favorit dalam ListView
            return ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                CosmeticModel favoriteProduct = favoriteProducts[index];

                // Menampilkan item produk favorit dengan fitur dismissible
                return Dismissible(
                  key: Key(index.toString()),
                  onDismissed: (direction) async {
                    // Hapus data dari kotak Hive saat item di-dismiss
                    var box = await Hive.openBox<CosmeticModel>('cosmeticBox');
                    await box.deleteAt(index);

                    // Hapus item dari list dan perbarui UI
                    setState(() {
                      favoriteProducts.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: AlignmentDirectional.centerEnd,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    title: Text(favoriteProduct.name ?? ''),
                    subtitle: Text(favoriteProduct.brand ?? ''),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk mendapatkan daftar produk favorit dari kotak Hive
  Future<List<CosmeticModel>> getFavoriteProducts() async {
    // Buka kotak Hive yang sesuai dengan model data
    var box = await Hive.openBox<CosmeticModel>('cosmeticBox');

    // Ambil semua data dari database
    List<CosmeticModel> favoriteProducts = box.values.toList();

    return favoriteProducts;
  }
}
