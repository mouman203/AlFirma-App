import 'package:agriplant/models/product.dart'; // import Product class
import 'package:agriplant/widgets_UI/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';




class ExplorePage1 extends StatefulWidget {
  @override
  _ExplorePage1State createState() => _ExplorePage1State();
}

class _ExplorePage1State extends State<ExplorePage1> {
  List<Product> products = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String hintText = "Search here...";
  bool showCursor = false; // للتحكم في ظهور المؤشر |

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _focusNode.addListener(() {
      setState(() {
        hintText = _focusNode.hasFocus ? "" : "Search here...";
        showCursor = _focusNode.hasFocus; // إظهار المؤشر فقط أثناء التركيز
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // يستخدم هذا الدالة لجلب المنتجات من Firestore
Future<void> fetchProducts() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Products').get();

    if (querySnapshot.docs.isEmpty) {
      print("⚠️ لا توجد منتجات في Firestore!");
    }

    List<Product?> fetchedProducts = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // تحقق مما إذا كانت جميع الحقول موجودة قبل استخدامها
      if (!data.containsKey('name') || 
          !data.containsKey('description') || 
          !data.containsKey('image') || 
          !data.containsKey('price') || 
          !data.containsKey('unit') || 
          !data.containsKey('rating')) {
        print("⚠️ المستند ${doc.id} يفتقد بعض الحقول!");
        return null; // إهمال المستند إذا كان غير مكتمل
      }

      return Product(
        name: data['name'],
        description: data['description'],
        image: data['image'],
        price: (data['price'] is num) ? data['price'].toDouble() : double.tryParse(data['price'].toString()) ?? 0.0,
        unit: data['unit'],
        rating: (data['rating'] is num) ? data['rating'].toDouble() : double.tryParse(data['rating'].toString()) ?? 0.0,
      );
    }).where((product) => product != null).toList().cast<Product>(); // إزالة العناصر الفارغة

    setState(() {
      products = fetchedProducts.cast<Product>(); // تحديث المنتجات
    });

    debugPrint("✅ تم جلب ${products.length} منتج!");
  } catch (e) {
    print("⚠️ خطأ أثناء جلب المنتجات: $e");
  }
}

 
 
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      showCursor: true, // التحكم في ظهور المؤشر |
                      decoration: InputDecoration(
                        hintText: hintText,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(12.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(99)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(99)),
                        ),
                        prefixIcon: const Icon(IconlyLight.search),
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          showCursor = false; // إخفاء المؤشر | بعد الكتابة
                        });
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          showCursor = false; // إخفاء المؤشر عند فقدان التركيز
                        });
                      },
                      onChanged: (text) {
                        if (text.isEmpty) {
                          setState(() {
                            hintText = "Search here...";
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: IconButton.filled(
                        onPressed: () {}, icon: const Icon(IconlyLight.filter)),
                  ),
                ],
              ),
            ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: SizedBox(
                  height: 170,
                  child: Card(
                    color: Colors.green.shade50,
                    elevation: 0.1,
                    shadowColor: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Free consultation",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.green.shade700,
                                      ),
                                ),
                                const Text(
                                    "Get free support from our customer service"),
                                FilledButton(
                                  onPressed: () {},
                                  child: const Text("Call now"),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            'assets/contact_us.png',
                            width: 140,
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
             products.isEmpty
              ? const Center(child: CircularProgressIndicator()) // عرض مؤشر التحميل أثناء الجلب
              : GridView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.87,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}