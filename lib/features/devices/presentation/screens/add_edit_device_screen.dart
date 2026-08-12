import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/models/device.dart';
import '../../domain/models/device_category.dart';
import '../providers/device_providers.dart';

/// Screen supporting both creation of a new device and editing an existing device.
class AddEditDeviceScreen extends ConsumerStatefulWidget {
  final String? deviceId;

  const AddEditDeviceScreen({super.key, this.deviceId});

  @override
  ConsumerState<AddEditDeviceScreen> createState() =>
      _AddEditDeviceScreenState();
}

class _AddEditDeviceScreenState extends ConsumerState<AddEditDeviceScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _serialController;
  late TextEditingController _priceController;
  late TextEditingController _notesController;

  DeviceCategory _selectedCategory = DeviceCategory.smartphone;
  DateTime? _purchaseDate;
  DateTime? _warrantyExpiryDate;
  String? _imagePath;

  bool _isEditing = false;
  Device? _originalDevice;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _brandController = TextEditingController();
    _modelController = TextEditingController();
    _serialController = TextEditingController();
    _priceController = TextEditingController();
    _notesController = TextEditingController();

    if (widget.deviceId != null) {
      _isEditing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadDeviceData();
      });
    }
  }

  void _loadDeviceData() {
    final devicesAsync = ref.read(devicesNotifierProvider);
    final list = devicesAsync.value ?? [];
    final match = list.firstWhere(
      (d) => d.id == widget.deviceId,
      orElse: () => throw Exception('Device not found'),
    );

    _originalDevice = match;
    setState(() {
      _nameController.text = match.name;
      _selectedCategory = match.category;
      _brandController.text = match.brand ?? '';
      _modelController.text = match.model ?? '';
      _serialController.text = match.serialNumber ?? '';
      _priceController.text = match.purchasePrice != null
          ? match.purchasePrice.toString()
          : '';
      _notesController.text = match.notes ?? '';
      _purchaseDate = match.purchaseDate;
      _warrantyExpiryDate = match.warrantyExpiryDate;
      _imagePath = match.imagePath;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _serialController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${const Uuid().v4()}.jpg';
      final savedImage = await File(
        pickedFile.path,
      ).copy('${appDir.path}/$fileName');

      setState(() {
        _imagePath = savedImage.path;
      });
    }
  }

  Future<void> _selectPurchaseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _purchaseDate = picked;
      });
    }
  }

  Future<void> _selectWarrantyExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _warrantyExpiryDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _warrantyExpiryDate = picked;
      });
    }
  }

  Future<void> _saveDevice() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final double? price = _priceController.text.trim().isNotEmpty
        ? double.tryParse(_priceController.text.trim())
        : null;

    final now = DateTime.now();

    if (_isEditing && _originalDevice != null) {
      final updatedDevice = _originalDevice!.copyWith(
        name: _nameController.text.trim(),
        category: _selectedCategory,
        brand: _brandController.text.trim().isEmpty
            ? null
            : _brandController.text.trim(),
        model: _modelController.text.trim().isEmpty
            ? null
            : _modelController.text.trim(),
        serialNumber: _serialController.text.trim().isEmpty
            ? null
            : _serialController.text.trim(),
        purchaseDate: _purchaseDate,
        purchasePrice: price,
        warrantyExpiryDate: _warrantyExpiryDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        imagePath: _imagePath,
        updatedAt: now,
      );

      await ref
          .read(devicesNotifierProvider.notifier)
          .updateDevice(updatedDevice);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated "${updatedDevice.name}" successfully'),
          ),
        );
        context.pop();
      }
    } else {
      final newDevice = Device(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        brand: _brandController.text.trim().isEmpty
            ? null
            : _brandController.text.trim(),
        model: _modelController.text.trim().isEmpty
            ? null
            : _modelController.text.trim(),
        serialNumber: _serialController.text.trim().isEmpty
            ? null
            : _serialController.text.trim(),
        purchaseDate: _purchaseDate,
        purchasePrice: price,
        warrantyExpiryDate: _warrantyExpiryDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        imagePath: _imagePath,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(devicesNotifierProvider.notifier).addDevice(newDevice);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "${newDevice.name}" to your TechVault'),
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Device' : 'Add New Device'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Device Image Picker Header
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceDark
                                : AppColors.cardBorderLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.cardBorderDark
                                  : AppColors.cardBorderLight,
                              width: 2,
                            ),
                          ),
                          child:
                              _imagePath != null &&
                                  File(_imagePath!).existsSync()
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    File(_imagePath!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 32,
                                      color: AppColors.accent,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Add Photo',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: AppColors.accent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    if (_imagePath != null) ...[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _imagePath = null;
                          });
                        },
                        child: const Text('Remove Photo'),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Device Name Field (Required)
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Device Name *',
                        hintText: 'e.g. MacBook Pro M3, Personal iPhone',
                        prefixIcon: Icon(Icons.devices_rounded),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a device name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown (Required)
                    DropdownButtonFormField<DeviceCategory>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                        prefixIcon: Icon(Icons.category_rounded),
                        border: OutlineInputBorder(),
                      ),
                      items: DeviceCategory.values.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Row(
                            children: [
                              Icon(cat.icon, size: 18),
                              const SizedBox(width: 10),
                              Text(cat.displayName),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (cat) {
                        if (cat != null) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Brand & Model Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _brandController,
                            decoration: const InputDecoration(
                              labelText: 'Brand',
                              hintText: 'e.g. Apple, Sony',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _modelController,
                            decoration: const InputDecoration(
                              labelText: 'Model',
                              hintText: 'e.g. A2992, WH-1000XM5',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Serial Number
                    TextFormField(
                      controller: _serialController,
                      decoration: const InputDecoration(
                        labelText: 'Serial Number',
                        hintText: 'e.g. C02D12345678',
                        prefixIcon: Icon(Icons.qr_code_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Purchase Date Picker
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.cardBorderDark
                              : AppColors.cardBorderLight,
                        ),
                      ),
                      leading: const Icon(Icons.calendar_today_rounded),
                      title: const Text('Purchase Date'),
                      subtitle: Text(Formatters.date(_purchaseDate)),
                      trailing: _purchaseDate != null
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                setState(() {
                                  _purchaseDate = null;
                                });
                              },
                            )
                          : const Icon(Icons.arrow_drop_down_rounded),
                      onTap: _selectPurchaseDate,
                    ),
                    const SizedBox(height: 16),

                    // Purchase Price Field
                    TextFormField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Purchase Price',
                        hintText: 'e.g. 1499.00',
                        prefixIcon: Icon(Icons.attach_money_rounded),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          if (double.tryParse(value.trim()) == null) {
                            return 'Please enter a valid numeric price';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Warranty Expiry Date Picker
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.cardBorderDark
                              : AppColors.cardBorderLight,
                        ),
                      ),
                      leading: const Icon(Icons.verified_user_rounded),
                      title: const Text('Warranty Expiry Date'),
                      subtitle: Text(Formatters.date(_warrantyExpiryDate)),
                      trailing: _warrantyExpiryDate != null
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                setState(() {
                                  _warrantyExpiryDate = null;
                                });
                              },
                            )
                          : const Icon(Icons.arrow_drop_down_rounded),
                      onTap: _selectWarrantyExpiryDate,
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        hintText:
                            'Condition, accessories included, storage location...',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: PrimaryButton(
                            label: _isEditing ? 'Save Changes' : 'Save Device',
                            onPressed: _isLoading ? null : _saveDevice,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
