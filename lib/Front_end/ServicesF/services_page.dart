import 'dart:ui';
import 'package:agriplant/Front_end/ServicesF/Consultation_page.dart';
import 'package:agriplant/Front_end/ServicesF/Expertise_page.dart';
import 'package:agriplant/Front_end/ServicesF/Hire_worker_page.dart';
import 'package:agriplant/Front_end/ServicesF/Rent_page.dart';
import 'package:agriplant/Front_end/ServicesF/Repairs_page.dart';
import 'package:agriplant/Front_end/ServicesF/Transportation_page.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:flutter/material.dart';

// Service model
class PService {
  final String name;
  final String image;
  const PService({required this.name, required this.image});
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  List<PService> getServices(BuildContext context) {
    return [
      PService(name: S.of(context).rent, image: "assets/services/Rent.png"),
      PService(
          name: S.of(context).repairs, image: "assets/services/Repairs.png"),
      PService(
          name: S.of(context).consultation,
          image: "assets/services/Consultation.png"),
      PService(
          name: S.of(context).hireWorker, image: "assets/services/Workers.png"),
      PService(
          name: S.of(context).transportation,
          image: "assets/services/Transportation.png"),
      PService(
          name: S.of(context).expertise,
          image: "assets/services/Expertise.png"),
    ];
  }

  void navigateToService(BuildContext context, String name) {
    final pageMap = {
      S.of(context).rent: const RentPage(),
      S.of(context).repairs: const RepairsPage(),
      S.of(context).consultation: const ConsultationPage(),
      S.of(context).hireWorker: const HireWorkerPage(),
      S.of(context).transportation: const TransportationPage(),
      S.of(context).expertise: const ExpertisePage(),
    };

    final Widget? page = pageMap[name];

    if (page != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).pageNotFound)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = getServices(context);

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
