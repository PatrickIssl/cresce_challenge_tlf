import 'dart:io';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/discount_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/discount_model.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/product_store.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/product_model.dart';

class DiscountCreatePage extends StatefulWidget {
  final DiscountModel? discount;

  DiscountCreatePage({this.discount});

  @override
  _DiscountCreatePageState createState() => _DiscountCreatePageState();
}

class _DiscountCreatePageState extends State<DiscountCreatePage> {
  final DiscountStore discountStore = Modular.get<DiscountStore>();


  final _formKey = GlobalKey<FormState>();
  final productStore = Modular.get<ProductStore>();

  late TextEditingController discountValueController;
  late TextEditingController itemsRequiredController;
  late TextEditingController itemsPaidController;
  late TextEditingController newPriceController;
  late TextEditingController oldPriceController;
  late TextEditingController activationDateController;
  late TextEditingController inactivationDateController;

  String selectedDiscountType = "PERCENTUAL";
  List<String> discountTypes = ["DE_POR", "PERCENTUAL", "LEVE_PAGUE"];

  File? selectedImage;
  String? imageUrl;
  bool isEditing = false;
  ProductModel? selectedProduct;

  @override
  void initState() {
    super.initState();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    isEditing = widget.discount != null;
    productStore.loadProducts();
    discountValueController = TextEditingController(text: widget.discount?.discountPercentage.toString() ?? "");
    itemsRequiredController = TextEditingController(text: widget.discount?.take?.toString() ?? "");
    itemsPaidController = TextEditingController(text: widget.discount?.pay?.toString() ?? "");
    newPriceController = TextEditingController(text: widget.discount?.newPrice.toString()??"");
    oldPriceController = TextEditingController(text: widget.discount?.oldPrice.toString()??"");

    activationDateController = TextEditingController(
      text: isEditing && widget.discount?.dateActivation != null
          ? dateFormat.format(widget.discount!.dateActivation)
          : "",
    );

    inactivationDateController = TextEditingController(
      text: isEditing && widget.discount?.dateInactivation != null
          ? dateFormat.format(widget.discount!.dateInactivation)
          : "",
    );
    if (widget.discount != null && discountTypes.contains(widget.discount!.type)) {
      selectedDiscountType = widget.discount!.type;
    }
    imageUrl = widget.discount?.image;

    try {
      selectedProduct = productStore.products.firstWhere(
            (product) => product.id.toString() == widget.discount?.productId,
      );
    } catch (e) {
      selectedProduct = null; // Caso o produto não seja encontrado
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        imageUrl = null;
      });
    }
  }

  void _saveDiscount() {
    if (_formKey.currentState!.validate()) {
      if (selectedProduct == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selecione um produto")),
        );
        return;
      }

      final newDiscount = DiscountModel(
        id: isEditing ? widget.discount!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        productId: selectedProduct!.id.toString(),
        type: selectedDiscountType,
        oldPrice: double.tryParse(oldPriceController.text) ?? 0.0,
        newPrice: double.tryParse(newPriceController.text) ?? 0.0,
        discountPercentage: double.tryParse(discountValueController.text) ?? 0.0,
        take: int.tryParse(itemsRequiredController.text),
        pay: int.tryParse(itemsPaidController.text),
        dateActivation: DateFormat('dd/MM/yyyy').parse(activationDateController.text),
        dateInactivation: DateFormat('dd/MM/yyyy').parse(inactivationDateController.text),
        image: imageUrl ?? selectedProduct!.imageUrl,
        status: true,
      );

      if (isEditing) {
        discountStore.updateDiscount(newDiscount);
      } else {
        discountStore.addDiscount(newDiscount);
      }

      Modular.to.navigate('/discounts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Editar Desconto" : "Cadastro Desconto"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Produto"),
            Observer(
              builder: (_) {
                return DropdownButtonFormField<ProductModel>(
                  isExpanded: true, // 🔹 Evita overflow horizontal
                  value: selectedProduct,
                  onChanged: (value) {
                    setState(() {
                      selectedProduct = value!;
                      imageUrl = selectedProduct!.imageUrl;
                    });
                  },
                  items: productStore.products.map((product) {
                    return DropdownMenuItem(
                      value: product,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                );
              },
            ),
              SizedBox(height: 12),

              Text("Tipo do desconto"),
              DropdownButtonFormField<String>(
                value: selectedDiscountType,
                onChanged: (value) {
                  setState(() {
                    selectedDiscountType = value!;
                  });
                },
                items: discountTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.toUpperCase()));
                }).toList(),
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),

              _buildDynamicFields(),

              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: _buildDatePickerField("Data ativação", activationDateController)),
                  SizedBox(width: 12),
                  Expanded(child: _buildDatePickerField("Data inativação", inactivationDateController)),
                ],
              ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                    image: selectedImage != null
                        ? DecorationImage(image: FileImage(selectedImage!), fit: BoxFit.cover)
                        : imageUrl != null
                        ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: selectedImage == null && imageUrl == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 50, color: Colors.grey.shade700),
                      SizedBox(height: 8),
                      Text("Clique para enviar", style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _saveDiscount,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            isEditing ? "Atualizar" : "Salvar",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicFields() {
    if (selectedDiscountType == "DE_POR") {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: oldPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Preço "DE"',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: newPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Preço "POR"',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
    } else if (selectedDiscountType == "PERCENTUAL") {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: newPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Preço',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: discountValueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Porcentagem de desconto',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
    } else if (selectedDiscountType == "LEVE_PAGUE") {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: itemsRequiredController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Leve",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: itemsPaidController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Pague",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: discountValueController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Preço",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

}


