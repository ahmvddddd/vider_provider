import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../controllers/services/user_id_controller.dart';
import '../../../../../screens/service/widgets/services.dart';
import '../../../../../utils/constants/custom_colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../appbar/appbar.dart';
import '../../custom_shapes/containers/button_container.dart';
import '../../custom_shapes/divider/custom_divider.dart';
import '../../layouts/listvew.dart';
import '../../texts/section_heading.dart';

class ServiceProviderScreen extends StatefulWidget {
  final Map profiles;
  const ServiceProviderScreen({super.key, required this.profiles});

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  String? _currentUserId;
  final UserIdService userIdService = UserIdService();

  @override
  void initState() {
    super.initState;
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    final userId = await userIdService.getCurrentUserId();
    setState(() {
      _currentUserId = userId!;
    });
  }

  Future<void> addTransaction() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/newtransaction'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": _currentUserId,
          "providerId": widget.profiles['_id'],
          "amount": 10000,
          "refName":
              '${widget.profiles['firstname']} ${widget.profiles['lastname']}',
          "description": "Payment for gardening services, duration: 2hours",
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('success');
      } else {
        debugPrint(response.body);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstname = widget.profiles['firstname'];
    final lastname = widget.profiles['lastname'];
    final service = widget.profiles['service'];
    final bio = widget.profiles['bio'];
    final skills = widget.profiles['skills'];

    final dark = HelperFunction.isDarkMode(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: ButtonContainer(
          onPressed: addTransaction,
          text: 'Hire',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //body
              Padding(
                padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Sizes.spaceBtwSections),

                    Column(
                      children: [
                        Text(
                          '$firstname $lastname',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          service,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          'rating: 5.0',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          'location: 12, LA Boulevard W2 ABJ',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: Sizes.spaceBtwItems),
                    ElevatedButton(
                      onPressed: () {
                        final selectedUserId = widget.profiles['_id'];
                        final participants = [_currentUserId, selectedUserId];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    Message(participants: participants),
                          ),
                        );
                      },
                      child: Text(
                        'Message',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),

                    //images
                    const CustomDivider(
                      padding: EdgeInsets.all(Sizes.spaceBtwItems),
                    ),

                    HomeListView(
                      sizedBoxHeight: screenHeight * 0.10,
                      scrollDirection: Axis.horizontal,
                      seperatorBuilder: (context, index) {
                        return const SizedBox(width: Sizes.sm);
                      },
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          width: screenHeight * 0.10,
                          height: screenHeight * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Sizes.borderRadiusLg,
                            ),
                          ),
                          child: Image.asset(
                            Images.fashionDesigner,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),

                    const CustomDivider(
                      padding: EdgeInsets.all(Sizes.spaceBtwItems),
                    ),

                    HomeListView(
                      sizedBoxHeight: screenHeight * 0.06,
                      scrollDirection: Axis.horizontal,
                      seperatorBuilder: (context, index) {
                        return const SizedBox(width: Sizes.sm);
                      },
                      itemCount: skills.length,
                      itemBuilder: (context, index) {
                        return Services(service: skills[index]);
                      },
                    ),
                    const CustomDivider(
                      padding: EdgeInsets.all(Sizes.spaceBtwItems),
                    ),

                    Text(bio, style: Theme.of(context).textTheme.labelSmall),

                    const CustomDivider(
                      padding: EdgeInsets.all(Sizes.spaceBtwItems),
                    ),

                    const TSectionHeading(
                      title: 'Certifications',
                      showActionButton: false,
                    ),
                    const SizedBox(height: Sizes.sm),
                    Container(
                      height: screenHeight * 0.055,
                      width: screenWidth * 0.325,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Sizes.borderRadiusMd,
                        ),
                        color:
                            dark
                                ? CustomColors.white.withValues(alpha: 0.1)
                                : CustomColors.black.withValues(alpha: 0.1),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Center(
                        child: Text(
                          'MCFE',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                    const SizedBox(height: Sizes.sm),
                    SizedBox(
                      width: screenWidth * 0.90,
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at nunc tempus, semper nibh nec, lacinia nunc.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: Sizes.sm),
                    Container(
                      height: screenHeight * 0.055,
                      width: screenWidth * 0.325,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Sizes.borderRadiusMd,
                        ),
                        color:
                            dark
                                ? CustomColors.white.withValues(alpha: 0.1)
                                : CustomColors.black.withValues(alpha: 0.1),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Center(
                        child: Text(
                          'CSFP',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                    const SizedBox(height: Sizes.sm),
                    SizedBox(
                      width: screenWidth * 0.90,
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas at nunc tempus, semper nibh nec, lacinia nunc.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message extends StatefulWidget {
  final List<dynamic> participants;
  final String? sentFrom;
  const Message({super.key, required this.participants, this.sentFrom});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final storage = const FlutterSecureStorage();
  final UserIdService userIdService = UserIdService();
  late IO.Socket socket;
  List messages = [];
  final TextEditingController _messageController = TextEditingController();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    initializeMessaging();
  }

  Future<void> initializeMessaging() async {
    await getCurrentUserId();
    setupSocket();
    _fetchMessages();
  }

  Future<void> getCurrentUserId() async {
    final userId = await userIdService.getCurrentUserId();
    setState(() {
      currentUserId = userId;
    });
  }

  void setupSocket() {
    socket = IO.io(
      'http://localhost:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      debugPrint('Connected to Socket.IO server');
      // _fetchMessages();
    });

    socket.onDisconnect((_) {
      debugPrint('Disconnected from Socket.IO server');
      attemptReconnect();
    });

    socket.on('messageHistory', (data) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(data);
      });
    });

    socket.on('receiveMessage', (data) {
      setState(() {
        messages.add(data);
      });
    });

    // Listen for real-time messages
    socket.on('updateMessage', (data) {
      if (data['receiverId'] == currentUserId ||
          data['senderId'] == currentUserId) {
        setState(() {
          messages.add(data);
        });
      }
    });
  }

  void attemptReconnect() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!socket.connected) {
        debugPrint('Attempting to reconnect...');
        socket.connect();
      }
    });
  }

  void _fetchMessages() {
    socket.emit('getMessages', {'participants': widget.participants});
  }

  void sendMessage(String content) {
    if (currentUserId != null && content.isNotEmpty) {
      final receiverId =
          widget.participants[0] == currentUserId
              ? widget.participants[1]
              : widget.participants[0];

      final message = {
        'participants': widget.participants,
        'senderId': currentUserId,
        'receiverId': receiverId,
        'sentFrom': currentUserId,
        'content': content,
      };

      socket.emit('sendMessage', message);

      setState(() {
        messages.add(message);
      });

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text('Chat with ${widget.participants[1]}'),
        showBackArrow: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMine = message['senderId'] == currentUserId;

                return Align(
                  alignment:
                      isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMine ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['content'],
                      style: TextStyle(
                        color: isMine ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
