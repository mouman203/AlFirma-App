import 'package:agriplant/Back_end/Product.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Product%20detaille/fullscreanimage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';


class ProductDetailsPage extends StatefulWidget {

   final Product product;
   const ProductDetailsPage({super.key, required this.product});


  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late TapGestureRecognizer readMoreGestureRecognizer;
  final FocusNode _focusNode = FocusNode(); // إنشاء كائن التركيز
  bool showMore = false;
  Users user =Users();
  List<Product> products=List.empty();
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showMore = !showMore;
        });
      };
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      onTapCancel: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Details"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(IconlyLight.bookmark),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
        height: 250, 
        width: double.infinity, 
        child: PageView.builder(
      itemCount: widget.product.photos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImageViewer(
                  photos: widget.product.photos,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.product.photos[index]),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
        ),
      ),
      
            Text(
              widget.product.name ,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available in stock",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: widget.product.price.toString(),
                          style: Theme.of(context).textTheme.titleLarge),
                      TextSpan(
                          text: widget.product.unite,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.yellow.shade800,
                ),
      
                Text(
                  widget.product.rate.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
      
                StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.product.id)
        .snapshots(),
        builder: (context, snapshot) {
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const SizedBox();
      }
      
      List<dynamic> liked = snapshot.data!['liked'] ?? [];
      List<dynamic> disliked = snapshot.data!['disliked'] ?? [];
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";
      bool isLiked = liked.contains(userId);
      bool isDisliked = disliked.contains(userId);
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up,
                    size: 20, color: isLiked ? Colors.blue : Colors.grey),
                onPressed: () {
                  user.likeProduct(widget.product);
                },
              ),
              Text(
                "${liked.length}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(width: 5),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.thumb_down,
                    size: 20, color: isDisliked ? Colors.red : Colors.grey),
                onPressed: () {
                  user.dislikeProduct(widget.product);
                },
              ),
              Text(
                "${disliked.length}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: const Icon(Icons.comment, size: 20, color: Colors.grey),
            onPressed: () {
              print("Comment Clicked!");
            },
          ),
        ],
      );
        },
      ),
      
                
                const Spacer(),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: IconButton.filledTonal(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    iconSize: 18,
                    icon: const Icon(Icons.remove),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "2 ${widget.product.unite}",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: IconButton.filledTonal(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    iconSize: 18,
                    icon: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Description",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
        text: showMore
        ? widget.product.description
        : (widget.product.description.length > 100
            ? '${widget.product.description.substring(0, 100)}...'
            : widget.product.description),
      ),
      
                  TextSpan(
                    recognizer: readMoreGestureRecognizer,
                    text: showMore ? " Read less" : " Read more",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            const SizedBox(height: 20),
            FilledButton.icon(
                onPressed: () {},
                icon: const Icon(IconlyLight.bag2),
                label: const Text("Add to cart")
            ),
      
            SizedBox(
              height: 5,
            ),
           Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  decoration: BoxDecoration(
    color: Color.fromRGBO(254, 247, 255, 255), // نفس لون الحاوية الذي كان في الكود السابق
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 5,
        spreadRadius: 1,
      ),
    ],
  ),
  child: Row(
    children: [
      // أيقونة المستخدم (أول حرف من الاسم)
      CircleAvatar(
        child: Text(
           FirebaseAuth.instance.currentUser?.displayName?.isNotEmpty == true
        ? FirebaseAuth.instance.currentUser?.displayName?.substring(0, 1).toUpperCase() ?? "U"
        : "U",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey, // يمكنك تغيير لون الخلفية هنا
      ),
      SizedBox(width: 10),

      // حقل الإدخال
      Expanded(
        child: TextField(
          focusNode: _focusNode,
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            hintText: "اكتب تعليقًا...",
            border: InputBorder.none,
          ),
        ),
      ),

      // زر الإرسال
      IconButton(
        icon: Icon(Icons.send, color: Colors.green),
        onPressed: () {
          user.addComment(
            widget.product.id,
            FirebaseAuth.instance.currentUser?.uid ?? "guest",
            controller.text,
          );
          controller.clear();
        },
      ),
    ],
  ),
),

             
             
             
             SizedBox(
              height: 20,
            ),
      
      
      
      
      
      
              //bring  the comments from firestore
            StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection('Products')
      .doc(widget.product.id)
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData || !snapshot.data!.exists) {
      return const Center(child: Text("لا توجد تعليقات بعد."));
    }

    var data = snapshot.data!.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> comments = (data['comments'] is List)
        ? List<Map<String, dynamic>>.from(
            (data['comments'] as List).where((comment) =>
                comment is Map<String, dynamic> &&
                comment.containsKey("userId") &&
                comment.containsKey("text")))
        : [];

    if (comments.isEmpty) {
      return const Center(child: Text("لا توجد تعليقات بعد."));
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('Users').get(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        Map<String, String> usersMap = {};
        for (var doc in userSnapshot.data!.docs) {
          usersMap[doc.id] = doc['first_name'] ?? "مستخدم غير معروف";
        }

        return ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: comments.length,
  itemBuilder: (context, index) {
    Map<String, dynamic> comment = comments[index];
    String userId = comment['userId'];
    String username = usersMap[userId] ?? "Unknown User";
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "guest"; // المعرف الحالي للمستخدم

    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(child: Text(username[0].toUpperCase())),
        title: Text(username),
        subtitle: Text(comment['text']),
        trailing: userId == currentUserId // تحقق من إذا كان التعليق يعود للمستخدم الحالي
            ? IconButton(
                icon: Icon(Icons.delete, color:Colors.grey),
                onPressed: () {
                  // استدعاء دالة حذف التعليق بناءً على userId والنص
                  user.deleteComment(
                    widget.product.id,  // معرّف المنتج
                    currentUserId,       // معرّف المستخدم الحالي
                    comment['text'],     // نص التعليق
                  );
                },
              )
            : null, // لا تعرض الأيقونة إذا كان التعليق ليس من قبل المستخدم الحالي
      ),
    );
  },
);

      },
    );
  },
),

      
      
      
      
      
      
      
      
      
          ],
        ),
      ),
    );
  }
}
