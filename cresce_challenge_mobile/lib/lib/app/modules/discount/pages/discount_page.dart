import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/discount_store.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/product_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../widgets/discount_card.dart';

class DiscountPage extends StatefulWidget {
  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  final ProductStore productStore = Modular.get();
  final DiscountStore discountStore = Modular.get();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await productStore.loadProducts();
      await discountStore.loadDiscounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Descontos"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade300,
            height: 1,
          ),
        ),
      ),
      body: Observer(
        builder: (_) {
        if (productStore.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (productStore.products.isEmpty) {
          return Center(child: Text("Nenhum produto encontrado."));
        }
        if (discountStore.discounts.isEmpty) {
          return Center(child: Text("Nenhum desconto cadastrado."));
        }
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: discountStore.discounts.length,
          itemBuilder: (_, index) {
            final discount = discountStore.discounts[index];
            return DiscountCard(discount: discount);
          },
        );
      },
      ),
      bottomNavigationBar: Container(
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
            onPressed: () {
              Modular.to.pushNamed('/discounts/create');
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Cadastrar desconto",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
