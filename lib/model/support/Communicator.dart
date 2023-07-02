
import 'package:project_ecommerce/model/objects/Product.dart';

class Communicator {

  static Communicator sharedInstance = Communicator();
  List<Product> listaProdSelected = [];
  late Function _refreshTable;

  void addProd(Product product){
    listaProdSelected.add(product);
    _refreshTable.call();
  }

  void removeProd(Product product){
    listaProdSelected.remove(product);
    _refreshTable.call();
  }

  void setDataTableRefresh(Function function) {
    _refreshTable = function;
  }



}