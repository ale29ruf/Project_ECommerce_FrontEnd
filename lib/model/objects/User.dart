class User {
  int? id;
  String? username;
  String? codFiscale;
  String? firstName;
  String? lastName;
  String? telephoneNumber;
  String? email;
  String? address;
  String? password;
  String? message;

  //required indica che il campo è obbligatorio. Se il campo è opzionale allora potrebbe essere null, quindi si mette vicino al tipo della variabile d'istanza il '?'
  //Se la variabile è opzionale, allora possiamo usarla mettendo subito dopo il nome o '?' o '!'. Se mettiamo '!' allora indichiamo che la variabile non puo' mai essere
  //nulla, se usiamo invece '?' allora significa che la variabile potrebbe essere nulla.

  User({this.id, this.username, this.codFiscale, this.firstName, this.lastName, this.telephoneNumber, this.email, this.address, this.password, this.message});

  factory User.fromJson(Map<String, dynamic> json) {
    User u = User(
      id: json['id'],
      username: json['username'],
      codFiscale: json['codFiscale'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      telephoneNumber: json['telephoneNumber'],
      email: json['email'],
      address: json['address'],
      password: json['password'],
      message: json['message'],
    );
    return u;
  }

  Map<String, dynamic> toJson() => {
    'id': id, //Attenzione: l'id dell'utente viene ignorato dal server quando lo riceve
    'username': username,
    'codFiscale': codFiscale,
    'firstName': firstName,
    'lastName': lastName,
    'telephoneNumber': telephoneNumber,
    'email': email,
    'address': address,
    'password': password,
  };

  bool hasError() {
    return message != null;
  }

  @override
  String toString() {
    return "$username $email";
  }


}