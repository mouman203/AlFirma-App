import 'package:flutter/material.dart';
import 'package:agriplant/Front_end/Item%20detaille/_ZoomableImage.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const FullScreenImageViewer({Key? key, required this.photos, required this.initialIndex}) : super(key: key);

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  int _currentIndex = 0;
  final TransformationController _transformationController = TransformationController();
  bool _isZoomed = false;


  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _transformationController.addListener(() {
      setState(() {
        _isZoomed = _transformationController.value != Matrix4.identity();
      });
    });
  }

  void _nextImage() {
    if (_currentIndex < widget.photos.length - 1) {
      setState(() {
        _currentIndex++;
        _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      });
    }
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
  controller: _pageController,
  itemCount: widget.photos.length,
  physics: _isZoomed ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(), // ✅ تعطيل التمرير عند التكبير
  onPageChanged: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  itemBuilder: (context, index) {
    return Center(
      child: ClipRect(
        child: ZoomableImage(widget.photos[index], onZoomChanged: (isZoomed) {
                    setState(() {
                      _isZoomed = isZoomed; // ✅ تحديث حالة التكبير
                    });
                  }),
        
      ),
    );
  },
),




          // Close Button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Left Arrow
          if (_currentIndex > 0)
            Positioned(
              left: 20,
              top: MediaQuery.of(context).size.height / 2 - 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 40),
                onPressed: _previousImage,
              ),
            ),

          // Right Arrow
          if (_currentIndex < widget.photos.length - 1)
            Positioned(
              right: 20,
              top: MediaQuery.of(context).size.height / 2 - 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
                onPressed: _nextImage,
              ),
            ),

          // Photo Counter
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Text(
              "${_currentIndex + 1} / ${widget.photos.length}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}