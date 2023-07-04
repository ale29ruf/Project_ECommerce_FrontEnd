
import '../Model.dart';
import '../objects/Product.dart';

class SearchBarCommunicator{ /// La classe si occupa di fornire i suggerimenti alla SearchBar invocando chiamate a procedura remota verso il server

  static SearchBarCommunicator sharedInstance = SearchBarCommunicator();
  List<Product> innerProducts = [];
  late List<bool> selectedRow;

  late List<Product> outerProducts; /// Lista di prodotti del DataTableProduct
  late Function refreshTable; /// Funzione di refresh del DataTableProduct
  late Function showBanner; /// Funzione del DataTableProduct per mostrare un pop-up contenente il messaggio

  void setListOfProduct(List<Product> prodotti){ /// Il metodo serve per settare la lista di prodotti usata dalla classe DataTableProduct, in modo da poterla cambiare e far visualizzare il prodotto cercato
    outerProducts = prodotti;
  }

  void showResultOn(String nameProd){
    _caricaProdottoByName(nameProd);
  }

  void setDataTableRefresh(Function function) {
    refreshTable = function;
  }

  void setShowBanner(Function showBanner) {
    this.showBanner = showBanner;
  }

  Future<List<Product>?> _caricaProdottoByName(String nameProd) async {
    List<Product>? product;
    try{
      product = await Model.sharedInstance.searchProduct(nameProd);
    } catch(e) {
      return null;
    }

    if(product!.isEmpty){
      showBanner.call("Prodotto richiesto non trovato");
      return null;
    }

    innerProducts = product;
    outerProducts.clear();
    selectedRow.clear(); /// Necessario dato che solitamente viene modificata all'interno del metodo _caricaProdotti di DataTableProduct che in questo non viene invocato perchè si utilizza un'altro metodo per effettuare l'invocazione a funzione

    outerProducts.add(innerProducts.first);
    selectedRow.add(false);

    refreshTable.call();
    return product;
  }

  void setListOfProductBool(List<bool> selectedRow) {
    this.selectedRow = selectedRow;
  }

}