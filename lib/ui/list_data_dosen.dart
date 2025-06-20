import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:latihan_lumen_dosen_flutter/models/model_data_dosen.dart';
import 'package:latihan_lumen_dosen_flutter/ui/tambah_data_dosen.dart';
import 'package:latihan_lumen_dosen_flutter/ui/edit_data_dosen.dart';

class ListDataDosen extends StatefulWidget {
  const ListDataDosen({super.key});

  @override
  State<ListDataDosen> createState() => _ListDataDosenState();
}

class _ListDataDosenState extends State<ListDataDosen> {
  late Future<List<ModelDosen>> futureUser;

  Future<List<ModelDosen>> getDataUser() async {
    final response = await http.get(
      Uri.parse('http://192.168.162.74:8000/api/dosen'),
      headers: {'x-api-key': 'reqres-free-v1'},
    );

    if (response.statusCode == 200) {
      return modelDosenFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _hapusData(int no) async {
    final response = await http.delete(
      Uri.parse('http://192.168.162.74:8000/api/dosen/$no'),
      headers: {'x-api-key': 'reqres-free-v1'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data berhasil dihapus')));
      setState(() {
        futureUser = getDataUser();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal hapus data: ${response.statusCode}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    futureUser = getDataUser();
  }

  void _refreshData() {
    setState(() {
      futureUser = getDataUser();
    });
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
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data dosen'));
          }

          final dataUser = snapshot.data!;
          return ListView.builder(
            itemCount: dataUser.length,
            itemBuilder: (context, index) {
              final data = dataUser[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: GestureDetector(
                  onLongPress: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text('Hapus Data'),
                            content: const Text(
                              'Yakin ingin menghapus data ini?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Hapus',style: TextStyle(color: Colors.deepOrange),),
                              ),
                            ],
                          ),
                    );
                    if (confirm == true) {
                      _hapusData(data.no);
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
                        child: Text(
                          data.namaLengkap[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
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
                          Text('NIP: ${data.nip}'),
                          Text('Email: ${data.email}'),
                          Text('No HP: ${data.noTelepon}'),
                          Text('Alamat: ${data.alamat}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditDataDosen(data: data),
                            ),
                          );
                          _refreshData();
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahDataDosen()),
          );
          _refreshData();
        },
        backgroundColor: Colors.orange.shade900,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
