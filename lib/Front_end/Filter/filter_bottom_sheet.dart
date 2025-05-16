import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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

  // Direct Arabic to localized translations
  Map<String, Map<String, String>> translations = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildAllTranslations();
  }

  // Build all translations at once
  void _buildAllTranslations() {
    // Initialize the translations map structure
    translations = {
      "productTypes": {},
      "categories": {},
      "subCategories": {},
      "products": {},
      "wilayas": {},
      "dairas": {},
    };

    // Product Types translations
    _addTwoWayTranslation(
      translations["productTypes"]!,
      "منتج زراعي",
      S.of(context).agriculturalProduct,
    );
    _addTwoWayTranslation(
      translations["productTypes"]!,
      "منتج حيواني",
      S.of(context).animalProduct,
    );
    _addTwoWayTranslation(
      translations["productTypes"]!,
      "منتج تجاري",
      S.of(context).commercialProduct,
    );

    // Agricultural categories
    final agriCategoriesArabic = ProductData.agriCategories;
    final agriCategoriesLocal = ProductData.agriCategoriesT(context);

    _mapCategoriesTranslations(
      agriCategoriesArabic,
      agriCategoriesLocal,
      translations["categories"]!,
    );

    // Agricultural subcategories and products
    final agriSubCategoriesArabic = ProductData.agriSubCategories;
    final agriSubCategoriesLocal = ProductData.agriSubCategoriesT(context);

    _mapSubCategoriesAndProductsTranslations(
      agriSubCategoriesArabic,
      agriSubCategoriesLocal,
      translations["subCategories"]!,
      translations["products"]!,
    );

    // Animal products
    final animalProductsArabic = ProductData.produitsElevages;
    final animalProductsLocal = ProductData.produitsElevagesT(context);

    _mapCategoriesTranslations(
      animalProductsArabic,
      animalProductsLocal,
      translations["categories"]!,
    );

    // Commercial categories
    final commercialCategoriesArabic = ProductData.commercantCategories;
    final commercialCategoriesLocal =
        ProductData.commercantCategoriesT(context);

    _mapCategoriesTranslations(
      commercialCategoriesArabic,
      commercialCategoriesLocal,
      translations["categories"]!,
    );

    // Equipment categories
    final equipmentCategoriesArabic = ProductData.equipmentCategories;
    final equipmentCategoriesLocal = ProductData.equipmentCategoriesT(context);

    _mapSubCategoriesAndProductsTranslations(
      equipmentCategoriesArabic,
      equipmentCategoriesLocal,
      translations["subCategories"]!,
      translations["products"]!,
    );

    // Wilayas and Dairas
    final wilayasArabic = ProductData.wilayas;
    final wilayasLocal = ProductData.wilayasT(context);

    _mapWilayasAndDairasTranslations(
      wilayasArabic,
      wilayasLocal,
      translations["wilayas"]!,
      translations["dairas"]!,
    );
  }

  // Helper to add two-way translations
  void _addTwoWayTranslation(
      Map<String, String> map, String arabic, String localized) {
    map[arabic] = localized;
    map[localized] = arabic;
  }

  // Helper to map categories from Arabic to localized and vice versa
  void _mapCategoriesTranslations(
    Map<String, List<String>> arabicMap,
    Map<String, List<String>> localizedMap,
    Map<String, String> targetMap,
  ) {
    final arabicKeys = arabicMap.keys.toList();
    final localizedKeys = localizedMap.keys.toList();

    for (int i = 0; i < arabicKeys.length && i < localizedKeys.length; i++) {
      _addTwoWayTranslation(targetMap, arabicKeys[i], localizedKeys[i]);
    }
  }

  // Helper to map subcategories and products
  void _mapSubCategoriesAndProductsTranslations(
    Map<String, List<String>> arabicMap,
    Map<String, List<String>> localizedMap,
    Map<String, String> subCategoryMap,
    Map<String, String> productMap,
  ) {
    final arabicKeys = arabicMap.keys.toList();
    final localizedKeys = localizedMap.keys.toList();

    for (int i = 0; i < arabicKeys.length && i < localizedKeys.length; i++) {
      final arabicKey = arabicKeys[i];
      final localizedKey = localizedKeys[i];

      // Map subcategory names
      _addTwoWayTranslation(subCategoryMap, arabicKey, localizedKey);

      // Map product names
      final arabicProducts = arabicMap[arabicKey] ?? [];
      final localizedProducts = localizedMap[localizedKey] ?? [];

      for (int j = 0;
          j < arabicProducts.length && j < localizedProducts.length;
          j++) {
        _addTwoWayTranslation(
            productMap, arabicProducts[j], localizedProducts[j]);
      }
    }
  }

  // Helper to map wilayas and dairas
  void _mapWilayasAndDairasTranslations(
    Map<String, List<String>> arabicMap,
    Map<String, List<String>> localizedMap,
    Map<String, String> wilayaMap,
    Map<String, String> dairaMap,
  ) {
    final arabicKeys = arabicMap.keys.toList();
    final localizedKeys = localizedMap.keys.toList();

    for (int i = 0; i < arabicKeys.length && i < localizedKeys.length; i++) {
      final arabicWilaya = arabicKeys[i];
      final localizedWilaya = localizedKeys[i];

      // Map wilaya names
      _addTwoWayTranslation(wilayaMap, arabicWilaya, localizedWilaya);

      // Map daira names
      final arabicDairas = arabicMap[arabicWilaya] ?? [];
      final localizedDairas = localizedMap[localizedWilaya] ?? [];

      for (int j = 0;
          j < arabicDairas.length && j < localizedDairas.length;
          j++) {
        _addTwoWayTranslation(dairaMap, arabicDairas[j], localizedDairas[j]);
      }
    }
  }

  // Convert localized value to Arabic for database queries
  String? getArabicValue(String? localizedValue, String translationType) {
    if (localizedValue == null) return null;

    final translationMap = translations[translationType];
    if (translationMap == null) return localizedValue;

    return translationMap[localizedValue] ?? localizedValue;
  }

  Widget buildDropdown({
    required BuildContext context,
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<String>(
              value: value,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondaryContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: Text(
                hint,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
              ),
              iconStyleData: IconStyleData(
                iconEnabledColor: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
                iconDisabledColor: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 180,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                offset: const Offset(0, 0), // aligns directly under the button
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF256C4C),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }

  Future<List<Products>> fetchFilteredProducts() async {
    List<Products> allProducts = [];

    // Convert from localized values to Arabic values for filtering
    String? arabicProductType =
        getArabicValue(selectedProductType, "productTypes");
    String? arabicMainCategory =
        getArabicValue(selectedMainCategory, "categories");
    String? arabicSubCategory =
        getArabicValue(selectedSubCategory, "subCategories");
    String? arabicFinalItem = getArabicValue(selectedFinalItem, "products");
    String? arabicWilaya = getArabicValue(selectedWilaya, "wilayas");
    String? arabicDaira = getArabicValue(selectedDaira, "dairas");

    print("typeProduct:$arabicProductType");
    print("category:$arabicMainCategory");
    print("sub category:$arabicSubCategory");
    print("produit:$arabicFinalItem");
    print("wilaya:$arabicWilaya");
    print("daira:$arabicDaira");

    // Build farmer products query
    Query productQuery = FirebaseFirestore.instance
        .collection('item')
        .doc('Products')
        .collection('Products');

    // Apply filters
    if (arabicProductType != null && arabicProductType.isNotEmpty) {
      productQuery =
          productQuery.where('typeItem', isEqualTo: arabicProductType);
    }

    if (arabicMainCategory != null && arabicMainCategory.isNotEmpty) {
      productQuery =
          productQuery.where('category', isEqualTo: arabicMainCategory);
    }

    if (arabicSubCategory != null && arabicSubCategory.isNotEmpty) {
      productQuery =
          productQuery.where('sub_category', isEqualTo: arabicSubCategory);
    }

    if (arabicFinalItem != null && arabicFinalItem.isNotEmpty) {
      productQuery = productQuery.where('product', isEqualTo: arabicFinalItem);
    }

    if (arabicWilaya != null && arabicWilaya.isNotEmpty) {
      productQuery = productQuery.where('wilaya', isEqualTo: arabicWilaya);
    }

    if (arabicDaira != null && arabicDaira.isNotEmpty) {
      productQuery = productQuery.where('daira', isEqualTo: arabicDaira);
    }

    if (minPrice != null) {
      productQuery =
          productQuery.where('price', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      productQuery = productQuery.where('price', isLessThanOrEqualTo: maxPrice);
    }

    // Execute queries
    QuerySnapshot agriSnapshot = await productQuery.get();

    allProducts
        .addAll(agriSnapshot.docs.map((doc) => Products.fromFirestore(doc)));

    return allProducts;
  }

  // Helper to get localized product types
  List<String> getLocalizedProductTypes() {
    return [
      S.of(context).agriculturalProduct,
      S.of(context).animalProduct,
      S.of(context).commercialProduct,
    ];
  }

  // Helper to get main categories based on product type
  List<String> getMainCategories(String? productType) {
    if (productType == null) return [];

    String? arabicType = getArabicValue(productType, "productTypes");
    if (arabicType == null) return [];

    switch (arabicType) {
      case "منتج زراعي":
        return ProductData.agriCategoriesT(context).keys.toList();
      case "منتج حيواني":
        return ProductData.produitsElevagesT(context).keys.toList();
      case "منتج تجاري":
        return ProductData.commercantCategoriesT(context).keys.toList();
      default:
        return [];
    }
  }

  // Helper to get subcategories based on product type and main category
  List<String> getSubCategories(String? productType, String? mainCategory) {
    if (productType == null || mainCategory == null) return [];

    String? arabicType = getArabicValue(productType, "productTypes");
    String? arabicCategory = getArabicValue(mainCategory, "categories");

    if (arabicType == null || arabicCategory == null) return [];

    if (arabicType == "منتج زراعي") {
      if (arabicCategory == "منتوجات فلاحية") {
        return ProductData.agriSubCategoriesT(context).keys.toList();
      }
    } else if (arabicType == "منتج تجاري") {
      if (arabicCategory == "معدات") {
        return ProductData.equipmentCategoriesT(context).keys.toList();
      } else if (arabicCategory == "أراضي") {
        return []; // Lands don't have subcategories
      }
    }

    return [];
  }

// Helper to get final products based on selected category/subcategory
  List<String> getFinalItems(
      String? productType, String? mainCategory, String? subCategory) {
    if (productType == null || mainCategory == null) return [];

    String? arabicType = getArabicValue(productType, "productTypes");
    String? arabicCategory = getArabicValue(mainCategory, "categories");

    if (arabicType == null || arabicCategory == null) return [];

    // Special handling for animal products - directly return products for the category
    if (arabicType == "منتج حيواني") {
      // Debug output to check what's happening
      print("Getting animal products for category: $mainCategory");
      final products =
          ProductData.produitsElevagesT(context)[mainCategory] ?? [];
      print("Found ${products.length} animal products");
      return products;
    }

    // For products that require subcategories
    if (subCategory == null) return [];
    String? arabicSubCategory = getArabicValue(subCategory, "subCategories");
    if (arabicSubCategory == null) return [];

    if (arabicType == "منتج زراعي" && arabicCategory == "منتوجات فلاحية") {
      return ProductData.agriSubCategoriesT(context)[subCategory] ?? [];
    } else if (arabicType == "منتج تجاري" && arabicCategory == "معدات") {
      return ProductData.equipmentCategoriesT(context)[subCategory] ?? [];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // Get available options based on current selections
    List<String> productTypes = getLocalizedProductTypes();
    List<String> mainCategories = getMainCategories(selectedProductType);

    // Modified logic for subcategories and finalItems
    List<String> subCategories =
        getSubCategories(selectedProductType, selectedMainCategory);

    // For animal products, we want to show products directly after selecting a category
    bool showFinalItemsDirectly = selectedProductType != null &&
        getArabicValue(selectedProductType, "productTypes") == "منتج حيواني" &&
        selectedMainCategory != null;

    List<String> finalItems = [];
    if (showFinalItemsDirectly) {
      // For animal products, get items directly from the selected category
      finalItems =
          ProductData.produitsElevagesT(context)[selectedMainCategory] ?? [];
    } else {
      // For other products that use subcategories
      finalItems = getFinalItems(
          selectedProductType, selectedMainCategory, selectedSubCategory);
    }

    List<String> wilayas = ProductData.wilayasT(context).keys.toList();
    List<String> dairas = selectedWilaya != null
        ? (ProductData.wilayasT(context)[selectedWilaya!] ?? [])
        : [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).filterProducts,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Product Type Dropdown
            buildDropdown(
              context: context,
              value: selectedProductType,
              items: productTypes,
              hint: S.of(context).productType,
              onChanged: (val) {
                setState(() {
                  selectedProductType = val;
                  selectedMainCategory = null;
                  selectedSubCategory = null;
                  selectedFinalItem = null;
                });
              },
            ),

            // Main Category Dropdown
            if (selectedProductType != null && mainCategories.isNotEmpty)
              buildDropdown(
                context: context,
                value: selectedMainCategory,
                items: mainCategories,
                hint: S.of(context).category,
                onChanged: (val) {
                  setState(() {
                    selectedMainCategory = val;
                    selectedSubCategory = null;
                    selectedFinalItem = null;
                  });
                },
              ),

            // Sub Category Dropdown - Don't show for animal products
            if (selectedMainCategory != null &&
                subCategories.isNotEmpty &&
                !showFinalItemsDirectly)
              buildDropdown(
                context: context,
                value: selectedSubCategory,
                items: subCategories,
                hint: S.of(context).subCategory,
                onChanged: (val) {
                  setState(() {
                    selectedSubCategory = val;
                    selectedFinalItem = null;
                  });
                },
              ),

          
            if ((showFinalItemsDirectly || selectedSubCategory != null) &&
                finalItems.isNotEmpty)
              buildDropdown(
                context: context,
                value: selectedFinalItem,
                items: finalItems,
                hint: S.of(context).product,
                onChanged: (val) {
                  setState(() {
                    selectedFinalItem = val;
                  });
                },
              ),

            // Location Dropdowns
            buildDropdown(
              context: context,
              value: selectedWilaya,
              items: wilayas,
              hint: S.of(context).wilaya,
              onChanged: (value) {
                setState(() {
                  selectedWilaya = value;
                  selectedDaira = null;
                });
              },
            ),

            // Daira Dropdown (depends on selected Wilaya)
            if (selectedWilaya != null && dairas.isNotEmpty)
              buildDropdown(
                context: context,
                value: selectedDaira,
                items: dairas,
                hint: S.of(context).daira,
                onChanged: (value) {
                  setState(() {
                    selectedDaira = value;
                  });
                },
              ),

            // Price Range Inputs
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                fillColor: colorScheme.secondaryContainer,
                filled: true,
                labelText: S.of(context).minPrice,
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.secondaryContainer,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: colorScheme.secondaryContainer, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              onChanged: (value) => minPrice = double.tryParse(value),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                fillColor: colorScheme.secondaryContainer,
                filled: true,
                labelText: S.of(context).maxPrice,
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.secondaryContainer,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.secondaryContainer,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              onChanged: (value) => maxPrice = double.tryParse(value),
            ),
            const SizedBox(height: 50),

            // Action Buttons
            ElevatedButton(
              onPressed: () async {
                List<Products> filteredProducts = await fetchFilteredProducts();
                Navigator.pop(context, filteredProducts);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
                foregroundColor:
                    isDarkMode ? Colors.black : Colors.white, // Text color
                minimumSize:
                    Size(double.infinity, 50), // Increase button height
                padding:
                    EdgeInsets.symmetric(horizontal: 16), // Horizontal padding
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Rounded edges with radius 12
                ),
              ),
              child: Text(
                S.of(context).apply,
                style: TextStyle(
                    fontSize: 20), // Increase font size for visibility
              ),
            ),

            const SizedBox(height: 30), // Space between buttons

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor:
                    isDarkMode ? Colors.white : Colors.black, // Text color
                minimumSize:
                    Size(double.infinity, 50), // Increase button height
                padding:
                    EdgeInsets.symmetric(horizontal: 16), // Horizontal padding
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Rounded edges with radius 12
                ),
              ),
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                  fontSize: 20,
                ), // Increase font size for visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}
