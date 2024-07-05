import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/chat.dart';
import 'package:nanyang_application/model/message.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/other/nanyang_loading_dialog.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/chat_viewmodel.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  final ChatModel? model;
  const ChatScreen({super.key, this.model});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  late final UserModel _user;
  late final ToastProvider _toast;
  late final SupabaseStreamBuilder _messageStream;
  late final ChatViewModel _chatViewModel;
  File? file;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthViewModel>().user;
    _toast = context.read<ToastProvider>();
    _chatViewModel = context.read<ChatViewModel>();
    try {
      if (widget.model != null) {
        _messageStream = _chatViewModel.getMessageStream(widget.model!.id)!;
      } else {
        _messageStream = _chatViewModel.getMessageStream(_user.userChatId!)!;
      }
    } catch (e) {
      _toast.showToast('Terjadi kesalahan, silahkan coba lagi', 'error');
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  Future<void> _selectFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);
      setState(() {
        messageController.text = result.files.first.name;
      });
    } else {
      // User canceled the picker
    }
  }

  void _sendMessage({String? message, File? file}) {
    try {
      int chatID = widget.model != null ? widget.model!.id : _user.userChatId!;
      _chatViewModel.sendMessage(chatID, _user.id, _user.isAdmin, meesage: message, file: file);
    } catch (e) {
      _toast.showToast('Terjadi kesalahan, silahkan coba lagi', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: NanyangAppbar(
        title: _user.isAdmin ? widget.model!.user.employee.name.split(' ')[0] : 'Halo, ${_user.employee.name.split(' ')[0]}!',
        isBackButton: true,
        isCenter: true,
        backgroundColor: ColorTemplate.periwinkle,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC0C9FF), Color(0xFF8390DC), Color(0xFF4D5DB7)],
            stops: [0.1, 0.44, 1.0],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8 - keyboardHeight,
              child: Container(
                padding: dynamicPaddingSymmetric(0, 24, context),
                height: double.infinity,
                color: Colors.transparent,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _messageStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Center(
                        child: Container(),
                      );
                    } else if (snapshot.hasData) {
                      final messages = MessageModel.fromSupabaseList(snapshot.data!);
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildChatBubble(context, messages[index], _user);
                        },
                      );
                    } else {
                      return const Center(
                        child: NanyangLoadingDialog(),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Container(
                margin: dynamicMargin(8, 0, 24, 24, context),
                decoration: BoxDecoration(
                  color: ColorTemplate.lavender,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: dynamicWidth(28, context),
                        icon: const Icon(Icons.file_present_rounded, color: ColorTemplate.vistaBlue),
                        onPressed: () {
                          _selectFile(context);
                        },
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: TextField(
                          controller: messageController,
                          decoration:
                              const InputDecoration(hintText: 'Ketik pesan...', hintStyle: TextStyle(color: ColorTemplate.vistaBlue), border: InputBorder.none),
                        )),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        iconSize: dynamicWidth(28, context),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.send, color: ColorTemplate.vistaBlue),
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            _sendMessage(message: messageController.text);
                            messageController.clear();
                          }

                          if (file != null) {
                            _sendMessage(file: file!);
                            file = null;
                            messageController.clear();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Row _buildChatBubble(BuildContext context, MessageModel message, UserModel user) {
  bool isUser = (user.isAdmin && message.isAdmin) || (!user.isAdmin && user.id == message.userId);
  return Row(
    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      Container(
        padding: dynamicPaddingSymmetric(16, 16, context),
        margin: isUser ? dynamicMargin(8, 8, 8, 0, context) : dynamicMargin(8, 8, 0, 8, context),
        decoration: BoxDecoration(
          color: isUser ? ColorTemplate.violetBlue : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          message.message!,
          style: TextStyle(fontSize: 16, color: isUser ? Colors.white : ColorTemplate.violetBlue),
        ),
      )
    ],
  );
}