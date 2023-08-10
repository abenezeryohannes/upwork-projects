import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linko/src/application/chat/chat.controller.dart';
import 'package:linko/src/domain/chat/entities/chat.entity.dart';
import 'package:linko/src/infrastructure/chat/dtos/chat.dto.dart';
import 'package:linko/src/presentation/chat/widgets/chat.app.bar.dart';
import 'package:linko/src/presentation/chat/widgets/chat.bottom.dart';
import 'package:linko/src/presentation/chat/widgets/chat.list.dart';
import '../../../injectable/getit.dart';
import '../../appcore/network/api.dart';
import '../../appcore/widgets/text.input.form.dart';
import 'package:linko/src/presentation/chat/widgets/linko.anime.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../auth/pages/auth.page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController controller;
  late IO.Socket socket;
  TextInputForm? textInputForm;
  ChatBottom? _bottomChat;

  @override
  void initState() {
    controller = getIt<ChatController>();
    controller.scrollController = ScrollController();
    controller.findUser(local: true);
    Future.delayed(const Duration(seconds: 4), () => controller.findAll());
    initSocket();
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    controller.scrollController.dispose();
    super.dispose();
  }

  initSocket() {
    socket = IO.io(Api.socketHostUrl(), <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket', 'polling'],
      'query': {'limit': 25, 'page': controller.page.value}
    });

    if (socket.io.options != null) {
      socket.io.options!['extraHeaders'] = {
        'authorization': GetStorage().read('token') ?? ''
      };
    }

    socket.connect();
    socket.onConnect((_) {
      // print('Connection established');
    });
    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));

    final uid = GetStorage().read('UID');
    if (uid != null) {
      socket.on(uid, (data) {
        ChatEntity chat = ChatEntity.fromJson(jsonDecode(data));
        if (mounted) {
          setState(() {
            if (chat.sender?.id == controller.user.value?.id &&
                chat.data == controller.text.value) controller.text.value = '';
            {
              _bottomChat?.clear();
            }
            controller.chatList.insert(0, chat);
          });
        }
      });
    }
  }

  sendMessage(ChatDto message) {
    socket.emit('sendMessage', message);
  }

  @override
  Widget build(BuildContext context) {
    _bottomChat ??= bottomChat();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(alignment: Alignment.center, children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Obx(() => AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: controller.chatList.isEmpty ? 1 : 0.1,
                      child: const LinkoAnime()))),
            ),
          ),
          SizedBox.expand(
            // height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(() => SizedBox(
                    height: 70,
                    child: ChatAppBar(
                      user: controller.user.value,
                    ))),
                Expanded(
                    child: Obx(() => ChatList(
                          controller: controller.scrollController,
                          chatList: controller.chatList,
                          isAllLoaded: controller.allLoaded(),
                          onLoadMoreChat: () => controller.findAll(
                              id: controller.chatList.isEmpty
                                  ? null
                                  : controller.chatList.last.id),
                        ))),
                Container(
                    constraints: const BoxConstraints(
                      minHeight: 80,
                    ),
                    child: _bottomChat!)
              ],
            ),
          ),
        ]),
      ),
    );
  }

  ChatBottom bottomChat() {
    return ChatBottom(sendMessage: (cDto) {
      print("chat token${GetStorage().read('token')}");
      if (FirebaseAuth.instance.currentUser == null ||
          GetStorage().read('token') == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AuthPage(onAuthentication: () {
                      Get.offAll(const ChatPage());
                    })));
      } else {
        if (cDto.data == null || cDto.data!.trim().isEmpty) return;
        sendMessage(ChatDto(
            senderID: controller.user.value?.id ?? -1, data: cDto.data));
      }
    });
  }
}
