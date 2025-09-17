                     import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/layouts/listvew.dart';
import '../../controllers/messages/chats_controller.dart';
import '../../controllers/messages/read_chat_controller.dart';
import '../../controllers/services/user_id_controller.dart';
import '../../controllers/user/user_controller.dart';
import '../../utils/constants/custom_colors.dart';
import 'components/chat_shimmer.dart';
import 'widgets/message_preview.dart';
import '../../utils/constants/sizes.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatState();
}

class _ChatState extends ConsumerState<ChatScreen> {
  bool isLoading = true;
  bool isRefreshing = false;
  String? currentUserId;
  final UserIdService userIdService = UserIdService();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      Future.microtask(() {
        if (!mounted) return;
        ref.read(chatsProvider.notifier).fetchChats();
      });
    });
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    final userId = await userIdService.getCurrentUserId();
    if (!mounted) return;
    setState(() {
      currentUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final readChatController = ref.read(readChatsProvider.notifier);
    final chatController = ref.watch(chatsProvider);
    final userState = ref.watch(userProvider);

    return SafeArea(
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            'Messages',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: userState.when(
          data: (user) => RefreshIndicator(
            onRefresh: () async {
              setState(() => isRefreshing = true);
              await ref.read(chatsProvider.notifier).fetchChats();
              setState(() => isRefreshing = false);
            },
            child: Column(
              children: [
                if (isRefreshing) ChatShimmer(),
                const SizedBox(height: Sizes.spaceBtwItems),
                Center(
                  child: Text(
                    'Messages are end to end encrypted.',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwItems),

                /// Sort chats: newest first
                chatController.isEmpty
                    ? Center(
                        child: Text(
                          'No Messages',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                        child: Builder(
                          builder: (context) {
                            final sortedChats = [...chatController];
                            sortedChats.sort(
                              (a, b) => b.updatedAt.compareTo(a.updatedAt),
                            );

                            return HomeListView(
                              scrollDirection: Axis.vertical,
                              seperatorBuilder: (context, index) =>
                                  const SizedBox(height: Sizes.sm),
                              itemCount: sortedChats.length,
                              itemBuilder: (context, index) {
                                final chats = sortedChats[index];
                                final backgroundColor =
                                    Color(int.parse(chats.color));

                                String avatar = chats.senderImage;
                                String sender = chats.senderName;

                                if (chats.senderId == currentUserId) {
                                  avatar = chats.receiverImage;
                                  sender = chats.receiverName;
                                } else if (chats.receiverId == currentUserId) {
                                  avatar = chats.senderImage;
                                  sender = chats.senderName;
                                }

                                return GestureDetector(
                                  onTap: () async {
                                    await readChatController.readChat(
                                      context,
                                      chats.senderId,
                                      chats.receiverId,
                                      currentUserId!,
                                      sender,
                                      avatar,
                                      chats.participants,
                                    );
                                  },
                                  child: MessagePreview(
                                    avatar: avatar,
                                    sender: sender,
                                    messageText: chats.lastMessage,
                                    backgroundColor:
                                        chats.senderId != currentUserId
                                            ? backgroundColor
                                            : Colors.transparent,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
          loading: () => const ChatShimmer(),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              children: [
                const SizedBox(height: 200),
                Text(
                  'Could not load screen. Please check your internet connection',
                  style: Theme.of(context).textTheme.labelMedium,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: CustomColors.primary,
                    padding: const EdgeInsets.all(Sizes.sm),
                  ),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isRefreshing = true;
                    });
                    ref.invalidate(userProvider);
                    ref.invalidate(chatsProvider);
                    setState(() {
                      isRefreshing = false;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}