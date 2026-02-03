import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/plant_model.dart';

/// QR Code display screen for plants
/// P9: QR Code Generation ✅
class QRCodeDisplayScreen extends StatelessWidget {
  final PlantModel plant;

  const QRCodeDisplayScreen({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share QR code as image
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR code sharing coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // QR Code
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: plant.qrCode ?? 'plant_${plant.id}',
                  version: QrVersions.auto,
                  size: 280,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  embeddedImage: const AssetImage('assets/icons/plant_icon.png'),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(40, 40),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Plant Info
              Text(
                plant.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                plant.scientificName,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'How to Use',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Show this QR code to customers\n'
                      '2. They scan it with the PlantOps app\n'
                      '3. Plant instantly added to their collection\n'
                      '4. Care reminders automatically created!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Print Button
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Print QR code
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Print functionality coming soon!'),
                    ),
                  );
                },
                icon: const Icon(Icons.print),
                label: const Text('Print QR Code'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}