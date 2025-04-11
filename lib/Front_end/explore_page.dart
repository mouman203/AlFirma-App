import 'package:agriplant/Back_end/Product.dart';
import 'package:agriplant/Back_end/ProductAgri.dart';
import 'package:agriplant/Back_end/ProductElev.dart';
import 'package:agriplant/front_end/filter_bottom_sheet.dart';
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
    List<Product> productIdList = [];
    List<String> filteredNames = []; // أسماء المنتجات المصفاة حسب البحث
    List<String> productNames = []; // جميع أسماء المنتجات
    final FocusNode _focusNode = FocusNode(); // إنشاء كائن التركيز
    final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
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

    List<Productagri> agricolProducts = agricolSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Productagri(
        id: doc.id,
        ownerId: data["ownerId"],
        name: data['name'] ?? '',
        typeProduct:data["typeProduct"]??"AgricolProduct",
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
        liked: (data["liked"] is List)
            ? List<String>.from(data["liked"])
            : [],
        disliked: (data["disliked"] is List)
            ? List<String>.from(data["disliked"])
            : [],
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

List<ProductElev> eleveurProducts = eleveurSnapshot.docs.map((doc) {
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
    liked: (data["liked"] is List)
        ? List<String>.from(data["liked"])
        : [],
    disliked: (data["disliked"] is List)
        ? List<String>.from(data["disliked"])
        : [],
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
        productIdList = allProducts; // products لازم تكون معرفها في state
      });
    }

    print("✅ تم جلب جميع المنتجات بنجاح (${allProducts.length})");

  } catch (e) {
    print("❌ خطأ أثناء جلب المنتجات: $e");
  }
}





  Future<void> fetchProductNames() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Products').get();

      if (querySnapshot.docs.isEmpty) {
        print("⚠️ لا توجد منتجات في Firestore!");
      }

      List<String> names = querySnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
          .toList();
      if(mounted){
      setState(() {
        productNames = names;
        filteredNames = []; // في البداية، لا يتم عرض أي اقتراحات
      });
      }
      debugPrint("✅ تم جلب ${productNames.length} اسم منتج!");
    } catch (e) {
      print("⚠️ خطأ أثناء جلب أسماء المنتجات: $e");
    }
  }

  // ✅ البحث داخل أي جزء من الاسم وعرض الاقتراحات
  void filterNames(String query) {
    if(mounted){
    setState(() {
      if (query.isEmpty) {
        filteredNames = []; // إخفاء الاقتراحات عند مسح البحث
      } else {
        filteredNames = productNames
            .where((name) =>
                name.toLowerCase().contains(query.toLowerCase())) // ✅ البحث في أي جزء من الاسم
            .toList();
      }
    });
    }
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
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 10),
              child: Row(
                children: [
                 Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      onChanged: (value) => filterNames(value), // ✅ تحديث الاقتراحات
                      onSubmitted: (value) {
                        print("✅🔍 بحث عن: $value");
                        _controller.clear();
 
                      },
                      focusNode: _focusNode, // تحديد الـ FocusNode
                      controller: _controller,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: "Search here",
                        isDense: true,
                        contentPadding: const EdgeInsets.all(12.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(
                            Radius.circular(99),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(99),
                          ),
                        ),
                        prefixIcon: const Icon(IconlyLight.search),
                      ),
                    ),
                  ),
                 
                 
                 Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: IconButton.filled(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15), // ✅ شكل مستدير للحواف
                                  ),
                                  //content: FilterBottomSheet(onApplyFilter: applyFilter), // ✅ مكون داخلي لعرض الفلاتر
                                );
                              },
                            );

                        }, icon: const Icon(IconlyLight.filter)),
                  ),
                ],
              ),
            ),
            
            // ✅ عرض الاقتراحات
             if (filteredNames.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 10),
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
                        shrinkWrap: true,
                        itemCount: filteredNames.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(filteredNames[index]),
                            onTap: () {
                              _controller.text = filteredNames[index]; // ✅ اختيار الاسم
                              setState(() {
                                filteredNames = []; // إخفاء القائمة بعد الاختيار
                              });
                            },
                          );
                        },
                      ),
                    ),
            
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
                    ? const Color.fromARGB(255, 55, 72, 56) // Dark green for dark mode
                    : Colors.green.shade50, // Light green for light mode
                elevation: 0.1,
                shadowColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 55, 72, 56)  // Match shadow to dark green
                    : Colors.green.shade50,
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
                                  color: Color.fromARGB(255, 47, 114, 38),
                                  fontWeight:
                                      FontWeight.bold // Black in light mode
                                  ),
                                    ),
                                    const Text(
                              "Get free Look from our AI Plant Disease Detector",
                              style: TextStyle(fontSize: 14)),
                              FilledButton(
                              onPressed: () {},
                              child: Text("Check it out",
                                  style: TextStyle(
                                      color: isDarkMode ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 255, 255, 255),
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
                  productIdList.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                        child: GridView.builder(
                          
                            itemCount: productIdList.length,
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
                              return ProductCard(product: productIdList[index]);
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