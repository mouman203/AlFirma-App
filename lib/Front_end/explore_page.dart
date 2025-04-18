import 'package:agriplant/Back_end/Product.dart';
import 'package:agriplant/Back_end/ProductAgri.dart';
import 'package:agriplant/Back_end/ProductElev.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Filter/filter_bottom_sheet.dart';
import 'package:agriplant/Search/SearchHistoryManager%20.dart';
import 'package:agriplant/widgets_UI/product_card.dart';
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
  List<Product> productList = [];
  List<String> filteredNames = []; // أسماء المنتجات المصفاة حسب البحث
  List<String> productNames = []; // جميع أسماء المنتجات
  final FocusNode _focusNode = FocusNode(); // إنشاء كائن التركيز
  final TextEditingController _controller = TextEditingController();
  bool showLoader = true;
  bool issearch = false;
  List<String> recentSearches = [];
  final SearchHistoryManager searchManager = SearchHistoryManager();

  get applyFilter => null;

  @override
  void initState() {
    super.initState();
    loadSearchHistory();
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
  void dispose() {
    _focusNode.dispose(); // تدمير الـ FocusNode عند انتهاء الصفحة لتجنب استهلاك الذاكرة
    _controller.dispose();
    super.dispose();
  }

  // يستخدم هذا الدالة لجلب المنتجات من Firestore
  Future<void> fetchAllProducts() async {
    try {
      List<Product> allProducts = [];

      // جلب منتجات الزراعة
      QuerySnapshot agricolSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .doc('Agricol_products')
          .collection('Agricol_products')
          .get();

      List<Product> agricolProducts = agricolSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Productagri(
          id: doc.id,
          ownerId: data["ownerId"],
          name: data['name'] ?? '',
          typeProduct: data["typeProduct"] ?? "AgricolProduct",
          description: data['description'] ?? '',
          photos: (data['photos'] is List)
              ? List<String>.from(data['photos'])
              : ["assets/nophoto.png"],
          price: (data['price'] is num)
              ? data['price'].toDouble()
              : double.tryParse(data['price'].toString()) ?? 0.0,
          unite: data['unite'] ?? 'DA',
          category: data['category'] ?? '',
          rate: (data['rate'] is num)
              ? data['rate'].toInt()
              : int.tryParse(data['rate'].toString()) ?? 0,
          comments: (data['comments'] is List)
              ? List<Map<String, dynamic>>.from(data['comments'])
              : [],
          liked:
              (data["liked"] is List) ? List<String>.from(data["liked"]) : [],
          disliked: (data["disliked"] is List)
              ? List<String>.from(data["disliked"])
              : [],
          date_of_add: data["date_of_add"] != null && data["date_of_add"] is Timestamp
              ? (data["date_of_add"] as Timestamp).toDate()
              : DateTime.now(),

          type: data['type'],
          produit: data['produit'],
          quantite: data['quantite'],
          surface: data['surface'],
          wilaya: data['wilaya'],
          daira: data['daira'],
        );
      }).toList();

      allProducts.addAll(agricolProducts);

      // جلب منتجات المربين
      QuerySnapshot eleveurSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .doc('Eleveur_products')
          .collection('Eleveur_products')
          .get();
          

      List<Product> eleveurProducts = eleveurSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // إنشاء الكائن ProductElev
        return ProductElev(
          id: doc.id,
          ownerId: data["ownerId"],
          name: data['name'] ?? '',
          typeProduct: data['typeProduct'] ?? "EleveurProduct",
          description: data['description'] ?? '',
          photos: (data['photos'] is List)
              ? List<String>.from(data['photos'])
              : ["assets/nophoto.png"],
          price: (data['price'] is num)
              ? data['price'].toDouble()
              : double.tryParse(data['price'].toString()) ?? 0.0,
          category: data['category'] ?? '',
          rate: (data['rate'] is num)
              ? data['rate'].toInt()
              : int.tryParse(data['rate'].toString()) ?? 0,
          comments: (data['comments'] is List)
              ? List<Map<String, dynamic>>.from(data['comments'])
              : [],
          liked:
              (data["liked"] is List) ? List<String>.from(data["liked"]) : [],
          disliked: (data["disliked"] is List)
              ? List<String>.from(data["disliked"])
              : [],
          date_of_add: data["date_of_add"] != null && data["date_of_add"] is Timestamp
          ? (data["date_of_add"] as Timestamp).toDate()
          : DateTime.now(),
          produit: data['produit'],
          quantite: data['quantite'],
          wilaya: data['wilaya'],
          daira: data['daira'],
        );
      }).toList();
      
      allProducts.addAll(eleveurProducts);

      // تحديث الحالة
      if (mounted) {
        setState(() {
          productList = allProducts; // products لازم تكون معرفها في state
        });
      }

      print("✅ تم جلب جميع المنتجات بنجاح (${allProducts.length})");
    } catch (e) {
      print("❌ خطأ أثناء جلب المنتجات: $e");
    }
  }

  Future<void> fetchProductNames() async {
  try {
    // جلب منتجات Agricol
    QuerySnapshot agricolSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc('Agricol_products')
        .collection('Agricol_products')
        .get();

    // جلب منتجات Eleveur
    QuerySnapshot eleveurSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc('Eleveur_products')
        .collection('Eleveur_products')
        .get();

    // استخراج الأسماء من المجموعتين
    List<String> names = [
      ...agricolSnapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String),
      ...eleveurSnapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String),
    ];

    if (mounted) {
      setState(() {
        productNames = names;
        filteredNames = []; // لا نعرض اقتراحات في البداية
      });
    }

    debugPrint("✅ تم جلب ${productNames.length} اسم منتج من كلا المجموعتين!");
  } catch (e) {
    print("⚠️ خطأ أثناء جلب أسماء المنتجات: $e");
  }
}

  
  Widget buildSearchSuggestions() {
    if (!_focusNode.hasFocus) {
      return const SizedBox(); // إذا لم يكن الحقل متركزًا، لا نعرض شيء
    }

    // إذا كان الحقل متركزًا وكان النص فارغ وعندنا عمليات بحث سابقة
    if (_controller.text.isEmpty && recentSearches.isNotEmpty) {
      return SizedBox(
        height: 200,
        child: ListView(
          children: recentSearches.map((word) => ListTile(
            leading: const Icon(Icons.history),
            title: Text(word),
            onTap: () async {
              _controller.text = word;
              _focusNode.unfocus();
              await searchManager.addSearch(word);
              loadSearchHistory();
              List<Product> results = await user.searchProducts(word);
              setState(() {
                productList = results;
                filteredNames = [];
              });
            },
          )).toList(),
        ),
      );
    }

    // إذا كان في نتائج مفلترة بناءً على النص المدخل
    if (filteredNames.isNotEmpty) {
      return SizedBox(
        height: 200, // تأكد من تحديد ارتفاع لتجنب overflow
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: filteredNames.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredNames[index]),
                onTap: () async {
                  await searchManager.addSearch(filteredNames[index]);
                  loadSearchHistory();
                  _controller.text = filteredNames[index];
                  List<Product> results = await user.searchProducts(filteredNames[index]);
                  setState(() {
                    productList = results;
                    filteredNames = [];
                    _focusNode.unfocus();
                    _controller.clear();
                  });
                },
              );
            },
          ),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus(); // إلغاء التركيز عند الضغط خارج TextField
      },
      child: Scaffold(
        body: Column(
          children: [
                    // ✅ البحث والفلتر
                    // ✅ شريط البحث والفلتر
                    
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // ✅ حقل البحث
                          Expanded(
                            child: TextField(
                              textInputAction: TextInputAction.search,
                              onTap:() {
                                setState(() {
                                  _focusNode.hasFocus;
                                });
                              },
                              onChanged: filterNames,
                              onSubmitted: (value) async {
                                print("✅🔍 بحث عن: $value");
                                await searchManager.addSearch(value);
                                loadSearchHistory();
                                setState(() {
                                  issearch = true;
                                  showLoader = true;
                                  productList = [];
                                });

                                final results = await user.searchProducts(value);

                                setState(() {
                                  productList = results;
                                  showLoader = false;
                                });

                                _controller.clear();
                                _focusNode.unfocus();
                              },
                              focusNode: _focusNode,
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: "Search here",
                                isDense: true,
                                contentPadding: const EdgeInsets.all(12.0),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(99)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                  borderRadius: const BorderRadius.all(Radius.circular(99)),
                                ),
                                prefixIcon: const Icon(IconlyLight.search),
                              ),
                            ),
                          ),

                          // ✅ زر الفلتر
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: IconButton.filled(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return DraggableScrollableSheet(
                                      initialChildSize: 0.85,
                                      maxChildSize: 0.95,
                                      minChildSize: 0.5,
                                      builder: (context, scrollController) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: const FilterBottomSheet(),
                                        );
                                      },
                                    );
                                  },
                                );
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
                              height: 170,
                              child: Card(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(
                                        255, 39, 57, 48) // Dark green for dark mode
                                    : Theme.of(context)
                                        .colorScheme
                                          .secondaryContainer, // Light green for light mode
                                  elevation: 0.1,
                                  shadowColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color.fromARGB(
                                        255, 39, 57, 48) // Match shadow to dark green
                                    : Theme.of(context).colorScheme.secondaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Free AI Scanner",
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  color:
                                                      Color.fromARGB(255, 47, 114, 38),
                                                  fontWeight: FontWeight
                                                      .bold // Black in light mode
                                                  ),
                                            ),
                                            const Text(
                                                "Get free Look from our AI Plant Disease Detector",
                                                style: TextStyle(fontSize: 14)),
                                            FilledButton(
                                              onPressed: () {},
                                              child: Text("Check it out",
                                                  style: TextStyle(
                                                      color: isDarkMode
                                                          ? const Color.fromARGB(
                                                              255, 0, 0, 0)
                                                          : const Color.fromARGB(
                                                              255, 255, 255, 255),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/Ai.png',
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Featured Products",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text("See all"),
                              ),
                            ],
                          ),
                          productList.isEmpty
                              ? issearch
                                          ? showLoader
                                                    ? const Center(child: CircularProgressIndicator())
                                                    : const Center(child: Text("There is not a product with this name"))
                                          : const Center(child: Text("There are not products yet"))
                              : Expanded(
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
                                      return ProductCard(product: productList[index]);
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
