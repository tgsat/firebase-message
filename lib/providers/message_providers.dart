import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:for_you/services/firestore_db.dart';


import '../helper/utils.dart';

import '../models/contact.dart';
import '../models/conversation.dart';
import '../models/message.dart';

class MessagesProvider with ChangeNotifier {

  /// Instance of firestore database
  FirestoreDatabase? _firestoredb = FirestoreDatabase.instance;

  /// Initializes and loads the data for the logged in user
  init() {
    _initializeDefaults();
    _initializeData();
  }

  //initialise with firestore
  Map<String, Conversation>? _conversations;
  Map<String, Conversation>? _groups;
  List<Conversation>? _spammedConversations;
  List<Conversation>? _archivedConversations;
  List<Conversation>? _spammedGroups;
  List<Conversation>? _archivedGroups;
  List<Conversation>? _selectedConversations;
  List<Message>? _favMessages;
  bool? _displayGroupConversations;

  /*final Map<String, Conversation> _conversations = {
    "03009756562": Conversation(
      sender: Contact(number: "03009756562", name: "Meeran",avClr: Colors.blue),
      messages: [
        Message(
          number: "03009756562",
          body: "Where are u ??",
          datetime: DateTime.now(),
        ),
        Message(
          number: "03009756562",
          body: "What time you'll come home?",
          datetime: DateTime.now(),
        ),
      ],
    ),
    "03339657568": Conversation(
      sender: Contact(number: "03339657568",avClr: Colors.red),
      messages: [
        Message(
          number: "03339657568",
          body: "First Message",
          datetime: DateTime.now(),
        ),
        Message(
          number: "03339657568",
          body: "Second Message",
          datetime: DateTime.now(),
        ),
      ],
    ),
    "03309677784": Conversation(
      sender: Contact(name: "Faryal",number: "03309677784",avClr: Colors.blue),
      messages: [
        Message(
          number: "03309677784",
          body: "First Message",
          datetime: DateTime.now(),
        ),
        Message(
          number: "03309677784",
          body: "Check the timetable and update when free",
          datetime: DateTime.now(),
        ),
      ],
    ),
    "03012668889": Conversation(
      sender: Contact(number: "03012668889", name: "Zain",avClr: Colors.amber),
      messages: [
        Message(
          number: "03012668889",
          body: "Where are u ??",
          datetime: DateTime.now(),
        ),
        Message(
          number: "03012668889",
          body: "What time you'll come home?",
          datetime: DateTime.now(),
        ),
      ],
    ),
    "03028220488": Conversation(
      sender: Contact(name: "Farhan",number: "03028220488",avClr: Colors.red),
      messages: [
        Message(
          number: "03028220488",
          body: "First Message",
          datetime: DateTime.now(),
          previewPath: "hello"
        ),
        Message(
          number: "03028220488",
          body: "Second Message",
          datetime: DateTime.now(),
        ),
      ],
    ),
  };
  final Map<String, Conversation> _groups = {
    "echo1":Conversation(
      sender: Contact(name: "Farhan",number: "03028220488",avClr: Colors.red),
      groupID: "echo1",
      messages: <Message>[
        Message(
            number: "03028220488",
            body: "First Message",
            datetime: DateTime.now(),
            previewPath: "hello"
        ),
        Message(
          number: "03028220488",
          body: "Second Message",
          datetime: DateTime.now(),
        ),
      ],
      groupName: "BOYS",
      isGroup: true,
      participants: <Contact>[
        Contact(name: "Asad",number: "03028199488",avClr: Colors.blue)
      ]
    )
  };*/

  /// Internal method to initialize all variables for the logged in user
  void _initializeDefaults() {
    _conversations = Map();
    _groups = Map();
    _selectedConversations = [];
    _archivedConversations = [];
    _spammedGroups = [];
    _archivedGroups = [];
    _selectedConversations = [];
    _favMessages = [];
    _displayGroupConversations = false;
  }

  /// Returns true if you want to view groups
  bool get displayGroupConversations => _displayGroupConversations!;

  /// Returns an unmodifiable map of all conversation with sender number
  /// as keys
  UnmodifiableMapView<String, Conversation> get conversationsMap =>
      UnmodifiableMapView(_conversations!);

  /// Returns an unmodifiable list of all normal conversations
  UnmodifiableListView<Conversation> get conversations =>
      UnmodifiableListView(_conversations!.values);

  /// Returns an unmodifiable list of all selected conversation or groups
  UnmodifiableListView<Conversation> get selectedConversations =>
      UnmodifiableListView(_selectedConversations!);

  /// Returns an unmodifiable list of all favourite messages of a user
  UnmodifiableListView<Message> get favMsgs =>
      UnmodifiableListView(_favMessages!);

  /// Returns an unmodifiable list of all spammed conversations
  UnmodifiableListView<Conversation> get spammedConversations =>
      UnmodifiableListView(_spammedConversations!);

  /// Returns an unmodifiable list of all archived individual conversation
  UnmodifiableListView<Conversation> get archivedConversations =>
      UnmodifiableListView(_archivedConversations!);

  /// Returns an unmodifiable list of all spammed groups
  UnmodifiableListView<Conversation> get spammedGroups =>
      UnmodifiableListView(_spammedGroups!);

  /// Returns an unmodifiable list of all archived groups
  UnmodifiableListView<Conversation> get archivedGroups =>
      UnmodifiableListView(_archivedGroups!);

  /// Returns an unmodifiable map of groups with groupIDs as keys
  UnmodifiableMapView<String, Conversation> get groupsMap =>
      UnmodifiableMapView(_groups!);

  /// Returns an unmodifiable list of all normal groups
  UnmodifiableListView<Conversation> get groupsConversations =>
      UnmodifiableListView(_groups!.values);

  /// Returns true if a conversation is selected
  bool isSelected(Conversation convo) => _selectedConversations!.contains(convo);

  /// Internal method to load all data for logged in user
  void _initializeData() {
    _initializeConversationsMap();
    _initializeSpammedConversations();
    _initializeArchivedConversations();
    _initializeArchivedGroups();
    _initializeSpammedGroups();
    _initializeGroupsMap();
  }

  /// Fetches a stream of normal group conversations from database
  /// and adds them the groups map with groupID as key.
  void _initializeGroupsMap() {
    _firestoredb!.normalGroupsStream().listen((tempGroups) {
      tempGroups.forEach((group) => _groups![group.groupID] = group);
      notifyListeners();
    });
  }

  /// Fetches a stream of normal individual conversations from database
  /// and adds them the conversations map with sender number as key.
  void _initializeConversationsMap() {
    _firestoredb!.normalStream().listen((tempConversations) {
      tempConversations.forEach((convo) {
         _conversations![convo.sender!.number!] = convo;
      });
      notifyListeners();
    });
  }

  /// Fetches a stream of spammed individual conversations from database
  /// and sets them to the spammed convos list.
  void _initializeSpammedConversations() {
    _firestoredb!.spammedStream().listen((spammedConvos) {
      _spammedConversations = spammedConvos;
      notifyListeners();
    });
  }

  /// Fetches a stream of archived individual conversations from database
  /// and sets them to the archived convos list.
  void _initializeArchivedConversations() {
    _firestoredb!.archivedStream().listen((archivedConvos) {
      _archivedConversations = archivedConvos;
      notifyListeners();
    });
  }

  /// Fetches a stream of spammed groups from database
  /// and sets them to the spammed groups list.
  void _initializeSpammedGroups() {
    _firestoredb!.spammedGroupsStream().listen((spammedGroups) {
      _spammedGroups = spammedGroups;
      notifyListeners();
    });
  }

  /// Fetches a stream of archived groups from database
  /// and sets them to the archived groups list.
  void _initializeArchivedGroups() {
    _firestoredb!.archivedGroupsStream().listen((archivedGroups) {
      _archivedGroups = archivedGroups;
      notifyListeners();
    });
  }

  /// Switch view mode to group conversations
  void toggleDisplayGroupConvos() {
    _displayGroupConversations = !displayGroupConversations;
    notifyListeners();
  }

  /// Updates the conversations to move recent ones to the top
  void _updateConversionList(Conversation convo) {
    if (convo.isGroup) {
      _groups!.remove(convo.groupID); //remove
      _groups![convo.groupID] =
          convo; //and insert at end to make it appear on top
      _firestoredb!.addOrUpdateGroup(_groups![convo.groupID], merge: true);
    } else {
      _conversations!.remove(convo.sender!.number); //remove
      _conversations![convo.sender!.number!] =
          convo; //and insert at end to make it appear on top
      _firestoredb!.addOrUpdateConversation(_conversations![convo.sender!.number],
          merge: true);
    }
    notifyListeners();
  }

  /// Adds a messaage to the specified conversation and updates the
  /// database. Also updates the conversation for the reciever
  void sendConversationMessages({
    @required Conversation? convo,
    @required String? text,
    @required String? previewPath,
  }) {
    convo!.sendMessage(text: text, previewAsset: previewPath);
    _firestoredb!.addMessages(convo);
    _updateConversionList(convo);
    final number = convo.sender!.number!;
    if (Utils.isPhoneNumber(number)) {
      _firestoredb!.addMessagesToSender(
        convo.copyWith(sender: Conversation.myContact, isRead: false),
        Utils.parsePhoneNo(number),
      );
    }
  }

  /// Marks a conversation as read and updates the database
  void readConversation(Conversation convo) {
    if (convo.isRead) return;
    convo.readConversation();
    _firestoredb!.readConversation(convo);
  }

  /// Marks a group as read and updates the database
  void readGroup(Conversation convo) {
    if (convo.isRead) return;
    convo.readConversation();
    _firestoredb!.readGroup(convo);
  }

  /// Marks all conversations as read and updates the database
  void readAllConversations() {
    _conversations!.values
        .forEach((Conversation convo) => convo.readConversation());
    _firestoredb!.markAllConversationsRead();
  }

  /// Returns the conversation for the given contact,
  /// else creates a new one if it isn't found
  Conversation getConversation(Contact contact) {
    return _conversations![contact.number] ?? _createConversation(contact);
  }

  /// Creates and returns a new group and updates the database
  Conversation createGroupConversation(groupMembers, groupName) {
    Random random = Random();
    String? groupID = random.nextInt(100000).toString();
    _groups![groupID] = Conversation(
      sender: groupMembers[0],
      messages: <Message>[],
      isGroup: groupMembers == null ? false : true,
      groupID: groupID,
      groupName: groupName,
      participants: groupMembers,
    );
    _firestoredb!.addOrUpdateGroup(_groups![groupID], merge: true);
    print(_conversations);
    return _groups![groupID]!;
  }

  /// Creates and returns a new conversation and updates the database
  Conversation _createConversation(Contact? contact) {
    _conversations![contact!.number!] =
        Conversation(sender: contact, messages: <Message>[], isRead: true);
    _firestoredb!.addOrUpdateConversation(_conversations![contact.number],
        merge: true);
    return _conversations![contact.number]!;
  }

  /// Deletes a conversation and updates the database
  void deleteConversation(Conversation convo) {
    if (_conversations!.containsKey(convo.sender!.number))
      _conversations!.remove(convo.sender!.number);
    else if (_archivedConversations!.contains(convo))
      _archivedConversations!.remove(convo);
    else if (_spammedConversations!.contains(convo))
      _spammedConversations!.remove(convo);
    _firestoredb!.deleteConversation(convo);
    notifyListeners();
  }

  /// Deletes a group and updates the database
  void deleteGroup(Conversation group) {
    if (_groups!.containsKey(group.groupID))
      _groups!.remove(group.groupID);
    else if (_archivedGroups!.contains(group))
      _archivedGroups!.remove(group);
    else if (_spammedGroups!.contains(group)) _spammedGroups!.remove(group);
    _firestoredb!.deleteGroup(group);
    notifyListeners();
  }

  /// Deletes the selected conversations one by one
  void deleteSelected() {
    _selectedConversations!
        .forEach((Conversation convo) => deleteConversation(convo));
    clearSelected();
  }

  /// Empties the selected conversations list
  void clearSelected() {
    _selectedConversations!.clear();
    notifyListeners();
  }

  /// Archives/Unarchives the selected conversations or groups
  /// and updates the database.
  void archiveSelected() {
    // If first item is a group conversation, it means all selected are groups
    if (_selectedConversations![0].isGroup) {
      _selectedConversations!.forEach((Conversation group) {
        if (group.isArchived) {
          _archivedGroups!.remove(group);
          _groups![group.groupID] = group;
        } else {
          _groups!.removeWhere((groupID, _) => groupID == group.groupID);
          _archivedGroups!.add(group);
        }
        group.toggleArchived();
      });
      _firestoredb!.toggleArchiveSelectedGroups(_selectedConversations!);
    }
    // else all are individual conversations
    else {
      _selectedConversations!.forEach((Conversation convo) {
        if (convo.isArchived) {
          _archivedConversations!.remove(convo);
          _conversations![convo.sender!.number!] = convo;
        } else {
          _conversations!
              .removeWhere((number, _) => number == convo.sender!.number);
          _archivedConversations!.add(convo);
        }
        convo.toggleArchived();
      });
      _firestoredb!.toggleArchiveSelectedConversations(_selectedConversations!);
    }
    clearSelected();
  }

  /// Spams/Unspams the selected conversations or groups
  /// and updates the database.
  void spamSelected() {
    toggleSpamConvo(_selectedConversations![0]); //bcz only one can be spammed
  }

  /// Marks/Unmarks a conversation or group as selected
  void toggleSelected(Conversation convo) {
    if (isSelected(convo)) _selectedConversations!.remove(convo);
    else _selectedConversations!.add(convo);
    notifyListeners();
  }

  /// Archives/Unarchives a single conversation or group
  /// and updates the database.
  void toggleArchiveConvo(Conversation convo) {
    if (convo.isGroup) {
      if (convo.isArchived) {
        _archivedGroups!.remove(convo);
        _groups![convo.groupID] = convo;
      } else {
        _groups!.removeWhere((groupID, _) => groupID == convo.groupID);
        _archivedGroups!.add(convo);
      }
      convo.toggleArchived();
      _firestoredb!.toggleArchiveSelectedGroups([convo]);
    } else {
      if (convo.isArchived) {
        _archivedConversations!.remove(convo);
        _conversations![convo.sender!.number!] = convo;
      } else {
        _conversations!
            .removeWhere((number, _) => number == convo.sender!.number);
        _archivedConversations!.add(convo);
      }
      convo.toggleArchived();
      _firestoredb!.toggleArchiveSelectedConversations([convo]);
    }
    notifyListeners();
  }

  /// Spams/Unspams a single conversation or group
  /// and updates the database.
  void toggleSpamConvo(Conversation convo) {
    if (convo.isGroup) {
      if (convo.isSpam) {
        _spammedGroups!.remove(convo);
        _groups![convo.groupID] = convo;
      } else {
        _groups!.removeWhere((groupID, _) => groupID == convo.groupID);
        _spammedGroups!.add(convo);
      }
      convo.toggleSpam();
      _firestoredb!.spamSelectedGroup(convo);
    } else {
      if (convo.isSpam) {
        _spammedConversations!.remove(convo);
        _conversations![convo.sender!.number!] = convo;
      } else {
        _conversations!
            .removeWhere((number, converse) => number == convo.sender!.number);
        _spammedConversations!.add(convo);
      }
      convo.toggleSpam();
      _firestoredb!.spamSelectedConversation(convo);
      //Block contact
      _firestoredb!.addOrUpdateContact(convo.sender!, merge: true);
    }
    clearSelected();
  }

  /// Marks/Unmarks a single message as favourite
  /// and updates the database.
  void toggleFavMessage(Message msg) {
    if (msg.isFav)
      _favMessages!.remove(msg);
    else
      _favMessages!.add(msg);
    msg.isFav = !msg.isFav;
    notifyListeners();
  }
}