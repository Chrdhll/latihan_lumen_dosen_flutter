import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_lumen_dosen_flutter/models/model_data_dosen.dart';
import 'package:latihan_lumen_dosen_flutter/ui/tambah_data_dosen.dart';

class ListDataDosen extends StatefulWidget {
  const ListDataDosen({super.key});

  @override
  State<ListDataDosen> createState() => _ListDataDosenState();
}

class _ListDataDosenState extends State<ListDataDosen> {
  late Future<List<ModelDosen>>? futureUser;

  Future<List<ModelDosen>> getDataUser() async {
    print('getDataUser called ...');
    try {
      final response = await http.get(
        Uri.parse('http://192.168.162.74:8000/api/dosen'),
        headers: {'x-api-key': 'reqres-free-v1'},
      );

      print('Response body : ${response.body}');

      if (response.statusCode == 200) {
        return modelDosenFromJson(response.body).toList();
      } else {
        throw Exception('Failed to load data : ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    futureUser = getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.orange.shade900,
      ),
      body: FutureBuilder<List<ModelDosen>>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No Dosen Data Found'));
          } else {
            List<ModelDosen> dataUser = snapshot.data!;

            return ListView.builder(
              itemCount: dataUser.length,
              itemBuilder: (context, index) {
                final data = dataUser[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.orange.shade100,
                        child: Text(
                          data.namaLengkap[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      title: Text(
                        data.namaLengkap,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('NIP: ${data.nip}'),
                          Text('Email: ${data.email}'),
                          Text('No HP: ${data.noTelepon}'),
                          Text('Alamat: ${data.alamat}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const TambahDataDosen()));

          if (result != null && result == true) {
            setState(() {
              futureUser = getDataUser(); 
            });
          }
        },
        backgroundColor: Colors.orange.shade900,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
