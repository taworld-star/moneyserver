import 'dart:io';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneyserver/data/repository/category_repository.dart';
import 'package:moneyserver/data/repository/transaction_repository.dart';
import 'package:moneyserver/data/service/httpservice.dart';
import 'package:moneyserver/data/usecase/request/add_transaction_request.dart';
import 'package:moneyserver/data/usecase/response/GetCategoryResponse.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  final categoryRepo = CategoryRepository(HttpService());
  final transactionRepo = TransactionRepository(HttpService());

  GetCategoryResponse? categoryResponse;

  int? selectedCategoryId;
  File? _selectedImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      log('Starting to load categories...');
      
      // Add timeout 10 detik
      final response = await categoryRepo.getAllCategories().timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Timeout loading categories'),
      );
      
      log('Response status: ${response.status}');
      log('Response message: ${response.message}');
      log('Categories count: ${response.data.length}');
      
      if (response.status == 'success' && response.data.isNotEmpty) {
        setState(() {
          categoryResponse = response;
        });
        log('Categories loaded successfully: ${response.data.map((c) => c.name).toList()}');
      } else if (response.status == 'success' && response.data.isEmpty) {
        log('No categories found');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Belum ada kategori di server')),
          );
        }
      } else {
        log('Failed to load categories: ${response.message}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memuat kategori:\n${response.message}'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } on TimeoutException catch (e) {
      log('Timeout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Timeout: Server tidak merespons\nPastikan server berjalan di 192.168.1.17:8000'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e, stackTrace) {
      log('Error loading categories: $e');
      log('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        log('No image selected.');
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountCtrl.text) ?? 0.0;
      final formattedDate = _selectedDate.toIso8601String().split('T').first;
      try {
        final response = await transactionRepo.createTransaction(
          request: AddTransactionRequest(
            categoryId: selectedCategoryId!,
            amount: amount,
            transactionDate: formattedDate,
            note: _descCtrl.text.trim(),
            image: _selectedImage,
          ),
        );

        if (mounted) {
          if (response.status == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response.message)),
            );
            Navigator.of(context).pop(true); // Return to previous page
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response.message)),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (categoryResponse == null)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  items: (categoryResponse?.data ?? [])
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat.id,
                          child: Text(cat.name),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedCategoryId = v;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  validator: (v) => v == null ? 'Pilih kategori' : null,
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Masukkan deskripsi'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(labelText: 'Nominal'),
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Masukkan nominal';
                  final n = double.tryParse(v);
                  if (n == null) return 'Masukkan angka yang valid';
                  if (n <= 0) return 'Nominal harus lebih besar dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tanggal: ${_selectedDate.toLocal().toString().split('T').first}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Pilih Tanggal'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: Text(
                  _selectedImage == null
                      ? 'Pilih Gambar (Opsional)'
                      : 'Gambar Terpilih',
                ),
              ),
              if (_selectedImage != null) ...
                [
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
