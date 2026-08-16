import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jelantah_app/core/api/donasi_api.dart';
import 'package:jelantah_app/core/services/auth_service.dart';

class DonasiFormPage extends StatefulWidget {
  final int lokasiId;
  final String lokasiNama;

  const DonasiFormPage({
    super.key,
    required this.lokasiId,
    required this.lokasiNama,
  });

  @override
  State<DonasiFormPage> createState() => _DonasiFormPageState();
}

class _DonasiFormPageState extends State<DonasiFormPage> {
  final _jumlahController = TextEditingController();
  File? _fotoBukti;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() => _fotoBukti = File(pickedFile.path));
    }
  }

  Future<void> _submitDonasi() async {
    if (_jumlahController.text.isEmpty || _fotoBukti == null) {
      setState(() => _errorMessage = 'Isi jumlah dan ambil foto bukti terlebih dahulu');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final token = await AuthService.getToken();
    if (token == null) return;

    final result = await DonasiApi.ajukanDonasi(
      token: token,
      lokasiId: widget.lokasiId,
      jumlahInput: double.parse(_jumlahController.text),
      fotoBukti: _fotoBukti!,
    );

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Donasi berhasil diajukan!')),
        );
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _errorMessage = result['errors']?.toString() ?? 'Gagal mengajukan donasi';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Donasi di ${widget.lokasiNama}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
             controller: _jumlahController,
keyboardType: const TextInputType.numberWithOptions(decimal: true),
decoration: const InputDecoration(
  labelText: 'Jumlah hasil timbangan (liter)',
  border: OutlineInputBorder(),
),
            ),
            const SizedBox(height: 16),
            if (_fotoBukti != null)
              Image.file(_fotoBukti!, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ambil Foto Bukti'),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitDonasi,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Ajukan Donasi'),
            ),
          ],
        ),
      ),
    );
  }
}