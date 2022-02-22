import 'package:baby_names/app/models/scopedmodels/cart_model.dart';
import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/views/pages/MeusPedidos/meus_pedidos_page.dart';
import 'package:baby_names/app/views/pages/MinhaConta/minha_conta_page.dart';
import 'package:baby_names/app/views/pages/carrinhoPage/carrinho_page.dart';
import 'package:baby_names/app/views/pages/home/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.green);

    return ScopedModel<UserModel>(
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return ScopedModel<CartModel>(
              model: CartModel(user: model),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    scaffoldBackgroundColor: Colors.white,
                    primarySwatch: Colors.green,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    textTheme: GoogleFonts.aBeeZeeTextTheme(
                        Theme.of(context).textTheme)),
                home: MyHome(),
              ),
            );
          },
        ));
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _actualPos = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            _actualPos = value;
          },
          controller: _pageController,
          children: [MyHomePage(), MeusPedidoPage(), MinhaContaPage()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CarrinhoPage()));
          },
          child: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          opacity: .2,
          elevation: 8,
          currentIndex: _actualPos,
          onTap: (p) {
            setState(() {
              _pageController.jumpToPage(p);
            });
          },
          fabLocation: BubbleBottomBarFabLocation.end,
          hasInk: true,
          hasNotch: true,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          inkColor: Colors.green,
          items: [
            BubbleBottomBarItem(
                backgroundColor: Colors.green,
                icon: Icon(
                  Icons.home,
                  color: Colors.grey[500],
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: Colors.green,
                ),
                title: Text("Home")),
            BubbleBottomBarItem(
                backgroundColor: Colors.green,
                icon: Icon(
                  Icons.list,
                  color: Colors.grey[500],
                ),
                activeIcon: Icon(
                  Icons.list,
                  color: Colors.green,
                ),
                title: Text("Meus Pedidos")),
            BubbleBottomBarItem(
                backgroundColor: Colors.green,
                icon: Icon(
                  Icons.person,
                  color: Colors.grey[500],
                ),
                activeIcon: Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                title: Text("Minha Conta")),
          ],
        ));
  }
}
