import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:latihan_lumen_dosen_flutter/models/model_data_dosen.dart';

class EditDataDosen extends StatefulWidget {
  final ModelDosen data;

  const EditDataDosen({super.key, required this.data});

  @override
  State<EditDataDosen> createState() => _EditDataDosenState();
}

class _EditDataDosenState extends State<EditDataDosen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaLengkapController.text = widget.data.namaLengkap;
    _nipController.text = widget.data.nip;
    _emailController.text = widget.data.email;
    _nomorTeleponController.text = widget.data.noTelepon;
    _alamatController.text = widget.data.alamat;
  }

  Future<void> _simpanEdit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final response = await http.put(
        Uri.parse('http://192.168.162.74:8000/api/dosen/${widget.data.no}'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'reqres-free-v1',
        },
        body: jsonEncode({
          'nama_lengkap': _namaLengkapController.text,
          'nip': _nipController.text,
          'email': _emailController.text,
          'no_telepon': _nomorTeleponController.text,
          'alamat': _alamatController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui')),
        );
        Navigator.pop(context); // kembali ke halaman list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui data (${response.statusCode})'),
          ),
        );
      }
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
  void dispose() {
    _namaLengkapController.dispose();
    _nipController.dispose();
    _emailController.dispose();
    _nomorTeleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Data Dosen',
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
                      'Simpan perubahan',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _simpanEdit();
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
