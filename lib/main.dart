import 'package:flutter/material.dart';
import 'package:inherited_widget_workshop/appstatewidget.dart';

import 'shopping_cart.dart';
import 'data.dart';

import 'product_list.dart';
import 'service.dart';

void main() {
  runApp(
    const AppStateWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Store',
        home: MyStorePage(),
      ),
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

    AppStateWidget.of(context).setProductList(Server.getProductList());
    _controller.clear();
  }

  void _handleSearch() {
    _focusNode.unfocus();
    final String filter = _controller.text;
    AppStateWidget.of(context)
        .setProductList(Server.getProductList(filter: filter));
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
              const ShoppingCartIcon(),
            ],
            backgroundColor: Colors.white,
            pinned: true,
          ),
          const SliverToBoxAdapter(
            child: ProductListWidget(),
          ),
        ],
      ),
    );
  }
}
