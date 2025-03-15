import 'package:agriplant/Back_end/Product.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Product%20detaille/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_iconly/flutter_iconly.dart';


class ProductCard extends StatelessWidget {
  final Product product;
  final Users user = Users();

  ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        elevation: 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              alignment: Alignment.topRight,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(product.photos[0]),
                  fit: BoxFit.cover,
                ),
              ),
              child: SizedBox(
                width: 30,
                height: 30,
                child: IconButton.filledTonal(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  iconSize: 18,
                  icon: const Icon(IconlyLight.bookmark),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "\$${product.price}",
                                style: Theme.of(context).textTheme.bodyLarge),
                            TextSpan(
                                text: "/${product.unite}",
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Products')
                  .doc(product.id)
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
                            user.likeProduct(product);
                          },
                        ),
                        Text(
                          "${liked.length}",
                          style: TextStyle(fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark 
                                                                              ? Colors.white 
                                                                              : Colors.black
                          ),
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
                            user.dislikeProduct(product);
                          },
                        ),
                        Text(
                          "${disliked.length}",
                          style: TextStyle(fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark 
                                                                              ? Colors.white 
                                                                              : Colors.black

                        ),
                    )],
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
            )
          ],
        ),
      ),
    );
  }
}
