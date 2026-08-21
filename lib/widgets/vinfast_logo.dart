import 'package:flutter/material.dart';

/// Widget hiển thị logo VinFast 3D kim loại chính thức từ file asset.
class VinFastLogo extends StatelessWidget {
  final double size;
  final BoxFit fit;

  const VinFastLogo({
    super.key,
    this.size = 28,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_vinfast.png',
      width: size,
      height: size,
      fit: fit,
    );
  }
}
