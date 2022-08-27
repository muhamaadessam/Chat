import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool? isMuhammad = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    String? messageText;

    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/background.jpg',
            //colorBlendMode: BlendMode.screen,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            titleSpacing: 16,
            title: Text(
              'ODC Chat',
              style:
                  GoogleFonts.pacifico(color: Colors.deepOrange, fontSize: 24),
            ),
            // leading: Icon(Icons.arrow_back,color: Colors.deepOrange,),
            leadingWidth: 0,
            // elevation: 1,
            actions: [
              IconButton(
                onPressed: () {
                  isMuhammad = !isMuhammad!;
                  setState(() {});
                  debugPrint('isMuhammad = $isMuhammad');
                },
                icon: Icon(
                  Icons.person,
                  size: 30,
                  color: isMuhammad! ? Colors.deepOrange : Colors.black,
                ),
              ),
            ],
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      fireStore.collection('chat').orderBy('time').snapshots(),
                  builder: (context, snapshot) {
                    List<MessageLine> messageWidgets = [];

                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      final messages = snapshot.data!.docs.reversed;
                      for (var message in messages) {
                        final messageText = message.get('text');
                        final messageSender = message.get('name');
                        final messageWidget = MessageLine(
                          isSender: messageSender,
                          text: messageText,
                        );
                        messageWidgets.add(messageWidget);
                      }
                      return ListView(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        children: messageWidgets,
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.9),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Type Massage',
                                // hintStyle: TextStyle(color: Colors.),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.black),
                              controller: messageController,
                              maxLines: 5,
                              minLines: 1,
                              onChanged: (value) {
                                messageText = value;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.9),
                          borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (messageController.text != '') {
                              fireStore.collection('chat').add({
                                'name':
                                    isMuhammad! ? 'Muhammad Essam' : 'Essam',
                                'text': messageText.toString(),
                                'time': FieldValue.serverTimestamp(),
                                'type': 'sender'
                              });
                            }
                            messageController.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.deepOrange,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({Key? key, this.isSender, this.text}) : super(key: key);

  final String? isSender;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Row(
        mainAxisAlignment: isSender! == 'Muhammad Essam'
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240, minWidth: 10),
            child: Container(
              decoration: BoxDecoration(
                color: isSender! == 'Muhammad Essam'
                    ? Colors.deepOrangeAccent.withOpacity(.9)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft: isSender! == 'Muhammad Essam'
                        ? const Radius.circular(10)
                        : const Radius.circular(0),
                    bottomRight: isSender! == 'Muhammad Essam'
                        ? const Radius.circular(0)
                        : const Radius.circular(10)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: Text(
                  text!,
                  style: GoogleFonts.aBeeZee(
                      color: isSender! == 'Muhammad Essam'
                          ? Colors.white
                          : Colors.black,
                      fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget message(context, {bool? isSender, String? text}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
//     child: Row(
//       mainAxisAlignment:
//           isSender! ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: isSender
//                 ? Colors.deepOrangeAccent.withOpacity(.9)
//                 : Colors.grey.shade200,
//             borderRadius: BorderRadius.only(
//                 topLeft: const Radius.circular(10),
//                 topRight: const Radius.circular(10),
//                 bottomLeft: isSender
//                     ? const Radius.circular(10)
//                     : const Radius.circular(0),
//                 bottomRight: isSender
//                     ? const Radius.circular(0)
//                     : const Radius.circular(10)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
//             child: Text(
//               'Muhammad',
//               style: TextStyle(color: isSender ? Colors.white : Colors.black),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
