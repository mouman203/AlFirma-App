import 'dart:convert';
import 'package:agriplant/Front_end/Home/PlantDiseaseDetectionPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Authentication/LoginPage.dart';
import 'package:agriplant/Front_end/Filter/filter_bottom_sheet.dart';
import 'package:agriplant/Search/SearchHistoryManager%20.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:agriplant/widgets_UI/Item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Users user = Users();
  List<Products> productList = [];
  List<String> filteredNames = []; // أسماء المنتجات المصفاة حسب البحث
  List<String> productNames = []; // جميع أسماء المنتجات
  final FocusNode _focusNode = FocusNode(); // إنشاء كائن التركيز
  final TextEditingController _controller = TextEditingController();
  bool showLoader = true;
  bool issearch = false;
  List<String> recentSearches = [];
  final SearchHistoryManager searchManager = SearchHistoryManager();

  // Translation maps
  Map<String, String> categoryTranslations = {};
  Map<String, String> subCategoryTranslations = {};
  Map<String, String> productTranslations = {};
  Map<String, String> unitTranslations = {};
  Map<String, String> serviceTypeTranslations = {};
  Map<String, String> wilayaTranslations = {};
  Map<String, String> dairaTranslations = {};

  get applyFilter => null;

  @override
  void initState() {
    super.initState();
    loadSearchHistory();

    // Don't initialize translations in initState, defer to didChangeDependencies
    fetchAllProducts();
    fetchProductNames();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          filteredNames = [];
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize translations here instead of initState
    _initTranslationMaps();
  }

  @override
  void dispose() {
    _focusNode
        .dispose(); // تدمير الـ FocusNode عند انتهاء الصفحة لتجنب استهلاك الذاكرة
    _controller.dispose();
    super.dispose();
  }

  // Initialize all translation maps
  void _initTranslationMaps() {
    // Initialize agricultural product translations
    _initAgriCategoryTranslations();
    _initAnimalProductTranslations();
    _initCommercialProductTranslations();
    _initExpertiseTranslations();
    _initTransportationTranslations();
    _initRepairTranslations();
    _initWilayaAndDairaTranslations();

    // Initialize units translations
    unitTranslations = {
      "كلغ": S.of(context).kg,
      "طن": S.of(context).ton,
      "لتر": S.of(context).liter,
      "صندوق": S.of(context).box,
      "م²": S.of(context).squareMeter,
      "هكتار": S.of(context).hectare,
      "قطعة": S.of(context).piece,
      "مجموعة": S.of(context).set,
      "رأس": S.of(context).head,
      "عبوة": S.of(context).pack,
      "وحدة": S.of(context).unit,
    };

    // Add reverse mapping
    Map<String, String> reverseUnitMap = {};
    unitTranslations.forEach((key, value) {
      reverseUnitMap[value] = key;
    });
    unitTranslations.addAll(reverseUnitMap);

    // Initialize service types translations
    serviceTypeTranslations = {
      "بيع": S.of(context).sell,
      "الإيجار": S.of(context).rent,
    };

    // Add reverse mapping
    serviceTypeTranslations[S.of(context).sell] = "بيع";
    serviceTypeTranslations[S.of(context).rent] = "الإيجار";
  }

  void _initAgriCategoryTranslations() {
    // Map for main agricultural categories
    final arabicMap = ProductData.agriCategories;
    final localizedMap = ProductData.agriCategoriesT(context);

    _mapTranslations(arabicMap, localizedMap, categoryTranslations);

    // Map for subcategories
    final arabicSubMap = ProductData.agriSubCategories;
    final localizedSubMap = ProductData.agriSubCategoriesT(context);

    _mapTranslations(arabicSubMap, localizedSubMap, subCategoryTranslations);
  }

  void _initAnimalProductTranslations() {
    final arabicMap = ProductData.produitsElevages;
    final localizedMap = ProductData.produitsElevagesT(context);

    _mapTranslations(arabicMap, localizedMap, categoryTranslations);

    // Animal products don't have separate subcategories in the provided code
    // So we'll use the same mapping for products
    _mapTranslations(arabicMap, localizedMap, subCategoryTranslations);
  }

  void _initCommercialProductTranslations() {
    final arabicMap = ProductData.commercantCategories;
    final localizedMap = ProductData.commercantCategoriesT(context);

    _mapTranslations(arabicMap, localizedMap, categoryTranslations);

    // Map for equipment subcategories
    final arabicEquipMap = ProductData.equipmentCategories;
    final localizedEquipMap = ProductData.equipmentCategoriesT(context);

    _mapTranslations(
        arabicEquipMap, localizedEquipMap, subCategoryTranslations);
  }

  void _initExpertiseTranslations() {
    final arabicMap = ProductData.ExpertProducts;
    final localizedMap = ProductData.ExpertProductsT(context);

    _mapTranslations(arabicMap, localizedMap, categoryTranslations);
  }

  void _initTransportationTranslations() {
    // Transportation has simple lists, not maps
    final transportCategories = ["نقل المواشي", "نقل المحاصيل", "نقل عام"];
    final localizedTransportCategories = [
      S.of(context).livestockTransport,
      S.of(context).cropTransport,
      S.of(context).generalTransport,
    ];

    for (int i = 0; i < transportCategories.length; i++) {
      if (i < localizedTransportCategories.length) {
        categoryTranslations[transportCategories[i]] =
            localizedTransportCategories[i];
        categoryTranslations[localizedTransportCategories[i]] =
            transportCategories[i]; // Reverse mapping
      }
    }

    // For transport product types
    final arabicTransport = ProductData.moyensDeTransport;
    final localizedTransport = ProductData.moyensDeTransportT(context);

    for (int i = 0; i < arabicTransport.length; i++) {
      if (i < localizedTransport.length) {
        productTranslations[arabicTransport[i]] = localizedTransport[i];
        productTranslations[localizedTransport[i]] =
            arabicTransport[i]; // Reverse mapping
      }
    }
  }

  void _initRepairTranslations() {
    final arabicRepair = ProductData.ReparationType;
    final localizedRepair = ProductData.reparationTypeT(context);

    for (int i = 0; i < arabicRepair.length; i++) {
      if (i < localizedRepair.length) {
        categoryTranslations[arabicRepair[i]] = localizedRepair[i];
        categoryTranslations[localizedRepair[i]] =
            arabicRepair[i]; // Reverse mapping
      }
    }
  }

  void _initWilayaAndDairaTranslations() {
    final arabicMap = ProductData.wilayas;
    final localizedMap = ProductData.wilayasT(context);

    final arabicWilayasList = arabicMap.keys.toList();
    final localizedWilayasList = localizedMap.keys.toList();

    for (int i = 0; i < arabicWilayasList.length; i++) {
      final arabicWilaya = arabicWilayasList[i];
      if (i >= localizedWilayasList.length) continue; // safeguard
      final localizedWilaya = localizedWilayasList[i];

      wilayaTranslations[arabicWilaya] = localizedWilaya;
      wilayaTranslations[localizedWilaya] =
          arabicWilaya; // Bidirectional mapping

      final arabicDairas = arabicMap[arabicWilaya]!;
      final localizedDairas = localizedMap[localizedWilaya]!;

      for (int j = 0; j < arabicDairas.length; j++) {
        if (j >= localizedDairas.length) continue;
        dairaTranslations[arabicDairas[j]] = localizedDairas[j];
        dairaTranslations[localizedDairas[j]] =
            arabicDairas[j]; // Bidirectional mapping
      }
    }
  }

  void _mapTranslations(Map<String, List<String>> arabicMap,
      Map<String, List<String>> localizedMap, Map<String, String> targetMap) {
    // Map main categories
    arabicMap.forEach((arabicKey, arabicValues) {
      String? localizedKey;
      for (var key in localizedMap.keys) {
        // Look for position-based match in translated categories
        int keyIndex = arabicMap.keys.toList().indexOf(arabicKey);
        int matchingLocalizedIndex = localizedMap.keys.toList().indexOf(key);

        if (keyIndex == matchingLocalizedIndex && keyIndex >= 0) {
          localizedKey = key;
          break;
        }
      }

      // Fallback in case we couldn't find a positional match
      localizedKey ??= arabicKey;

      // Add to translation map
      targetMap[arabicKey] = localizedKey;
      targetMap[localizedKey] = arabicKey; // Add reverse mapping

      // Map values (products)
      List<String> localizedValues = localizedMap[localizedKey] ?? [];
      for (int i = 0; i < arabicValues.length; i++) {
        if (i < localizedValues.length) {
          productTranslations[arabicValues[i]] = localizedValues[i];
          productTranslations[localizedValues[i]] =
              arabicValues[i]; // Add reverse mapping
        }
      }
    });
  }

  // Helper function to get localized value from Arabic value
  String getLocalizedValue(
      Map<String, String> translationMap, String arabicValue) {
    return translationMap[arabicValue] ?? arabicValue;
  }

  // Get localized product name
  String getLocalizedProductName(String arabicName) {
    return productTranslations[arabicName] ?? arabicName;
  }

  Future<List<String>> fetchRecommendedProductIds(String userId) async {
    try {
      print("🔍 جاري جلب التوصيات للمستخدم: $userId");

      final response = await http.post(
        Uri.parse('https://recommendation-alfirma.onrender.com/recommend'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      // التحقق من حالة الاستجابة
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // طباعة الاستجابة كاملة للتأكد من محتواها
        print("✅ تم جلب البيانات بنجاح: $data");

        // التحقق من وجود التوصيات
        if (data['recommendations'] != null &&
            data['recommendations'] is List) {
          List<String> recommendedIds =
              List<String>.from(data['recommendations']);

          // طباعة التوصيات المسترجعة
          print("✅ التوصيات المسترجعة: $recommendedIds");

          return recommendedIds;
        } else {
          print("⚠️ لم يتم العثور على توصيات في الرد.");
          return [];
        }
      } else {
        print("❌ فشل في جلب التوصيات - كود الحالة: ${response.statusCode}");
        print("🔁 محتوى الرد: ${response.body}");
        return [];
      }
    } catch (e) {
      print("❌ حدث خطأ أثناء الاتصال بالـ API: $e");
      return [];
    }
  }

  // يستخدم هذا الدالة لجلب المنتجات من Firestore
  Future<void> fetchAllProducts() async {
    try {
      List<Products> allProducts = [];
      List<String> recommendedIds = [];
      // 1. جلب التوصيات أولاً
      if (FirebaseAuth.instance.currentUser != null) {
        recommendedIds = await fetchRecommendedProductIds(
            FirebaseAuth.instance.currentUser!.uid);
      }

      // 2. جلب جميع المنتجات من Firestore
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('item')
          .doc('Products')
          .collection('Products')
          .get();

      // 3. تحويل الوثائق إلى منتجات
      Set<String> seenIds = {}; // لتفادي التكرار
      List<Products> products = productSnapshot.docs.map((doc) {
        Products product = Products.fromFirestore(doc);
        return product;
      }).toList();
      
      // 4. إضافة المنتجات الموصى بها أولاً
      for (String id in recommendedIds) {
        try {
          final product = products.firstWhere((p) => p.id == id);
          if (!seenIds.contains(product.id)) {
            allProducts.add(product);
            seenIds.add(product.id!);
          }
        } catch (e) {
          // لم يتم العثور على المنتج، تجاهل
        }
      }

      // 5. إضافة باقي المنتجات بدون تكرار
      for (final product in products) {
        if (!seenIds.contains(product.id)) {
          allProducts.add(product);
          seenIds.add(product.id!);
        }
      }

      // 6. تحديث الواجهة
      if (mounted) {
        setState(() {
          productList = allProducts;
          showLoader = false;
        });
      }

      print("✅ تم جلب ودمج المنتجات بنجاح (${allProducts.length})");
    } catch (e) {
      print("❌ خطأ أثناء جلب المنتجات والتوصيات: $e");
      if (mounted) {
        setState(() {
          showLoader = false;
        });
      }
    }
  }

  // Function to localize a product
  Products localizeProduct(Products product) {
    // Create a new product with localized fields
    Products localizedProduct = Products(
      id: product.id,
      ownerId: product.ownerId,
      typeItem: product.typeItem,
      category: product.category != null
          ? getLocalizedValue(categoryTranslations, product.category!)
          : null,
      subCategory: product.subCategory != null
          ? getLocalizedValue(subCategoryTranslations, product.subCategory!)
          : null,
      product: product.product != null
          ? getLocalizedValue(productTranslations, product.product!)
          : null,
      quantity: product.quantity,
      surface: product.surface,
      unit: product.unit != null
          ? getLocalizedValue(unitTranslations, product.unit!)
          : null,
      service: product.service != null
          ? getLocalizedValue(serviceTypeTranslations, product.service!)
          : null,
      price: product.price,
      description: product.description,
      comments: product.comments,
      photos: product.photos,
      liked: product.liked,
      disliked: product.disliked,
      date_of_add: product.date_of_add,
      wilaya: product.wilaya != null
          ? getLocalizedValue(wilayaTranslations, product.wilaya!)
          : null,
      daira: product.daira != null
          ? getLocalizedValue(dairaTranslations, product.daira!)
          : null,
      SP: product.SP,
      sell: product.sell,
    );

    return localizedProduct;
  }

  // Function to localize product list after translations are loaded
  void localizeProductList() {
    if (productList.isNotEmpty && categoryTranslations.isNotEmpty) {
      setState(() {
        productList =
            productList.map((product) => localizeProduct(product)).toList();
      });
    }
  }

  Future<void> fetchProductNames() async {
    try {
      // جلب منتجات Agricol
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('item')
          .doc('Products')
          .collection('Products')
          .get();

      // استخراج الأسماء من المجموعتين
      List<String> arabicNames = [
        ...productSnapshot.docs.map(
            (doc) => (doc.data() as Map<String, dynamic>)['product'] as String),
      ];

      if (mounted) {
        setState(() {
          productNames = arabicNames; // We'll localize these later
          filteredNames = []; // لا نعرض اقتراحات في البداية
        });
      }

      debugPrint("✅ تم جلب ${productNames.length} اسم منتج!");
    } catch (e) {
      print("⚠️ خطأ أثناء جلب أسماء المنتجات: $e");
    }
  }

  // Function to localize product names after translations are loaded
  void localizeProductNames() {
    if (productNames.isNotEmpty && productTranslations.isNotEmpty) {
      List<String> localizedNames = productNames.map((arabicName) {
        return getLocalizedProductName(arabicName);
      }).toList();

      setState(() {
        productNames = localizedNames;
      });

      debugPrint("✅ تم ترجمة ${productNames.length} اسم منتج محلي!");
    }
  }

  Widget buildSearchSuggestions() {
    if (!_focusNode.hasFocus) {
      return const SizedBox(); // إذا لم يكن الحقل متركزًا، لا نعرض شيء
    }

    // إذا كان الحقل متركزًا وكان النص فارغ وعندنا عمليات بحث سابقة
    if (_controller.text.isEmpty && recentSearches.isNotEmpty) {
      return SizedBox(
        height: 120,
        child: ListView(
          children: recentSearches
              .map((word) => ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF90D5AE)
                          : const Color(0xFF256C4C),
                    ),
                    title: Text(word),
                    onTap: () async {
                      _controller.text = word;
                      _focusNode.unfocus();
                      await searchManager.addSearch(word);
                      loadSearchHistory();

                      // Search using the word (which could be localized)
                      String searchTerm = word;
                      // Convert localized term to Arabic if it exists in our translation maps
                      String arabicTerm = productTranslations[searchTerm] ??
                          categoryTranslations[searchTerm] ??
                          subCategoryTranslations[searchTerm] ??
                          productTranslations[searchTerm] ??
                          searchTerm;

                      // Execute the search using the Arabic term
                      List<Products> results =
                          await user.searchProducts(arabicTerm);

                      // Localize the search results
                      List<Products> localizedResults = results
                          .map((product) => localizeProduct(product))
                          .toList();

                      setState(() {
                        productList = localizedResults;
                        filteredNames = [];
                      });
                    },
                  ))
              .toList(),
        ),
      );
    }

    // إذا كان في نتائج مفلترة بناءً على النص المدخل
    if (filteredNames.isNotEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 16, 24, 20)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          maxHeight: 170,
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: filteredNames.length,
          itemBuilder: (context, index) {
            return ListTile(
              dense: true, // Make the list tiles more compact
              title: Text(
                filteredNames[index],
                style: TextStyle(fontSize: 16),
              ),
              onTap: () async {
                String searchTerm = filteredNames[index];
                await searchManager.addSearch(searchTerm);
                loadSearchHistory();
                _controller.text = searchTerm;

                // Convert to Arabic for search if it's in our translation maps
                String arabicTerm = productTranslations[searchTerm] ??
                    categoryTranslations[searchTerm] ??
                    subCategoryTranslations[searchTerm] ??
                    searchTerm;

                List<Products> results = await user.searchProducts(arabicTerm);

                // Localize the results
                List<Products> localizedResults =
                    results.map((product) => localizeProduct(product)).toList();

                setState(() {
                  productList = localizedResults;
                  filteredNames = [];
                  _focusNode.unfocus();
                  _controller.clear();
                });
              },
            );
          },
        ),
      );
    }

    return const SizedBox(); // في حال لم تتوفر شروط عرض الاقتراحات
  }

  // ✅ البحث داخل أي جزء من الاسم وعرض الاقتراحات
  void filterNames(String query) {
    if (mounted) {
      setState(() {
        if (query.isEmpty) {
          filteredNames = []; // إخفاء الاقتراحات عند مسح البحث
        } else {
          filteredNames = productNames
              .where((name) => name
                  .toLowerCase()
                  .contains(query.toLowerCase())) // ✅ البحث في أي جزء من الاسم
              .toList();
        }
      });
    }
  }

  //recent search
  void loadSearchHistory() async {
    recentSearches = await searchManager.getSearchHistory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // If translations are loaded and products are available but not localized yet
    if (categoryTranslations.isNotEmpty && productList.isNotEmpty) {
      // Localize products and product names after translations are loaded
      localizeProductList();
      localizeProductNames();
    }

    return GestureDetector(
      onTap: () {
        _focusNode.unfocus(); // إلغاء التركيز عند الضغط خارج TextField
      },
      child: Scaffold(
        body: Column(
          children: [
            if (Users.isGuestUser()) ...[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 247, 234, 117),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      S.of(context).login,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
            ],

            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // ✅ حقل البحث
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      onTap: () {
                        setState(() {
                          _focusNode.hasFocus;
                        });
                      },
                      onChanged: (value) {
                        filterNames(value);
                        setState(() {
                        });
                      },
                      onSubmitted: (value) async {
                        print("✅🔍 بحث عن: $value");
                        await searchManager.addSearch(value);
                        loadSearchHistory();
                        setState(() {
                          issearch = true;
                          showLoader = true;
                          productList = [];
                        });

                        // Convert to Arabic for search if possible
                        String searchTerm = value;
                        String arabicTerm = productTranslations[searchTerm] ??
                            categoryTranslations[searchTerm] ??
                            subCategoryTranslations[searchTerm] ??
                            searchTerm;

                        final results = await user.searchProducts(arabicTerm);

                        // Localize the results
                        List<Products> localizedResults = results
                            .map((product) => localizeProduct(product))
                            .toList();

                        setState(() {
                          productList = localizedResults;
                          showLoader = false;
                        });

                        _controller.clear();
                        _focusNode.unfocus();
                      },
                      focusNode: _focusNode,
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: S.of(context).searchHere,
                        hintStyle: TextStyle(
                          color: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                          fontSize: 17,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(12.0),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF90D5AE)
                                    : const Color(0xFF256C4C),
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? const Color(0xFF90D5AE)
                                : const Color(0xFF256C4C),
                            width: 1.5,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        prefixIcon: Icon(
                          IconlyLight.search,
                          color: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // ✅ زر الفلتر
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: IconButton.filled(
                      onPressed: () async {
                        // فتح الـ bottom sheet وعند الرجوع نلتقط النتيجة
                        final result =
                            await showModalBottomSheet<List<Products>>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            showLoader =
                                false; // تعيين حالة التحميل إلى true عند فتح الـ bottom sheet
                            return DraggableScrollableSheet(
                              initialChildSize: 0.85,
                              maxChildSize: 0.95,
                              minChildSize: 0.5,
                              builder: (context, scrollController) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: const FilterBottomSheet(),
                                );
                              },
                            );
                          },
                        );

                        // إذا كانت النتيجة ليست null وقائمة المنتجات صالحة
                        if (result != null) {
                          // Localize the filtered products
                          List<Products> localizedFilteredProducts = result
                              .map((product) => localizeProduct(product))
                              .toList();

                          setState(() {
                            productList =
                                localizedFilteredProducts; // تحديث قائمة المنتجات بناءً على الفلاتر
                          });
                        }
                      },
                      icon: const Icon(IconlyLight.filter),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ عرض نتائج البحث أو سجل البحث
            buildSearchSuggestions(),

            // ✅ عرض المنتجات
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Padding(
  padding: const EdgeInsets.only(bottom: 25),
  child: SizedBox(
    height: Localizations.localeOf(context).languageCode == 'en' ? 200 : null,
    child: Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 39, 57, 48)
          : Theme.of(context).colorScheme.secondaryContainer,
      elevation: 0.1,
      shadowColor: Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 39, 57, 48)
          : Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ========== TEXT AREA ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).aiScanner,
                    style: const TextStyle(
                      fontSize: 21,
                      color: Color.fromARGB(255, 54, 126, 44),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.of(context).aiDescription,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      if (Users.isGuestUser()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.black),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    S.of(context).aiScannerSignInMessage,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color.fromARGB(255, 247, 234, 117),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDiseaseDetectionPage(),
                          ),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: isDarkMode
                          ? const Color(0xFF90D5AE)
                          : const Color(0xFF256C4C),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                    ),
                    child: Text(
                      S.of(context).checkItOut,
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// ========== IMAGE AREA ==========
            const SizedBox(width: 12),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(
                  Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0,
                  1.0,
                ),
              child: Image.asset(
                'assets/Ai.png',
                height: 200,
                width: 150,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)
,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).featuredProducts,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      // Replace the current TextButton in your code with this implementation
                      TextButton(
                        onPressed: () {
                          // Reset the filter and search states
                          setState(() {
                            showLoader = true;
                            _controller.clear(); // Clear the search field
                            filteredNames =
                                []; // Clear any filtered suggestions
                            issearch = false; // Reset search state
                          });

                          // Fetch all products again without any filters
                          fetchAllProducts();
                        },
                        child: Text(
                          S.of(context).seeAll,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  productList.isEmpty
                      ? showLoader
                          ? const Center(child: CircularProgressIndicator())
                          : Center(child: Text(S.of(context).noProductWithName))
                      : SizedBox(
                          // Changed from Expanded to SizedBox
                          child: GridView.builder(
                            itemCount: productList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              return ItemCard(
                                item: productList[index],
                              );
                            },
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
}
