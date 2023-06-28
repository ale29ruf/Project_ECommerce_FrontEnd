extension StringCapitalization on String { //estensione dela classe

  //I seguenti metodi possono essere chiamati su una normale stringa
  String get capitalize => '${this[0].toUpperCase()}${this.substring(1)}'; //upper case della prima lettera
  String get capitalizeFirstOfEach => this.split(" ").map((str) => str.capitalize).join(" ");

}