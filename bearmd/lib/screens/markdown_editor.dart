import 'dart:io';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';


class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({super.key});

  @override
  _MarkdownEditorState createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  late TabController tabController;


  String _text = '';
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
  queryData = MediaQuery.of(context);
  log(queryData.textScaleFactor.toString());
    return Column(
        children: <Widget>[
          //#region TabBar
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: Stack(
              children: [
                TabBar(
                    controller: tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.blue,
                    indicatorColor: Colors.lightBlueAccent,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Text("Write".toUpperCase()),
                      Text("Visualize".toUpperCase())
                    ]),
                Container(
                    margin: const EdgeInsets.only(top: 13),
                    child: const Divider(thickness: 1)),
              ],
            ),
          ),
          //#endregion

          //#region TabBar CONTENTS
          Flexible(
            child: TabBarView(
              controller: tabController,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _controller,
                          onChanged: (text) {
                            setState(() {
                              _text = text;
                              _wordCount =  RegExp(r"(\b[^0-9\W]+\b)[^$]").allMatches(text).length;
                            });
                          },
                          decoration: const InputDecoration.collapsed(
                            hintText: "Enter text here",
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.all(20),
                      child:
                      Text("Word count: $_wordCount", textScaleFactor: 1,),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Markdown(
                          data: _text,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          //#endregion
        ],
      );
  }

  /// UTILS : Save and load Markdown files
  Future<void> saveMarkdownFile(String markdownText, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.md');
    await file.writeAsString(markdownText);
  }

  Future<String> loadMarkdownFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.md');
    return file.readAsString();
  }


}

