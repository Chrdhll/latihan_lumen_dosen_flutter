import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahDataDosen extends StatefulWidget {
  const TambahDataDosen({super.key});

  @override
  State<TambahDataDosen> createState() => _TambahDataDosenState();
}

class _TambahDataDosenState extends State<TambahDataDosen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  bool _isLoading = false;

  Future<void> _simpanData() async {
    setState(() => _isLoading = true);
    final url = Uri.parse('http://192.168.162.74:8000/api/dosen');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },

        body: {
          "nip": _nipController.text,
          "nama_lengkap": _namaLengkapController.text,
          "no_telepon": _nomorTeleponController.text,
          "email": _emailController.text,
          "alamat": _alamatController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Data berhasil disimpan")));
        Navigator.pop(context, true); // kembali ke halaman sebelumnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan: ${response.statusCode} ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) return '$label tidak boleh kosong';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Data Dosen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                'Nama Lengkap',
                _namaLengkapController,
                TextInputType.name,
              ),
              const SizedBox(height: 16),
              _buildTextField('NIP', _nipController, TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(
                'Nomor Telepon',
                _nomorTeleponController,
                TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Email',
                _emailController,
                TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField('Alamat', _alamatController, TextInputType.text),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  )
                  : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade900,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Simpan Data',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _simpanData();
                      }
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
