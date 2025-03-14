import 'package:agriplant/Back_end/Product.dart';
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
  bool showMore = false;
  List<Product> products=List.empty();

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
    return Scaffold(
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
  height: 250, // ارتفاع محدد للحاوية
  width: double.infinity, 
  child: PageView.builder(
    itemCount: widget.product.photos.length, // عدد الصور
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.product.photos[index]), // ✅ عرض جميع الصور
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
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
          Text(
            "Similar Products",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 90,
                  width: 80,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(products[index].photos[0]),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
              separatorBuilder: (__, _) => const SizedBox(
                width: 10,
              ),
              itemCount: products.length,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
              onPressed: () {},
              icon: const Icon(IconlyLight.bag2),
              label: const Text("Add to cart"))
        ],
      ),
    );
  }
}
