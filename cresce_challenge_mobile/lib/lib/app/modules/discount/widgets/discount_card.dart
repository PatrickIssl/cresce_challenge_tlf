import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/discount_store.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/product_store.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/discount_model.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class DiscountCard extends StatefulWidget {
  DiscountModel discount;

  DiscountCard({required this.discount});

  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  final ProductStore productStore = Modular.get<ProductStore>();

  @override
  Widget build(BuildContext context) {
    ProductModel? product = productStore.getProductById(widget.discount.productId);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.discount.image!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image_not_supported, size: 70);
                    },
                  ),
                ),
                SizedBox(width: 12),

                // 🔹 Informações do Produto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product!.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Desconto: ${widget.discount.type}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 Switch Customizado
                Align(
                  alignment: Alignment.topRight,
                  child: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: widget.discount.status,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.blue.shade700, // Cor do fundo quando ativado
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.blue.shade200, // Cor do fundo quando desativado
                      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                      onChanged: (value) {
                        setState(() {
                          widget.discount = widget.discount.copyWith(status: value); // Atualiza localmente
                        });
                        Modular.get<DiscountStore>().updateDiscountStatus(widget.discount.id, value); // Atualiza no store
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Remove espaçamento extra
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // 📌 Linha de Datas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateColumn("Data ativação", DateFormat('dd/MM/yyyy').format(widget.discount.dateActivation)),
                _buildDateColumn("Data Inativação", DateFormat('dd/MM/yyyy').format(widget.discount.dateInactivation)),
              ],
            ),
            SizedBox(height: 12),

            // 📌 Botão "Ver desconto"
            Divider(),
        TextButton(
          onPressed: () {
            Modular.to.pushNamed('/discounts/detail', arguments: widget.discount);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ver desconto",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4),
              Icon(Icons.remove_red_eye_outlined, size: 18),
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }

  // 🔹 Função para criar colunas de datas
  Widget _buildDateColumn(String title, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          date,
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}
