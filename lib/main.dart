import 'package:flutter/material.dart';

import 'cart.dart';
import 'data.dart';

import 'product.dart';
import 'service.dart';

final GlobalKey<ShoppingCartIconState> shoppingCart =
    GlobalKey<ShoppingCartIconState>();
final GlobalKey<ProductListWidgetState> productList =
    GlobalKey<ProductListWidgetState>();

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store',
      home: MyStorePage(),
    ),
  );
}

class MyStorePage extends StatefulWidget {
  const MyStorePage({Key? key}) : super(key: key);

  @override
  MyStorePageState createState() => MyStorePageState();
}

class MyStorePageState extends State<MyStorePage> {
  bool _inSearch = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _toggleSearch() {
    setState(() {
      _inSearch = !_inSearch;
    });

    _controller.clear();
    productList.currentState!.productList = Server.getProductList();
  }

  void _handleSearch() {
    _focusNode.unfocus();
    final String filter = _controller.text;
    productList.currentState!.productList =
        Server.getProductList(filter: filter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.network('$baseAssetURL/google-logo.png'),
            ),
            title: _inSearch
                ? TextField(
                    autofocus: true,
                    focusNode: _focusNode,
                    controller: _controller,
                    onSubmitted: (_) => _handleSearch(),
                    decoration: InputDecoration(
                      hintText: 'Search Google Store',
                      prefixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _handleSearch),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _toggleSearch),
                    ),
                  )
                : null,
            actions: [
              if (!_inSearch)
                IconButton(
                  onPressed: _toggleSearch,
                  icon: const Icon(Icons.search, color: Colors.black),
                ),
              ShoppingCartIcon(key: shoppingCart),
            ],
            backgroundColor: Colors.white,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: ProductListWidget(key: productList),
          ),
        ],
      ),
    );
  }
}

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  ProductListWidgetState createState() => ProductListWidgetState();
}

class ProductListWidgetState extends State<ProductListWidget> {
  List<String> get productList => _productList;
  List<String> _productList = Server.getProductList();

  set productList(List<String> value) {
    setState(() {
      _productList = value;
    });
  }

  Set<String> get itemsInCart => _itemsInCart;
  Set<String> _itemsInCart = <String>{};

  set itemsInCart(Set<String> value) {
    setState(() {
      _itemsInCart = value;
    });
  }

  void _handleAddToCart(String id) {
    itemsInCart = _itemsInCart..add(id);
    shoppingCart.currentState!.itemsInCart = itemsInCart;
  }

  void _handleRemoveFromCart(String id) {
    itemsInCart = _itemsInCart..remove(id);
    shoppingCart.currentState!.itemsInCart = itemsInCart;
  }

  Widget _buildProductTile(String id) {
    return ProductTile(
      product: Server.getProductById(id),
      purchased: itemsInCart.contains(id),
      onAddToCart: () => _handleAddToCart(id),
      onRemoveFromCart: () => _handleRemoveFromCart(id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: productList.map(_buildProductTile).toList(),
    );
  }
}
