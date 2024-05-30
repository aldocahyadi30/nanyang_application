import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/message.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/chat_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatUserScreen extends StatefulWidget {
  const ChatUserScreen({super.key});

  @override
  State<ChatUserScreen> createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  final TextEditingController messageController = TextEditingController();
  late final ConfigurationProvider _config;
  late final SupabaseStreamBuilder messageStream;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      _config = context.read<ConfigurationProvider>();
      context.read<ChatViewModel>().getMessageStream().then((stream) {
        setState(() {
          messageStream = stream!;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.lightVistaBlue,
      appBar: const NanyangAppbar(
        title: 'Help Chat',
        isBackButton: true,
        isCenter: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 12,
            child: Container(
              height: double.infinity,
              color: ColorTemplate.periwinkle,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: messageStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: NanyangEmptyPlaceholder(),
                    );
                  }
                  final messages = MessageModel.fromSupabaseList(snapshot.data!);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: messages.map((message) => _buildMessageWidget(context, message, _config)).toList(),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: dynamicPaddingAll(4, context),
              color: ColorTemplate.lightVistaBlue,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.attach_file,
                        color: ColorTemplate.violetBlue,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      decoration: InputDecoration(
                          contentPadding: dynamicPaddingSymmetric(8, 8, context),
                          hintText: 'Type a message',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          filled: true,
                          fillColor: ColorTemplate.periwinkle),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        color: ColorTemplate.violetBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Row _buildMessageWidget(BuildContext context, MessageModel message, ConfigurationProvider config) {
  if (config.user.id == message.userId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorTemplate.darkVistaBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message.message!,
            style: const TextStyle(fontSize: 16),
          ),
        )
      ],
    );
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorTemplate.lavender,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message.message!,
            style: const TextStyle(fontSize: 16),
          ),
        )
      ],
    );
  }
}
