import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/plant_model.dart';

/// Repository for plant CRUD operations
/// P1: Plant Repository ✅
class PlantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get all plants from catalog
  Future<List<PlantModel>> getAllPlants() async {
    try {
      final snapshot = await _firestore
          .collection('plants')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PlantModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Failed to fetch plants: ${e.toString()}';
    }
  }

  /// Get plants by category
  Future<List<PlantModel>> getPlantsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('plants')
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => PlantModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Failed to fetch plants by category: ${e.toString()}';
    }
  }

  /// Search plants by name
  Future<List<PlantModel>> searchPlants(String query) async {
    try {
      final snapshot = await _firestore
          .collection('plants')
          .where('isActive', isEqualTo: true)
          .get();

      final plants = snapshot.docs
          .map((doc) => PlantModel.fromFirestore(doc))
          .where((plant) =>
              plant.name.toLowerCase().contains(query.toLowerCase()) ||
              plant.scientificName.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return plants;
    } catch (e) {
      throw 'Failed to search plants: ${e.toString()}';
    }
  }

  /// Get plant by ID
  Future<PlantModel> getPlantById(String plantId) async {
    try {
      final doc = await _firestore.collection('plants').doc(plantId).get();

      if (!doc.exists) {
        throw 'Plant not found';
      }

      // Increment view count
      await doc.reference.update({
        'viewCount': FieldValue.increment(1),
      });

      return PlantModel.fromFirestore(doc);
    } catch (e) {
      throw 'Failed to fetch plant: ${e.toString()}';
    }
  }

  /// Add new plant (nursery only)
  Future<PlantModel> addPlant(PlantModel plant) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw 'User not authenticated';

      final docRef = await _firestore.collection('plants').add(plant.toFirestore());
      
      final doc = await docRef.get();
      return PlantModel.fromFirestore(doc);
    } catch (e) {
      throw 'Failed to add plant: ${e.toString()}';
    }
  }

  /// Update existing plant
  Future<void> updatePlant(String plantId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('plants').doc(plantId).update(updates);
    } catch (e) {
      throw 'Failed to update plant: ${e.toString()}';
    }
  }

  /// Delete plant
  Future<void> deletePlant(String plantId) async {
    try {
      // Soft delete - just mark as inactive
      await _firestore.collection('plants').doc(plantId).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to delete plant: ${e.toString()}';
    }
  }

  /// Get user's plants (My Plants)
  Future<List<PlantModel>> getUserPlants() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw 'User not authenticated';

      // Get user's plant IDs
      final userPlantsSnapshot = await _firestore
          .collection('user_plants')
          .where('userId', isEqualTo: userId)
          .get();

      if (userPlantsSnapshot.docs.isEmpty) {
        return [];
      }

      final plantIds = userPlantsSnapshot.docs
          .map((doc) => doc.data()['plantId'] as String)
          .toList();

      // Get plant details
      final plants = <PlantModel>[];
      for (final plantId in plantIds) {
        try {
          final plant = await getPlantById(plantId);
          plants.add(plant);
        } catch (e) {
          // Skip plants that no longer exist
          continue;
        }
      }

      return plants;
    } catch (e) {
      throw 'Failed to fetch user plants: ${e.toString()}';
    }
  }

  /// Add plant to user's collection
  Future<void> addPlantToUserCollection(String plantId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw 'User not authenticated';

      // Check if already added
      final existing = await _firestore
          .collection('user_plants')
          .where('userId', isEqualTo: userId)
          .where('plantId', isEqualTo: plantId)
          .get();

      if (existing.docs.isNotEmpty) {
        throw 'Plant already in your collection';
      }

      // Add to user's collection
      await _firestore.collection('user_plants').add({
        'userId': userId,
        'plantId': plantId,
        'addedAt': FieldValue.serverTimestamp(),
        'healthStatus': 'healthy',
      });
    } catch (e) {
      throw 'Failed to add plant to collection: ${e.toString()}';
    }
  }

  /// Remove plant from user's collection
  Future<void> removePlantFromUserCollection(String plantId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw 'User not authenticated';

      final snapshot = await _firestore
          .collection('user_plants')
          .where('userId', isEqualTo: userId)
          .where('plantId', isEqualTo: plantId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw 'Failed to remove plant: ${e.toString()}';
    }
  }

  /// Update plant health status
  Future<void> updatePlantHealth(String plantId, String healthStatus) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw 'User not authenticated';

      final snapshot = await _firestore
          .collection('user_plants')
          .where('userId', isEqualTo: userId)
          .where('plantId', isEqualTo: plantId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.update({
          'healthStatus': healthStatus,
          'lastHealthUpdate': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw 'Failed to update plant health: ${e.toString()}';
    }
  }

  /// Get plants by nursery
  Future<List<PlantModel>> getPlantsByNursery(String nurseryId) async {
    try {
      final snapshot = await _firestore
          .collection('plants')
          .where('nurseryId', isEqualTo: nurseryId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PlantModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Failed to fetch nursery plants: ${e.toString()}';
    }
  }

  /// Get plant by QR code
  Future<PlantModel?> getPlantByQRCode(String qrCode) async {
    try {
      final snapshot = await _firestore
          .collection('plants')
          .where('qrCode', isEqualTo: qrCode)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return PlantModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      throw 'Failed to fetch plant by QR code: ${e.toString()}';
    }
  }
}