import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(String?, double?, double?) onApplyFilter;

  const FilterBottomSheet({super.key, required this.onApplyFilter});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedCategory;
  double? minPrice;
  double? maxPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Filter Products", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:Color.fromARGB(255, 39, 83, 41)),),
          

          // 🏷️ اختيار الفئة (Category)
          DropdownButton<String>(
            hint: const Text("Select Category"),
            value: selectedCategory,
            items: ["Fruits", "Vegetables", "Dairy"].map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedCategory = value);
            },
          ),

          // 💰 إدخال الحد الأدنى للسعر
          TextField(
            decoration: const InputDecoration(labelText: "Min Price"),
            keyboardType: TextInputType.number,
            onChanged: (value) => minPrice = double.tryParse(value),
          ),

          // 💰 إدخال الحد الأقصى للسعر
          TextField(
            decoration: const InputDecoration(labelText: "Max Price"),
            keyboardType: TextInputType.number,
            onChanged: (value) => maxPrice = double.tryParse(value),
          ),
          const SizedBox(height: 10),
          // 📏 زر تطبيق الفلتر
          ElevatedButton(
          onPressed: () {
            //applyFilter(); // ✅ تطبيق الفلتر
            Navigator.of(context).pop(); // إغلاق النافذة بعد التطبيق
          },
          child: const Text("Apply"),
        ),
          // 🚪 زر إغلاق النافذة
          TextButton(
          onPressed: () => Navigator.of(context).pop(), // ❌ زر إغلاق النافذة
          child: const Text("Cancel"),
        ),
        
        ],
      ),
    );
  }
}
