
import 'package:project_ecommerce/model/Model.dart';
import 'package:project_ecommerce/model/objects/Message.dart';
import 'package:project_ecommerce/model/objects/Product.dart';

import '../objects/ProductInPurchase.dart';

class Communicator {

  static Communicator sharedInstance = Communicator();


  late Function _refreshTable;
  late Future<List<Product>?> Function() caricaProdotti;

  List<Product> listaProdSelected = []; /// Lista di prodotti attualmente selezionati
  List<ProductInPurchase> listaPipInCart = []; /// Rappresenta il carrello locale
  List<int> listIdProdInCart = []; /// Gli oggetti deserializzati differiscono tra loro, dunque mantengo una mappa idProd,Product
  bool mergeCart = false; /// La merge del carrello locale con quello remoto avviene una sola volta, ovvero quando il client prima aggiunge dei prodotti nel carrello e poi si logga

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

  /// Necessaria per il cambio utente
  void reset(){
    mergeCart = false;
    listaPipInCart = [];
    listIdProdInCart = [];
    listaProdSelected = [];
  }

  Future<String> putProdInCart() async { ///Se addSelected e' true allora gli elementi selezionati vengono aggiunti al carrello, se e' false allora vengono ignorati
    if(!Model.sharedInstance.isLogged()){
      for(Product p in listaProdSelected) {
        if(!listIdProdInCart.contains(p.id)){
          listaPipInCart.add(ProductInPurchase(id: -1, quantity: 1, price: p.price, product: p));
          listIdProdInCart.add(p.id);
        }
      }
    } else {
      for(Product p in listaProdSelected) {
        Message? esito = await Model.sharedInstance.addProductToCart(p.id);
        if (esito == null) {
          return "CONNECTION_ERROR";
        } else if (esito.message != "OK") {
          return esito.message;
        }
        if(!listIdProdInCart.contains(p.id)){
          listIdProdInCart.add(p.id);
        }
      }
    }
    listaProdSelected = [];
    caricaProdotti.call();
    return "OK";
  }

  Future<String> visualizeCart() async {
    if(Model.sharedInstance.isLogged()){
      if(!mergeCart){
        Message? response = await Model.sharedInstance.addAllProductToCart(listaPipInCart); /// Aggiungo gli eventuali prodotti al carrello back-end
        if(response == null || response.message != "OK") return response!.message;
      }
      mergeCart = true;
      List<ProductInPurchase>? pipJustDownloaded = await Model.sharedInstance.getCart(); /// Riscarico tutti i prodotti dal carrello back-end
      if(pipJustDownloaded == null) return "CONNECTION_ERROR";
      listaPipInCart = pipJustDownloaded;
      listIdProdInCart.clear();
    }
    listaProdSelected = [];
    return "OK";
  }

  Future<String> removeAllProdFromCart() async {
    if(Model.sharedInstance.isLogged()) {
      Message? esito = await Model.sharedInstance.removeAllProductFromCart();
      if (esito == null) {
        return "CONNECTION_ERROR";
      } else if (esito.message != "OK") {
        return esito.message;
      }
    }
    listaPipInCart.clear();
    listIdProdInCart.clear();
    return "OK";
  }

  Future<String> removeProdFromCart(ProductInPurchase pip) async {
    if(Model.sharedInstance.isLogged()){
      Message? esito = await Model.sharedInstance.removeProductFromCart(pip.id);
      if (esito == null) {
        return "CONNECTION_ERROR";
      } else if (esito.message != "OK") {
        return esito.message;
      }
    }
    listaPipInCart.remove(pip);
    listIdProdInCart.remove(pip.product.id);
    return "OK";
  }

  Future<String> plusProductOfCart(ProductInPurchase pip) async {
    if(Model.sharedInstance.isLogged()){
      Message? esito = await Model.sharedInstance.plusProductOfCart(pip.id);
      if (esito == null) {
        return "CONNECTION_ERROR";
      } else if (esito.message != "OK") {
        return esito.message;
      }
    }
    pip.quantity++;
    return "OK";
  }

  Future<String> minusProductOfCart(ProductInPurchase pip) async {
    if(Model.sharedInstance.isLogged()){
      Message? esito = await Model.sharedInstance.plusProductOfCart(pip.id);
      if (esito == null) {
        return "CONNECTION_ERROR";
      } else if (esito.message != "OK") {
        return esito.message;
      }
    }
    pip.quantity--;
    return "OK";
  }

}