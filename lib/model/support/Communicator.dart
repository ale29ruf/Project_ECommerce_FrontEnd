
import 'package:project_ecommerce/model/objects/Product.dart';

class Communicator {

  static Communicator sharedInstance = Communicator();

  List<Product> listaProdSelected = []; //lista di prodotti attualmente selezionati
  late Function _refreshTable;
  List<Product> listaProdInCart = [];
  List<int> listaIdProdInCart = []; //gli oggetti deserializzati differiscono tra loro
  late Future<List<Product>?> Function() caricaProdotti;

  void addProd(Product product){
    if(!listaProdSelected.contains(product)) {
      listaProdSelected.add(product);
    }
    _refreshTable.call();
  }

  void removeProd(Product product){
    listaProdSelected.remove(product);
    _refreshTable.call();
  }

  void setDataTableRefresh(Function function) {
    _refreshTable = function;
  }

  void setCaricaProdotti(Future<List<Product>?> Function() caricaProdotti) {
    this.caricaProdotti = caricaProdotti;
  }

  void putProdInCart(bool addSelected) { ///Se addSelected e' true allora gli elementi selezionati vengono aggiunti al carrello, se e' false allora vengono ignorati
    if(addSelected){
      for(Product p in listaProdSelected) {
        if(!listaIdProdInCart.contains(p.id)){
          listaProdInCart.add(p);
          listaIdProdInCart.add(p.id);
        }
      }
    }
    listaProdSelected = [];
    caricaProdotti.call();
  }


  void removeProdFromCart(Product prod){
    listaProdInCart.remove(prod);
    listaIdProdInCart.remove(prod.id);
  }



}