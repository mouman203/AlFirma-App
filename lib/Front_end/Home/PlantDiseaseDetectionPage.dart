import 'dart:io';
import 'dart:typed_data';
import 'package:agriplant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class PlantDiseaseDetectionPage extends StatefulWidget {
  const PlantDiseaseDetectionPage({Key? key}) : super(key: key);

  @override
  State<PlantDiseaseDetectionPage> createState() =>
      _PlantDiseaseDetectionPageState();
}

class _PlantDiseaseDetectionPageState extends State<PlantDiseaseDetectionPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  Interpreter? _interpreter;
  bool _isLoading = false;
  String? _detectedDisease;
  double? _confidence;
  List<String>? _suggestions;

  // Minimum confidence threshold for detection
  static const double _confidenceThreshold = 0.5;

  // Supported plants - extracted from training data
  List<String> _supportedPlants(BuildContext context) => [
        S.of(context).plant_apple,
        S.of(context).plant_cherry,
        S.of(context).plant_corn,
        S.of(context).plant_grape,
        S.of(context).plant_peach,
        S.of(context).plant_potato,
        S.of(context).plant_strawberry,
        S.of(context).plant_tomato,
      ];

  // Class names in the order they were trained
  final List<String> _classNames = [
    'Apple___Apple_scab',
    'Apple___Black_rot',
    'Apple___Cedar_apple_rust',
    'Apple___healthy',
    'Cherry___Powdery_mildew',
    'Cherry___healthy',
    'Corn___Cercospora_leaf_spot Gray_leaf_spot',
    'Corn___Common_rust_',
    'Corn___Northern_Leaf_Blight',
    'Corn___healthy',
    'Grape___Black_rot',
    'Grape___Esca_(Black_Measles)',
    'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
    'Grape___healthy',
    'Peach___Bacterial_spot',
    'Peach___healthy',
    'Potato___Early_blight',
    'Potato___Late_blight',
    'Potato___healthy',
    'Strawberry___Leaf_scorch',
    'Strawberry___healthy',
    'Tomato___Bacterial_spot',
    'Tomato___Early_blight',
    'Tomato___Late_blight',
    'Tomato___Leaf_Mold',
    'Tomato___Septoria_leaf_spot',
    'Tomato___Spider_mites Two-spotted_spider_mite',
    'Tomato___Target_Spot',
    'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
    'Tomato___Tomato_mosaic_virus',
    'Tomato___healthy',
  ];

  // Disease information map
  Map<String, Map<String, dynamic>> _diseaseInfo(BuildContext context) {
    return {
      "Apple___Apple_scab": {
        "label": S.of(context).appleAppleScabLabel,
        "suggestions": [
          S.of(context).appleAppleScabSuggestion1,
          S.of(context).appleAppleScabSuggestion2,
          S.of(context).appleAppleScabSuggestion3,
        ]
      },
      "Apple___Black_rot": {
        "label": S.of(context).appleBlackRotLabel,
        "suggestions": [
          S.of(context).appleBlackRotSuggestion1,
          S.of(context).appleBlackRotSuggestion2,
          S.of(context).appleBlackRotSuggestion3,
        ]
      },
      "Apple___Cedar_apple_rust": {
        "label": S.of(context).appleCedarAppleRustLabel,
        "suggestions": [
          S.of(context).appleCedarAppleRustSuggestion1,
          S.of(context).appleCedarAppleRustSuggestion2,
          S.of(context).appleCedarAppleRustSuggestion3,
        ]
      },
      "Apple___healthy": {
        "label": S.of(context).appleHealthyLabel,
        "suggestions": [
          S.of(context).appleHealthySuggestion1,
          S.of(context).appleHealthySuggestion2,
          S.of(context).appleHealthySuggestion3,
        ]
      },
      "Cherry___Powdery_mildew": {
        "label": S.of(context).cherryPowderyMildewLabel,
        "suggestions": [
          S.of(context).cherryPowderyMildewSuggestion1,
          S.of(context).cherryPowderyMildewSuggestion2,
          S.of(context).cherryPowderyMildewSuggestion3,
        ]
      },
      "Cherry___healthy": {
        "label": S.of(context).cherryHealthyLabel,
        "suggestions": [
          S.of(context).cherryHealthySuggestion1,
          S.of(context).cherryHealthySuggestion2,
          S.of(context).cherryHealthySuggestion3,
        ]
      },
      "Corn___Cercospora_leaf_spot Gray_leaf_spot": {
        "label": S.of(context).cornCercosporaLeafSpotLabel,
        "suggestions": [
          S.of(context).cornCercosporaLeafSpotSuggestion1,
          S.of(context).cornCercosporaLeafSpotSuggestion2,
          S.of(context).cornCercosporaLeafSpotSuggestion3,
        ]
      },
      "Corn___Common_rust_": {
        "label": S.of(context).cornCommonRustLabel,
        "suggestions": [
          S.of(context).cornCommonRustSuggestion1,
          S.of(context).cornCommonRustSuggestion2,
          S.of(context).cornCommonRustSuggestion3,
        ]
      },
      "Corn___Northern_Leaf_Blight": {
        "label": S.of(context).cornNorthernLeafBlightLabel,
        "suggestions": [
          S.of(context).cornNorthernLeafBlightSuggestion1,
          S.of(context).cornNorthernLeafBlightSuggestion2,
          S.of(context).cornNorthernLeafBlightSuggestion3,
        ]
      },
      "Corn___healthy": {
        "label": S.of(context).cornHealthyLabel,
        "suggestions": [
          S.of(context).cornHealthySuggestion1,
          S.of(context).cornHealthySuggestion2,
          S.of(context).cornHealthySuggestion3,
        ]
      },
      "Grape___Black_rot": {
        "label": S.of(context).grapeBlackRotLabel,
        "suggestions": [
          S.of(context).grapeBlackRotSuggestion1,
          S.of(context).grapeBlackRotSuggestion2,
          S.of(context).grapeBlackRotSuggestion3,
        ]
      },
      "Grape___Esca_(Black_Measles)": {
        "label": S.of(context).grapeEscaLabel,
        "suggestions": [
          S.of(context).grapeEscaSuggestion1,
          S.of(context).grapeEscaSuggestion2,
          S.of(context).grapeEscaSuggestion3,
        ]
      },
      "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)": {
        "label": S.of(context).grapeLeafBlightLabel,
        "suggestions": [
          S.of(context).grapeLeafBlightSuggestion1,
          S.of(context).grapeLeafBlightSuggestion2,
          S.of(context).grapeLeafBlightSuggestion3,
        ]
      },
      "Grape___healthy": {
        "label": S.of(context).grapeHealthyLabel,
        "suggestions": [
          S.of(context).grapeHealthySuggestion1,
          S.of(context).grapeHealthySuggestion2,
          S.of(context).grapeHealthySuggestion3,
        ]
      },
      "Peach___Bacterial_spot": {
        "label": S.of(context).peachBacterialSpotLabel,
        "suggestions": [
          S.of(context).peachBacterialSpotSuggestion1,
          S.of(context).peachBacterialSpotSuggestion2,
          S.of(context).peachBacterialSpotSuggestion3,
        ]
      },
      "Peach___healthy": {
        "label": S.of(context).peachHealthyLabel,
        "suggestions": [
          S.of(context).peachHealthySuggestion1,
          S.of(context).peachHealthySuggestion2,
          S.of(context).peachHealthySuggestion3,
        ]
      },
      "Potato___Early_blight": {
        "label": S.of(context).potatoEarlyBlightLabel,
        "suggestions": [
          S.of(context).potatoEarlyBlightSuggestion1,
          S.of(context).potatoEarlyBlightSuggestion2,
          S.of(context).potatoEarlyBlightSuggestion3,
        ]
      },
      "Potato___Late_blight": {
        "label": S.of(context).potatoLateBlightLabel,
        "suggestions": [
          S.of(context).potatoLateBlightSuggestion1,
          S.of(context).potatoLateBlightSuggestion2,
          S.of(context).potatoLateBlightSuggestion3,
        ]
      },
      "Potato___healthy": {
        "label": S.of(context).potatoHealthyLabel,
        "suggestions": [
          S.of(context).potatoHealthySuggestion1,
          S.of(context).potatoHealthySuggestion2,
          S.of(context).potatoHealthySuggestion3,
        ]
      },
      "Strawberry___Leaf_scorch": {
        "label": S.of(context).strawberryLeafScorchLabel,
        "suggestions": [
          S.of(context).strawberryLeafScorchSuggestion1,
          S.of(context).strawberryLeafScorchSuggestion2,
          S.of(context).strawberryLeafScorchSuggestion3,
        ]
      },
      "Strawberry___healthy": {
        "label": S.of(context).strawberryHealthyLabel,
        "suggestions": [
          S.of(context).strawberryHealthySuggestion1,
          S.of(context).strawberryHealthySuggestion2,
          S.of(context).strawberryHealthySuggestion3,
        ]
      },
      "Tomato___Bacterial_spot": {
        "label": S.of(context).tomatoBacterialSpotLabel,
        "suggestions": [
          S.of(context).tomatoBacterialSpotSuggestion1,
          S.of(context).tomatoBacterialSpotSuggestion2,
          S.of(context).tomatoBacterialSpotSuggestion3,
        ]
      },
      "Tomato___Early_blight": {
        "label": S.of(context).tomatoEarlyBlightLabel,
        "suggestions": [
          S.of(context).tomatoEarlyBlightSuggestion1,
          S.of(context).tomatoEarlyBlightSuggestion2,
          S.of(context).tomatoEarlyBlightSuggestion3,
        ]
      },
      "Tomato___Late_blight": {
        "label": S.of(context).tomatoLateBlightLabel,
        "suggestions": [
          S.of(context).tomatoLateBlightSuggestion1,
          S.of(context).tomatoLateBlightSuggestion2,
          S.of(context).tomatoLateBlightSuggestion3,
        ]
      },
      "Tomato___Leaf_Mold": {
        "label": S.of(context).tomatoLeafMoldLabel,
        "suggestions": [
          S.of(context).tomatoLeafMoldSuggestion1,
          S.of(context).tomatoLeafMoldSuggestion2,
          S.of(context).tomatoLeafMoldSuggestion3,
        ]
      },
      "Tomato___Septoria_leaf_spot": {
        "label": S.of(context).tomatoSeptoriaLeafSpotLabel,
        "suggestions": [
          S.of(context).tomatoSeptoriaLeafSpotSuggestion1,
          S.of(context).tomatoSeptoriaLeafSpotSuggestion2,
          S.of(context).tomatoSeptoriaLeafSpotSuggestion3,
        ]
      },
      "Tomato___Spider_mites Two-spotted_spider_mite": {
        "label": S.of(context).tomatoSpiderMitesLabel,
        "suggestions": [
          S.of(context).tomatoSpiderMitesSuggestion1,
          S.of(context).tomatoSpiderMitesSuggestion2,
          S.of(context).tomatoSpiderMitesSuggestion3,
        ]
      },
      "Tomato___Target_Spot": {
        "label": S.of(context).tomatoTargetSpotLabel,
        "suggestions": [
          S.of(context).tomatoTargetSpotSuggestion1,
          S.of(context).tomatoTargetSpotSuggestion2,
          S.of(context).tomatoTargetSpotSuggestion3,
        ]
      },
      "Tomato___Tomato_Yellow_Leaf_Curl_Virus": {
        "label": S.of(context).tomatoYellowLeafCurlVirusLabel,
        "suggestions": [
          S.of(context).tomatoYellowLeafCurlVirusSuggestion1,
          S.of(context).tomatoYellowLeafCurlVirusSuggestion2,
          S.of(context).tomatoYellowLeafCurlVirusSuggestion3,
        ]
      },
      "Tomato___Tomato_mosaic_virus": {
        "label": S.of(context).tomatoMosaicVirusLabel,
        "suggestions": [
          S.of(context).tomatoMosaicVirusSuggestion1,
          S.of(context).tomatoMosaicVirusSuggestion2,
          S.of(context).tomatoMosaicVirusSuggestion3,
        ]
      },
      "Tomato___healthy": {
        "label": S.of(context).tomatoHealthyLabel,
        "suggestions": [
          S.of(context).tomatoHealthySuggestion1,
          S.of(context).tomatoHealthySuggestion2,
          S.of(context).tomatoHealthySuggestion3,
        ]
      },
    };
  }

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
          'assets/models/best_plant_disease_model.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> _pickImage() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.add_a_photo,
              color: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C),
            ),
            const SizedBox(width: 8),
            Text(S.of(context).chooseImageSource,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageSourceOption(
              icon: Icons.photo_library,
              title: S.of(context).select_from_gallery,
              onTap: () => _selectImage(ImageSource.gallery),
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 8),
            _buildImageSourceOption(
              icon: Icons.camera_alt,
              title: S.of(context).capture_with_camera,
              onTap: () => _selectImage(ImageSource.camera),
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode
                ? const Color(0xFF90D5AE).withOpacity(0.3)
                : const Color(0xFF256C4C).withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C))
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage(ImageSource source) async {
    Navigator.pop(context);
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
        _detectedDisease = null;
        _confidence = null;
        _suggestions = null;
      });
      await _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    if (_pickedImage == null || _interpreter == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Read and decode the image
      final imageBytes = await _pickedImage!.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Could not decode image');
      }

      // Resize image to 224x224
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // Convert to Float32List and normalize
      Float32List input = Float32List(1 * 224 * 224 * 3);
      int pixelIndex = 0;

      final pixels = resizedImage.getBytes();

      if (resizedImage.numChannels == 3) {
        for (int i = 0; i < pixels.length; i += 3) {
          input[pixelIndex++] = pixels[i] / 255.0;
          input[pixelIndex++] = pixels[i + 1] / 255.0;
          input[pixelIndex++] = pixels[i + 2] / 255.0;
        }
      } else if (resizedImage.numChannels == 4) {
        for (int i = 0; i < pixels.length; i += 4) {
          input[pixelIndex++] = pixels[i] / 255.0;
          input[pixelIndex++] = pixels[i + 1] / 255.0;
          input[pixelIndex++] = pixels[i + 2] / 255.0;
        }
      } else {
        for (int y = 0; y < 224; y++) {
          for (int x = 0; x < 224; x++) {
            final pixel = resizedImage.getPixel(x, y);
            input[pixelIndex++] = pixel.r / 255.0;
            input[pixelIndex++] = pixel.g / 255.0;
            input[pixelIndex++] = pixel.b / 255.0;
          }
        }
      }

      var inputTensor = input.reshape([1, 224, 224, 3]);
      var outputTensor = List.filled(1 * _classNames.length, 0.0)
          .reshape([1, _classNames.length]);

      _interpreter!.run(inputTensor, outputTensor);

      List<double> predictions = outputTensor[0].cast<double>();

      double maxConfidence = 0.0;
      int maxIndex = 0;

      for (int i = 0; i < predictions.length; i++) {
        if (predictions[i] > maxConfidence) {
          maxConfidence = predictions[i];
          maxIndex = i;
        }
      }

      // Only show results if confidence is above threshold
      if (maxConfidence >= _confidenceThreshold) {
        String predictedClass = _classNames[maxIndex];
        Map<String, dynamic>? diseaseData =
            _diseaseInfo(context)[predictedClass];

        setState(() {
          _detectedDisease = diseaseData?['label'] ?? predictedClass;
          _confidence = maxConfidence * 100;
          _suggestions = List<String>.from(diseaseData?['suggestions'] ?? []);
          _isLoading = false;
        });
      } else {
        // If confidence is too low, just reset without showing anything
        setState(() {
          _detectedDisease = null;
          _confidence = null;
          _suggestions = null;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).lowConfidenceDetection),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error analyzing image: $e');
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${S.of(context).imageAnalysisError} : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSupportedPlantsChips() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final background = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1.2,
          color: isDarkMode
              ? const Color(0xFF90D5AE).withOpacity(0.4)
              : const Color(0xFF256C4C).withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Text(
            S.of(context).supported,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 2.5),
          Expanded(
            child: Wrap(
              spacing: 6,
              children: _supportedPlants(context)
                  .map((plant) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF90D5AE).withOpacity(0.2)
                              : const Color(0xFF256C4C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          plant,
                          style: TextStyle(
                            color: isDarkMode
                                ? const Color(0xFF90D5AE)
                                : const Color(0xFF256C4C),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBox() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final background = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 300,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isDarkMode ? const Color(0xFF90D5AE) : const Color(0xFF256C4C),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: background,
        ),
        child: _pickedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: (isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C))
                          .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_a_photo,
                      size: 60,
                      color: isDarkMode
                          ? const Color(0xFF90D5AE)
                          : const Color(0xFF256C4C),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    S.of(context).tapToAddImage,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.of(context).selectImageSource,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(_pickedImage!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
      ),
    );
  }

  Widget _buildResultSection() {
    if (_pickedImage == null) return const SizedBox.shrink();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading) ...[
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).analyzingImage,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).pleaseWait,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_detectedDisease != null) ...[
              Row(
                children: [
                  Icon(
                    _detectedDisease!.toLowerCase().contains('healthy')
                        ? Icons.check_circle
                        : Icons.warning,
                    color: _detectedDisease!.toLowerCase().contains('healthy')
                        ? Colors.green
                        : Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      S.of(context).detectionResult,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C))
                        .withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _detectedDisease!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 16,
                          color: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${S.of(context).confidence} : ${_confidence!.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? const Color(0xFF90D5AE)
                                : const Color(0xFF256C4C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_suggestions != null && _suggestions!.isNotEmpty) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      color: isDarkMode
                          ? const Color(0xFF90D5AE)
                          : const Color(0xFF256C4C),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).treatmentRecommendations,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._suggestions!.asMap().entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: (isDarkMode
                                ? const Color(0xFF90D5AE)
                                : const Color(0xFF256C4C))
                            .withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF90D5AE)
                                : const Color(0xFF256C4C),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant Disease Detection',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 5,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).appTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).uploadInstruction,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              _buildSupportedPlantsChips(),
              _buildImageBox(),
              _buildResultSection(),
            ],
          ),
        ),
      ),
    );
  }
}
