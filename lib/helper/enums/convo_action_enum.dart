import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:for_you/providers/message_providers.dart';
import 'package:provider/provider.dart';
import '../utils.dart';
import '../../models/conversation.dart';
// import '../../ui/screens/add_contact_screen.dart';
// import '../../ui/screens/message_details_screen.dart';

enum ConversationActions {
  ///For performing delete action
  DELETE,

  ///For showing details
  // DETAILS,

  ///For performing archive action
  ARCHIVE,

  ///For showing help/FAQ
  HELP,

  ///For performing add contact action
  // ADD_CONTACT,
}

extension ConversationActionExtension on ConversationActions {
  String get name => describeEnum(this);

  void actionOnConversation(BuildContext context, convo) {
    switch (this) {
      ///Deletes this conversation, pops route and shows toast
      case ConversationActions.DELETE:
        {
          final msgManger = context.read<MessagesProvider>();
          msgManger.deleteConversation(convo);
          Navigator.of(context).pop();
          Future.delayed(Duration(milliseconds: 300)).then(
            (value) => Utils.showFlushBar(
              context,
              "Conversation with ${convo.sender.name} deleted",
              Icons.delete,
            ),
          );
          return;
        }

      ///Archives this conversation, pops route and shows toast
      case ConversationActions.ARCHIVE:
        {
          final msgManger = context.read<MessagesProvider>();
          msgManger.toggleArchiveConvo(convo);
          Navigator.of(context).pop();
          Future.delayed(Duration(milliseconds: 300)).then(
            (value) => Utils.showFlushBar(
              context,
              "Conversation with ${convo.sender.name} archived",
              Icons.delete,
            ),
          );
          return;
        }

      ///Redirects to help page. UNIMPLEMENTED
      case ConversationActions.HELP:
        {
          //go to help page
          return;
        }

      ///Redirects to message details screen
      // case ConversationActions.DETAILS:
      //   {
      //     final convo = context.read<Conversation>();
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (ctx) => ChangeNotifierProvider.value(
      //           value: convo,
      //           child: MessageDetailsScreen(),
      //         ),
      //       ),
      //     );
      //     return;
      //   }

      ///Redirects to add contact screen
      // case ConversationActions.ADD_CONTACT:
      //   {
      //     final convo = context.read<Conversation>();
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (ctx) => ChangeNotifierProvider.value(
      //           value: convo,
      //           child: AddContactScreen(),
      //         ),
      //       ),
      //     );
      //     return;
      //   }
    }
  }
}