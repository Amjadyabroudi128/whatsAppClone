
 class Messages {
  final String text;
  final bool isme;
  Messages({required this.text, required this.isme});

 }

 List<Messages> messages = [
   Messages(text: "hello", isme: true),
   Messages(text: "how are you", isme: false),
   Messages(text: "good and you", isme: true),
 ];