import 'device_category.dart';
import 'warranty_status.dart';

/// Domain model representing a physical technology asset in TechVault.
class Device {
  final String id;
  final String name;
  final DeviceCategory category;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final DateTime? warrantyExpiryDate;
  final String? notes;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  Device({
    required this.id,
    required this.name,
    required this.category,
    this.brand,
    this.model,
    this.serialNumber,
    this.purchaseDate,
    this.purchasePrice,
    this.warrantyExpiryDate,
    this.notes,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Dynamically computes warranty status.
  WarrantyStatus get warrantyStatus =>
      WarrantyStatus.calculate(warrantyExpiryDate);

  /// Returns remaining warranty days if applicable, or negative if expired.
  int? get remainingWarrantyDays {
    if (warrantyExpiryDate == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(
      warrantyExpiryDate!.year,
      warrantyExpiryDate!.month,
      warrantyExpiryDate!.day,
    );
    return expiry.difference(today).inDays;
  }

  Device copyWith({
    String? id,
    String? name,
    DeviceCategory? category,
    String? brand,
    String? model,
    String? serialNumber,
    DateTime? purchaseDate,
    double? purchasePrice,
    DateTime? warrantyExpiryDate,
    String? notes,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      warrantyExpiryDate: warrantyExpiryDate ?? this.warrantyExpiryDate,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'brand': brand,
      'model': model,
      'serialNumber': serialNumber,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'purchasePrice': purchasePrice,
      'warrantyExpiryDate': warrantyExpiryDate?.toIso8601String(),
      'notes': notes,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      name: json['name'] as String,
      category: DeviceCategory.fromName(json['category'] as String),
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      serialNumber: json['serialNumber'] as String?,
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.parse(json['purchaseDate'] as String)
          : null,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      warrantyExpiryDate: json['warrantyExpiryDate'] != null
          ? DateTime.parse(json['warrantyExpiryDate'] as String)
          : null,
      notes: json['notes'] as String?,
      imagePath: json['imagePath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
