import 'package:cloud_firestore/cloud_firestore.dart';

/// Plant data model
/// Represents a plant in the catalog or a user's collection
/// Primary domain: Person 2 (Plants)
class PlantModel {
  final String id;
  final String name;
  final String scientificName;
  final String category;
  final String description;
  final String? imageUrl;
  final String nurseryId;
  final String nurseryName;
  
  // Care instructions
  final String wateringFrequency;
  final String sunlightRequirement;
  final String soilType;
  final String fertilizingSchedule;
  final String? additionalCareNotes;
  
  // Metadata
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? qrCode;
  final int viewCount;
  final bool isActive;

  PlantModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.description,
    this.imageUrl,
    required this.nurseryId,
    required this.nurseryName,
    required this.wateringFrequency,
    required this.sunlightRequirement,
    required this.soilType,
    required this.fertilizingSchedule,
    this.additionalCareNotes,
    required this.createdAt,
    this.updatedAt,
    this.qrCode,
    this.viewCount = 0,
    this.isActive = true,
  });

  /// Create PlantModel from Firestore document
  factory PlantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return PlantModel(
      id: doc.id,
      name: data['name'] ?? '',
      scientificName: data['scientificName'] ?? '',
      category: data['category'] ?? 'Other',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      nurseryId: data['nurseryId'] ?? '',
      nurseryName: data['nurseryName'] ?? '',
      wateringFrequency: data['wateringFrequency'] ?? '',
      sunlightRequirement: data['sunlightRequirement'] ?? '',
      soilType: data['soilType'] ?? '',
      fertilizingSchedule: data['fertilizingSchedule'] ?? '',
      additionalCareNotes: data['additionalCareNotes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      qrCode: data['qrCode'],
      viewCount: data['viewCount'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }

  /// Convert PlantModel to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'scientificName': scientificName,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'nurseryId': nurseryId,
      'nurseryName': nurseryName,
      'wateringFrequency': wateringFrequency,
      'sunlightRequirement': sunlightRequirement,
      'soilType': soilType,
      'fertilizingSchedule': fertilizingSchedule,
      'additionalCareNotes': additionalCareNotes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'qrCode': qrCode,
      'viewCount': viewCount,
      'isActive': isActive,
    };
  }

  /// Create a copy with updated fields
  PlantModel copyWith({
    String? name,
    String? scientificName,
    String? category,
    String? description,
    String? imageUrl,
    String? wateringFrequency,
    String? sunlightRequirement,
    String? soilType,
    String? fertilizingSchedule,
    String? additionalCareNotes,
    DateTime? updatedAt,
    String? qrCode,
    int? viewCount,
    bool? isActive,
  }) {
    return PlantModel(
      id: id,
      name: name ?? this.name,
      scientificName: scientificName ?? this.scientificName,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      nurseryId: nurseryId,
      nurseryName: nurseryName,
      wateringFrequency: wateringFrequency ?? this.wateringFrequency,
      sunlightRequirement: sunlightRequirement ?? this.sunlightRequirement,
      soilType: soilType ?? this.soilType,
      fertilizingSchedule: fertilizingSchedule ?? this.fertilizingSchedule,
      additionalCareNotes: additionalCareNotes ?? this.additionalCareNotes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      qrCode: qrCode ?? this.qrCode,
      viewCount: viewCount ?? this.viewCount,
      isActive: isActive ?? this.isActive,
    );
  }
}