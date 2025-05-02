import 'dart:ui';
import 'package:agriplant/Front_end/ServicesF/Consultation_page.dart';
import 'package:agriplant/Front_end/ServicesF/Expertise_page.dart';
import 'package:agriplant/Front_end/ServicesF/Hire_worker_page.dart';
import 'package:agriplant/Front_end/ServicesF/Rent_page.dart';
import 'package:agriplant/Front_end/ServicesF/Repairs_page.dart';
import 'package:agriplant/Front_end/ServicesF/Transportation_page.dart';
import 'package:flutter/material.dart';

// Service model
class PService {
  final String name;
  final String image;
  const PService({required this.name, required this.image});
}

// List of services
final List<PService> services = [
  const PService(name: "Rent", image: "assets/services/Rent.png"),
  const PService(name: "Repairs", image: "assets/services/Repairs.png"),
  const PService(
      name: "Consultation", image: "assets/services/Consultation.png"),
  const PService(name: "Hire Worker", image: "assets/services/Workers.png"),
  const PService(
      name: "Transportation", image: "assets/services/Transportation.png"),
  const PService(name: "Expertise", image: "assets/services/Expertise.png"),
];

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  void navigateToService(BuildContext context, String name) {
    final pageMap = {
      "Rent": const RentPage(),
      "Repairs": const RepairsPage(),
      "Consultation": const ConsultationPage(),
      "Hire Worker": const HireWorkerPage(),
      "Transportation": const TransportationPage(),
      "Expertise": const ExpertisePage(),
    };

    final Widget? page = pageMap[name];

    if (page != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Page not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: services.length,
        padding: const EdgeInsets.all(7),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 7,
          mainAxisSpacing: 7,
        ),
        itemBuilder: (context, index) {
          final service = services[index];

          return InkWell(
            onTap: () {
              debugPrint("Tapped: ${service.name}");
              navigateToService(context, service.name);
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                  image: AssetImage(service.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(27),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(
                      service.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
