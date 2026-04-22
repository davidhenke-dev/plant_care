import 'dart:io';
import 'package:flutter/cupertino.dart';

class PlantImage extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double placeholderIconSize;

  const PlantImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderIconSize = 26,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) return _placeholder();
    return Image.file(
      File(imagePath!),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          CupertinoIcons.leaf_arrow_circlepath,
          color: const Color(0xFF4CAF50),
          size: placeholderIconSize,
        ),
      ),
    );
  }
}
