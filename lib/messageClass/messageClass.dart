
 class Messages {
  final String text;
  final String? receiverId;
  final String? senderEmail;
  final String? senderId;
  final String? receiverEmail;
  Messages({required this.text,  this.receiverEmail,  this.senderId,  this.receiverId, this.senderEmail});
  Map<String, dynamic> toMap (){
    return {
      "senderId" : senderId,
      "message": text,
      "receiverId": receiverId,
      "receiverEmail": receiverEmail,
      "senderEmail": senderEmail
    };
  }
 }
