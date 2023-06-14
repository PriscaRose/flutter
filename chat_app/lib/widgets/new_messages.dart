import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() {
    return _NewMessages();
  }
}

class _NewMessages extends State<NewMessages> {
  final _msgController =  TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _submitMsg() async {
    final enteredMsg = _msgController.text;

    if(enteredMsg.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus(); // Unfocus the input message
    _msgController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    FirebaseFirestore.instance.collection('chat').add({
     'text': enteredMsg,
     'createdAt': Timestamp.now(),
     'userId': user.uid,
     'username': userData.data()!['username'],
     'imageUrl': userData.data()!['image_url'],
    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
           Expanded(
            child: TextField(
              controller: _msgController ,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(label: Text('Send a message')),
            ),
          ),
          IconButton(
            onPressed: _submitMsg,
            icon: const Icon(
              Icons.send,
            ),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
