import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../bloc/restaurant_bloc.dart';
import '../bloc/restaurant_event.dart';
import '../bloc/restaurant_state.dart';

class AddRestaurantPage extends StatefulWidget {
  const AddRestaurantPage({super.key});

  @override
  State<AddRestaurantPage> createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cuisineController = TextEditingController(text: 'Việt Nam');
  final _ratingController = TextEditingController(text: '0');
  final _totalReviewsController = TextEditingController(text: '0');

  File? _imageFile;
  final _picker = ImagePicker();
  String? _imageUrl;
  final _imageUrlTextController = TextEditingController();

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Image.file(_imageFile!, height: 120);
    }
    final typedUrl = _imageUrlTextController.text.trim();
    if (typedUrl.isNotEmpty) {
      return Image.network(
        typedUrl,
        height: 120,
        errorBuilder: (context, error, stackTrace) => const SizedBox(height: 120),
      );
    }
    if (_imageUrl != null) {
      return Image.network(_imageUrl!, height: 120);
    }
    return const SizedBox(height: 120);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _cuisineController.dispose();
    _ratingController.dispose();
    _totalReviewsController.dispose();
    _imageUrlTextController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    setState(() {});
    final url = await CloudinaryService.uploadImage(_imageFile!);
    setState(() {
      _imageUrl = url;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final rating = double.tryParse(_ratingController.text) ?? 0.0;
    final totalReviews = int.tryParse(_totalReviewsController.text) ?? 0;

    final manualUrl = _imageUrlTextController.text.trim();
    final imageUrl = (manualUrl.isNotEmpty ? manualUrl : (_imageUrl ?? ''));

    context.read<RestaurantBloc>().add(
      AddRestaurantEvent(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        imageUrl: imageUrl,
        cuisine: _cuisineController.text.trim(),
        rating: rating,
        totalReviews: totalReviews,
        description: _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm nhà hàng')),
      body: BlocConsumer<RestaurantBloc, RestaurantState>(
        listener: (context, state) {
          if (state is RestaurantAdded) {
            Navigator.pop(context, true);
          } else if (state is RestaurantError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is RestaurantLoading;
          return AbsorbPointer(
            absorbing: isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên nhà hàng',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Nhập tên nhà hàng' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Địa chỉ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Nhập địa chỉ' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cuisineController,
                      decoration: const InputDecoration(
                        labelText: 'Cuisine (chuyên mục)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ratingController,
                            decoration: const InputDecoration(
                              labelText: 'Rating',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _totalReviewsController,
                            decoration: const InputDecoration(
                              labelText: 'Tổng đánh giá',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _imageUrlTextController,
                      decoration: const InputDecoration(
                        labelText: 'Link ảnh (tùy chọn)',
                        hintText: 'https://...',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      onChanged: (v) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildImagePreview(),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: _pickImage,
                              child: const Text('Chọn ảnh'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _uploadImage,
                              child: const Text('Tải ảnh lên'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submit,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Lưu'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
