abstract class ChatEvent {}

class SetChatSessionEvent extends ChatEvent {
  String docId;

  SetChatSessionEvent({required this.docId});
}
