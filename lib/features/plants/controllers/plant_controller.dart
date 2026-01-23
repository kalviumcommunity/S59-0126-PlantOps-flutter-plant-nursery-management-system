import 'package:flutter/material.dart';
import '../repositories/plant_repository.dart';
import '../../../models/plant_model.dart';

/// State management for plants
/// P20: Plant Controller ✅
class PlantController extends ChangeNotifier {
  final PlantRepository _plantRepository = PlantRepository();

  List<PlantModel> _plants = [];
  List<PlantModel> _userPlants = [];
  List<PlantModel> _filteredPlants = [];
  PlantModel? _selectedPlant;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<PlantModel> get plants => _filteredPlants.isEmpty && _searchQuery.isEmpty
      ? _plants
      : _filteredPlants;
  List<PlantModel> get userPlants => _userPlants;
  PlantModel? get selectedPlant => _selectedPlant;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all plants
  Future<void> loadPlants() async {
    _setLoading(true);
    _clearError();

    try {
      _plants = await _plantRepository.getAllPlants();
      _applyFilters();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Load user's plants
  Future<void> loadUserPlants() async {
    _setLoading(true);
    _clearError();

    try {
      _userPlants = await _plantRepository.getUserPlants();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Load plant by ID
  Future<bool> loadPlantById(String plantId) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedPlant = await _plantRepository.getPlantById(plantId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Search plants
  Future<void> searchPlants(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredPlants = [];
      notifyListeners();
      return;
    }

    _setLoading(true);

    try {
      _filteredPlants = await _plantRepository.searchPlants(query);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    if (_selectedCategory == 'All') {
      _filteredPlants = _plants;
    } else {
      _filteredPlants = _plants
          .where((plant) => plant.category == _selectedCategory)
          .toList();
    }
    notifyListeners();
  }

  /// Add plant
  Future<bool> addPlant(PlantModel plant) async {
    _setLoading(true);
    _clearError();

    try {
      await _plantRepository.addPlant(plant);
      await loadPlants(); // Reload list
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Update plant
  Future<bool> updatePlant(String plantId, Map<String, dynamic> updates) async {
    _setLoading(true);
    _clearError();

    try {
      await _plantRepository.updatePlant(plantId, updates);
      await loadPlants();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Delete plant
  Future<bool> deletePlant(String plantId) async {
    _setLoading(true);
    _clearError();

    try {
      await _plantRepository.deletePlant(plantId);
      await loadPlants();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Add plant to user collection
  Future<bool> addToMyPlants(String plantId) async {
    _clearError();

    try {
      await _plantRepository.addPlantToUserCollection(plantId);
      await loadUserPlants();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Remove from my plants
  Future<bool> removeFromMyPlants(String plantId) async {
    _clearError();

    try {
      await _plantRepository.removePlantFromUserCollection(plantId);
      await loadUserPlants();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Update plant health
  Future<bool> updatePlantHealth(String plantId, String healthStatus) async {
    _clearError();

    try {
      await _plantRepository.updatePlantHealth(plantId, healthStatus);
      await loadUserPlants();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Get plant by QR code
  Future<PlantModel?> getPlantByQRCode(String qrCode) async {
    _setLoading(true);
    _clearError();

    try {
      final plant = await _plantRepository.getPlantByQRCode(qrCode);
      _setLoading(false);
      return plant;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredPlants = [];
    notifyListeners();
  }
}