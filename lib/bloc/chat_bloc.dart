// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'chat_event.dart';
// import 'chat_state.dart';
//
// class ChatSessionBloc extends Bloc<ChatEvent, ChatSessionState> {
//   ChatSessionBloc() : super(ChatSessionState.initial()) {
//     on<ChatEvent>((event, emit) async {
//       if (event is SetChatSessionEvent) {
//         emit(state.update(loading: true));
//
//         try {
//           print("here is blioc");
//
//           // await _setUpChatSession(state);
//
//           print("here is alsoll");
//
//
//           // yield state.update();
//           emit(state.update(docId: event.docId, loading: false, init: false));
//         } catch (error) {
//           emit(state.update(error: 'Error setting up chat: $error'));
//         }
//       }
//     });
//   }
//
//   //
//   // Stream<ChatSessionState> mapEventToState(ChatEvent event) async* {
//   //
//   //   if (event is SetChatSessionEvent) {
//   //     yield state.update(loading: true);
//   //     print("here is blioc");
//   //
//   //     try {
//   //       await _setUpChatSession(state);
//   //
//   //       // yield state.update();
//   //       yield state.update(loading: false);
//   //     } catch (error) {
//   //       yield state.update(error: 'Error setting up chat: $error');
//   //     }
//   //   }
//   // }
//
// //   Future<void> _setUpChatSession(ChatSessionState state) async {
// //     // Logic for setting up chat session in Firestore
// //     print(state.docId);
// //     bool chatExists;
// //     CollectionReference chatSessions =
// //         FirebaseFirestore.instance.collection('chats');
// //     String id = state.docId;
// //     if (state.docId.isEmpty) {
// //       DocumentReference newSessionRef = chatSessions.doc();
// //       id = newSessionRef.id; // Store the generated document ID
// //     }
// //     DocumentSnapshot getDocumentSnapshot =
// //         await FirebaseFirestore.instance.collection('chats').doc(id).get();
// //     chatExists = getDocumentSnapshot.exists;
// //
// //     if (chatExists == false) {
// //       await FirebaseFirestore.instance.collection('chats').doc(id).set({
// //         "sessionId": id,
// //         "createdAt": DateTime.now(),
// //         "endedAt": null,
// //         "messages": []
// //       });
// //       // activeChatDocumentId = newChatDocumentId;
// //       print("aaaaaaa>>>>$id");
// //     }
// //   }
// // }


import 'package:bloc/bloc.dart';

class ChatCubit extends Cubit<String> {
  ChatCubit() : super('');

  void setActiveChatDocumentId(String documentId) {
    emit(documentId);
  }
}