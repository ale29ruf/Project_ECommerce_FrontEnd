class Message{
  String message;

  Message({required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    Message u = Message(
      message: json['message'],
    );
    return u;
  }

  Map<String, dynamic> toJson() => {
    'message': message,
  };

  @override
  String toString() {
    return "message: $message";
  }
}