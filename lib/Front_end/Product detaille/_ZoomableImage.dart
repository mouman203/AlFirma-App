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
  TapDownDetails? _doubleTapDetails;
  double _currentScale = 1.0;
  final double _maxScale = 4.0;
  final double _minScale = 1.0;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(() {
      widget.onZoomChanged(_currentScale > 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) {
        _doubleTapDetails = details; // ✅ تخزين مكان النقر المزدوج
      },
      onDoubleTap: () {
        setState(() {
          if (_currentScale > 1.0) {
            // ✅ إذا كان مكبّرًا، فارجعه للوضع الطبيعي
            _currentScale = _minScale;
            _transformationController.value = Matrix4.identity();
          } else {
            // ✅ إذا لم يكن مكبّرًا، فقم بالتكبير في المكان الذي تم النقر عليه
            final position = _doubleTapDetails!.localPosition;
            _currentScale = _maxScale;
            _transformationController.value = Matrix4.identity()
              ..translate(-position.dx * 2, -position.dy * 2) // التحرك إلى نقطة النقر
              ..scale(_maxScale);
          }
        });
      },
      child: InteractiveViewer(
        transformationController: _transformationController,
        panEnabled: true, // ✅ يسمح بالسحب بإصبع واحد
        scaleEnabled: true,
        minScale: _minScale,
        maxScale: _maxScale,
        child: Align(
          alignment: Alignment.center,
          child: Image.asset(widget.imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
