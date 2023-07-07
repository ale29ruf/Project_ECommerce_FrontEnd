
import 'package:project_ecommerce/model/Model.dart';
import 'package:project_ecommerce/model/objects/Product.dart';

class Communicator {

  static Communicator sharedInstance = Communicator();

  List<Product> listaProdSelected = []; /// Lista di prodotti attualmente selezionati
  late Function _refreshTable;
  List<Product> listaProdInCart = [];
  Map<int,int> listaIdProdInCart = {}; /// Gli oggetti deserializzati differiscono tra loro, dunque mantengo una mappa idProd,qnt dove "qnt" e' la quantità richiesta dall'utente per quel prodotto
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
        if(!listaIdProdInCart.containsKey(p.id)){
          listaProdInCart.add(p);
          listaIdProdInCart[p.id]=1;
          if(Model.sharedInstance.isLogged()){

          }
        }
      }
    }
    listaProdSelected = [];
    caricaProdotti.call();
  }

  void removeAllProdFromCart(){
    listaProdInCart.clear();
    listaIdProdInCart.clear();
  }

  void removeProdFromCart(Product prod){
    listaProdInCart.remove(prod);
    listaIdProdInCart.remove(prod.id);
  }

}