import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/discount_store.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/product_store.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/discount_model.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'discount_create_page.dart';

class DiscountDetailPage extends StatefulWidget {
  final DiscountModel discount;

  DiscountDetailPage({required this.discount});

  @override
  _DiscountDetailPageState createState() => _DiscountDetailPageState();
}

class _DiscountDetailPageState extends State<DiscountDetailPage> {
  late DiscountModel currentDiscount;
  late ProductStore productStore;
  late DiscountStore discountStore;
  ProductModel? product;

  @override
  void initState() {
    super.initState();
    currentDiscount = widget.discount;
    productStore = Modular.get<ProductStore>();
    discountStore = Modular.get<DiscountStore>();
    product = productStore.getProductById(currentDiscount.productId);
  }

  void _updateStatus(bool value) {
    discountStore.updateDiscountStatus(currentDiscount.id, value);
  }

  void _navigateToEditPage() async {
    final updatedDiscount = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscountCreatePage(discount: currentDiscount),
      ),
    );

    if (updatedDiscount != null && mounted) {
      setState(() {
        currentDiscount = updatedDiscount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhe do desconto"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade300,
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: currentDiscount.status,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.blue.shade700,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.blue.shade200,
                  onChanged: (value) {
                    setState(() {
                      currentDiscount = currentDiscount.copyWith(status: value);
                    });
                    Modular.get<DiscountStore>().updateDiscountStatus(currentDiscount.id, value);
                  },
                ),
              ),
            ),

            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  currentDiscount.image!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported, size: 100);
                  },
                ),
              ),
            ),
            SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  currentDiscount.discountLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "R\$ ${currentDiscount.type == "PERCENTUAL"? (currentDiscount.newPrice- ((currentDiscount.newPrice * currentDiscount.discountPercentage )/100)).toStringAsFixed(2): currentDiscount.newPrice}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),

                currentDiscount.type != "LEVE_PAGUE"
                    ? Text(
                  currentDiscount.type == "PERCENTUAL"? "R\$ ${(currentDiscount.newPrice).toStringAsFixed(2)}": "R\$ ${(currentDiscount.oldPrice).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 12),

            Text(
              product!.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8),

            Text(
              product!.description,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),

            Spacer(),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToEditPage,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Editar desconto",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
