

import 'package:flutter/material.dart';

class ZoomableImage extends StatefulWidget {
  final String imagePath;
  final Function(bool) onZoomChanged;

  const ZoomableImage(this.imagePath, {required this.onZoomChanged});

  @override
  _ZoomableImageState createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(() {
      widget.onZoomChanged(_transformationController.value != Matrix4.identity());
    });
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      panEnabled: true, // ✅ يسمح بالسحب عند التكبير
      scaleEnabled: true,
      minScale: 1.0,
      maxScale: 4.0,
      child: Align(
        alignment: Alignment.center,
        child: Image.asset(widget.imagePath, fit: BoxFit.contain)
        ),
    );
  }
}
