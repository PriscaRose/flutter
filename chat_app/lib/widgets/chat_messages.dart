import 'package:chat_app/widgets/message_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (cxt, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No message found'),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Smt went wrong'),
          );
        }

        final loadedMsg = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(left: 13, right: 13, bottom: 40),
          reverse: true,
          itemCount: loadedMsg.length,
          itemBuilder: (ctx, index) {
            final chatMsg = loadedMsg[index].data();
            final nextMsg = index + 1 < loadedMsg.length
                ? loadedMsg[index + 1].data()
                : null;
            final currentMsgUserId = chatMsg['userId'];
            final nextMsgUserId = nextMsg != null ? nextMsg['userId'] : null;
            final nextUserIsSame = nextMsgUserId == currentMsgUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                  message: chatMsg['text'],
                  isMe: authUser!.uid == currentMsgUserId);
            } else {
              return MessageBubble.first(
                  userImage: chatMsg['imageUrl'],
                  username: chatMsg['username'],
                  message: chatMsg['text'],
                  isMe: authUser!.uid == currentMsgUserId);
            }
          },
        );
      },
    );
  }
}
