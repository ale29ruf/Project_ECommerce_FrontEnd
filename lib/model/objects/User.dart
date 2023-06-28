class User {
  String username;
  String code;
  String firstName;
  String lastName;
  String telephoneNumber;
  String email;
  String address;
  String password;

  //required indica che il campo è obbligatorio. Se il campo è opzionale allora potrebbe essere null, quindi si mette vicino al tipo della variabile d'istanza il '?'
  //Se la variabile è opzionale, allora possiamo usarla mettendo subito dopo il nome o '?' o '!'. Se mettiamo '!' allora indichiamo che la variabile non puo' mai essere
  //nulla, se usiamo invece '?' allora significa che la variabile potrebbe essere nulla.

  User({required this.username, required this.code, required this.firstName, required this.lastName, required this.telephoneNumber, required this.email, required this.address, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      code: json['code'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      telephoneNumber: json['telephoneNumber'],
      email: json['email'],
      address: json['address'],
      password: json['password']
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'code': code,
    'firstName': firstName,
    'lastName': lastName,
    'telephoneNumber': telephoneNumber,
    'email': email,
    'address': address,
    'password': password
  };

  @override
  String toString() {
    return "$username $email";
  }


}