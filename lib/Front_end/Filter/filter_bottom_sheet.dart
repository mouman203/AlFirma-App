
import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(String?, double?, double?)? onApplyFilter;

  const FilterBottomSheet({super.key, this.onApplyFilter});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedProductType;
  String? selectedMainCategory;
  String? selectedSubCategory;
  String? selectedFinalItem;
  String? selectedWilaya;
  String? selectedDaira;
  double? minPrice;
  double? maxPrice;

  Widget buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Future<List<Products>> fetchFilteredProducts() async {
    List<Products> allProducts = [];
    print("typeProduct:$selectedProductType");
    print("category:$selectedMainCategory");
    print("sub category:$selectedSubCategory");
    print("produit:$selectedFinalItem");
    print("wilaya:$selectedWilaya");
    print("daira:$selectedDaira");

    // بناء استعلام منتجات الفلاحين
    Query productQuery = FirebaseFirestore.instance
        .collection('item')
        .doc('Products')
        .collection('Products');

    // تطبيق الفلاتر
    if (selectedProductType != null && selectedProductType!.isNotEmpty) {
      productQuery =
          productQuery.where('typeItem', isEqualTo: selectedProductType);
     
    }

    if (selectedMainCategory != null && selectedMainCategory!.isNotEmpty) {
      productQuery = productQuery.where('category', isEqualTo: selectedMainCategory);
    }

    if (selectedSubCategory != null && selectedSubCategory!.isNotEmpty) {
      productQuery = productQuery.where('sub_category', isEqualTo: selectedSubCategory);
    }

    if (selectedFinalItem != null && selectedFinalItem!.isNotEmpty) {
      productQuery = productQuery.where('product', isEqualTo: selectedFinalItem);
    }

    if (selectedWilaya != null && selectedWilaya!.isNotEmpty) {
      productQuery = productQuery.where('wilaya', isEqualTo: selectedWilaya);
    }

    if (selectedDaira != null && selectedDaira!.isNotEmpty) {
      productQuery = productQuery.where('daira', isEqualTo: selectedDaira);
    }

    if (minPrice != null) {
      productQuery = productQuery.where('price', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      productQuery = productQuery.where('price', isLessThanOrEqualTo: maxPrice);
    }

    // تنفيذ الاستعلامات
    QuerySnapshot agriSnapshot = await productQuery.get();

    allProducts
        .addAll(agriSnapshot.docs.map((doc) => Products.fromFirestore(doc)));


    return allProducts;
  }

  @override
  Widget build(BuildContext context) {
    List<String> mainCategories =
        ProductData.getMainCategories(selectedProductType,context);
    List<String> wilayas = ProductData.getWilaya(context);
    List<String> subCategories =
        ProductData.getSubCategories(selectedProductType, selectedMainCategory,context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Filter Products",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // 🏷 Select Product Type (Agricol or Eleveur)
            Column(
              children: [
                buildDropdown(
                  value: selectedProductType,
                  items: ["Agricultural Product", "Animal Product","Commercial Product"],
                  hint: "نوع المنتج",
                  onChanged: (val) {
                    setState(() {
                      selectedProductType = val;
                      selectedMainCategory = null;
                      selectedSubCategory = null;
                      selectedFinalItem = null;
                    });
                  },
                ),
                if (selectedProductType != null)
                  buildDropdown(
                    value: selectedMainCategory,
                    items: mainCategories,
                    hint: "اختر الفئة",
                    onChanged: (val) {
                      setState(() {
                        selectedMainCategory = val;
                        selectedSubCategory = null;
                        selectedFinalItem = null;
                      });
                    },
                  ),
                if (selectedMainCategory != null && subCategories != "أراضي")
                  buildDropdown(
                    value: selectedSubCategory,
                    items: subCategories,
                    hint: "اختر التصنيف الفرعي",
                    onChanged: (val) {
                      setState(() {
                        selectedSubCategory = val;
                        selectedFinalItem = null;
                      });
                    },
                  ),
                if (selectedMainCategory == "منتوجات فلاحية" &&
                    selectedSubCategory != null)
                  buildDropdown(
                    value: selectedFinalItem,
                    items:
                        ProductData.agriSubCategoriesT(context)[selectedSubCategory!] ??
                            [],
                    hint: "اختر منتوج",
                    onChanged: (val) {
                      setState(() {
                        selectedFinalItem = val;
                      });
                    },
                  ),
                if (selectedMainCategory == "معدات" &&
                    selectedSubCategory != null)
                  buildDropdown(
                    value: selectedFinalItem,
                    items:
                        ProductData.equipmentCategoriesT(context)[selectedSubCategory!] ??
                            [],
                    hint: "اختر المعدة",
                    onChanged: (val) {
                      setState(() {
                        selectedFinalItem = val;
                      });
                    },
                  ),
              ],
            ),

            Column(
              children: [
                // Wilaya Dropdown
                buildDropdown(
                  value: selectedWilaya,
                  items: wilayas,
                  hint: 'Select Wilaya',
                  onChanged: (value) {
                    setState(() {
                      selectedWilaya = value;
                      selectedDaira = null;
                    });
                  },
                ),
                // Daira Dropdown (depends on selected Wilaya)
                if (selectedWilaya != null)
                  buildDropdown(
                    value: selectedDaira,
                    items: ProductData.wilayasT(context)[selectedWilaya!] ?? [],
                    hint: 'Select Daira',
                    onChanged: (value) {
                      setState(() {
                        selectedDaira = value;
                      });
                    },
                  ),
              ],
            ),

            // 💰 Min Price Input
            TextField(
              decoration: const InputDecoration(labelText: "Min Price"),
              keyboardType: TextInputType.number,
              onChanged: (value) => minPrice = double.tryParse(value),
            ),

            // 💰 Max Price Input
            TextField(
              decoration: const InputDecoration(labelText: "Max Price"),
              keyboardType: TextInputType.number,
              onChanged: (value) => maxPrice = double.tryParse(value),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                List<Products> allProducts = await fetchFilteredProducts();
                Navigator.pop(context, allProducts);
              },
              child: const Text("Apply"),
            ),

            // 🚪 Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}
