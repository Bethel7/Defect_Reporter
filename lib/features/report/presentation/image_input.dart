import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageInput extends StatefulWidget {
  final ValueChanged<String> onImageSelected;

  const ImageInput({super.key, required this.onImageSelected});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  void _showFullImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(imageFile, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    bool granted = false;
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        granted = true;
      } else if (status.isPermanentlyDenied) {
        _showPermissionDialog('Camera');
        return;
      }
    } else {
      // For Android 13+ use photos, for older use storage
      final photosStatus = await Permission.photos.request();
      final storageStatus = await Permission.storage.request();
      if (photosStatus.isGranted || storageStatus.isGranted) {
        granted = true;
      } else if (photosStatus.isPermanentlyDenied ||
          storageStatus.isPermanentlyDenied) {
        _showPermissionDialog('Gallery');
        return;
      }
    }
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Permission denied to access ${source == ImageSource.camera ? 'camera' : 'gallery'}.',
          ),
        ),
      );
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      File originalFile = File(picked.path);
      // Determine format from extension
      String ext = originalFile.path.split('.').last.toLowerCase();
      String format = (ext == 'png') ? 'png' : 'jpg';
      File? compressed = await Helpers.compressImage(
        originalFile,
        format: format,
      );
      if (compressed != null) {
        setState(() {
          _imageFile = compressed;
        });
        widget.onImageSelected(compressed.path);
      } else {
        setState(() {
          _imageFile = originalFile;
        });
        widget.onImageSelected(originalFile.path);
      }
    }
  }

  void _showPermissionDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$type Permission Required'),
        content: Text(
          'Please enable $type permission in settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(FontAwesomeIcons.camera, color: AppColors.accent),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.images, color: AppColors.accent),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _imageFile != null
          ? () => _showFullImageDialog(_imageFile!)
          : _showImageSourceDialog,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.image,
                    size: 48,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload an image',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
