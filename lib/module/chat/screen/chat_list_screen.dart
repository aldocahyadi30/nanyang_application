import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/chat.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/message.dart';
import 'package:nanyang_application/module/chat/screen/chat_screen.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/chat_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final ConfigurationProvider _config;
  late final ToastProvider _toast;
  late final SupabaseStreamBuilder _messageStream;
  late final ChatViewModel _chatViewModel;
  int selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _config = context.read<ConfigurationProvider>();
    _toast = context.read<ToastProvider>();
    _chatViewModel = context.read<ChatViewModel>();
    try {
      _messageStream = _chatViewModel.getChatStream()!;
    } catch (e) {
      _toast.showToast('Terjadi kesalahan, silahkan coba lagi', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(title: 'Chat', isCenter: true, isBackButton: true),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025),
        height: MediaQuery.of(context).size.height * 0.875,
        decoration: const BoxDecoration(
          color: ColorTemplate.violetBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: dynamicPaddingOnly(28, 16, 16, 16, context),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = 0;
                      });
                    },
                    child: Container(
                      padding: dynamicPaddingSymmetric(8, 16, context),
                      decoration: BoxDecoration(
                        color: selectedFilter == 0 ? Colors.white : ColorTemplate.violetBlue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Semua',
                          style: TextStyle(
                            color: selectedFilter == 0 ? ColorTemplate.violetBlue : Colors.white,
                            fontSize: dynamicFontSize(16, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: dynamicWidth(16, context)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = 1;
                      });
                    },
                    child: Container(
                      padding: dynamicPaddingSymmetric(8, 16, context),
                      decoration: BoxDecoration(
                        color: selectedFilter == 1 ? Colors.white : ColorTemplate.violetBlue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Karyawan',
                          style: TextStyle(
                            color: selectedFilter == 1 ? ColorTemplate.violetBlue : Colors.white,
                            fontSize: dynamicFontSize(16, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: dynamicWidth(16, context)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = 2;
                      });
                    },
                    child: Container(
                      padding: dynamicPaddingSymmetric(8, 16, context),
                      decoration: BoxDecoration(
                        color: selectedFilter == 2 ? Colors.white : ColorTemplate.violetBlue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Cabutan',
                          style: TextStyle(
                            color: selectedFilter == 2 ? ColorTemplate.violetBlue : Colors.white,
                            fontSize: dynamicFontSize(16, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: ColorTemplate.periwinkle,
              thickness: 0.5,
            ),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Container(),
                  );
                } else if (snapshot.hasData) {
                  final chat = context.read<ChatViewModel>().getChat(snapshot.data!);
                  return Expanded(
                    child: FutureBuilder(
                        future: chat,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.separated(
                              itemCount: snapshot.data!.length,
                              separatorBuilder: (context, index) => const Divider(
                                color: ColorTemplate.periwinkle,
                                thickness: 0.5,
                              ),
                              itemBuilder: (context, index) {
                                return _buildChatWidget(context, snapshot.data![index]);
                              },
                            );
                          }
                          return Container();
                        }),
                  );
                } else {
                  return Center(
                    child: Container(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

ListTile _buildChatWidget(BuildContext context, ChatModel model) {
  EmployeeModel employee = model.user.employee;
  MessageModel message = model.lastMessage;
  return ListTile(
    leading: CircleAvatar(
      radius: dynamicWidth(24, context),
      backgroundColor: Colors.black,
      child: Text(
        employee.initials!,
        style: TextStyle(
          color: Colors.white,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    title: Text(
      employee.shortedName!,
      style: TextStyle(
        color: Colors.white,
        fontSize: dynamicFontSize(16, context),
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: Text(
      message.message!,
      style: TextStyle(
        color: Colors.white,
        fontSize: dynamicFontSize(12, context),
      ),
    ),
    trailing: _buildTrailing(context, message.timestamp, model.unreadCount),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(model: model)));
    },
  );
}

Column _buildTrailing(BuildContext context, DateTime date, int unreadCount) {
  DateTime now = DateTime.now();
  String time;

  if (now.year == date.year && now.month == date.month && now.day == date.day) {
    time = DateFormat('HH:mm').format(date);
  } else {
    time = '${date.day}/${date.month}/${date.year}';
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(
        time,
        style: TextStyle(
          color: Colors.white,
          fontSize: dynamicFontSize(12, context),
        ),
      ),
      unreadCount > 0
          ? Container(
              height: dynamicWidth(20, context),
              width: dynamicWidth(20, context),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  unreadCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: dynamicFontSize(12, context),
                  ),
                ),
              ))
          : Container(
              height: dynamicWidth(20, context),
              width: dynamicWidth(20, context),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
    ],
  );
}
