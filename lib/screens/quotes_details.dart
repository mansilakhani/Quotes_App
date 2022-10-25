import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../globals/globals.dart';
import '../models/models.dart';

class Quotes_Detail_Page extends StatefulWidget {
  const Quotes_Detail_Page({Key? key}) : super(key: key);

  @override
  State<Quotes_Detail_Page> createState() => _Quotes_Detail_PageState();
}

class _Quotes_Detail_PageState extends State<Quotes_Detail_Page> {
  TextAlign textDirection = TextAlign.center;
  IconData textAlignButtonIcon = Icons.format_align_center_rounded;
  Color textColor = Colors.white;
  bool showColorPanel = false;

  int fontIndex = 0;

  @override
  Widget build(BuildContext context) {
    Quote? args = ModalRoute.of(context)!.settings.arguments as Quote?;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Mack Quote's Image"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            elevation: 0,
            child: const Icon(
              Icons.download_rounded,
              color: Color(0xff303030),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
            height: 10,
            // /height: 130,
          ),
          Container(
            padding: const EdgeInsets.all(30),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.68,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(args!.backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(
              args.quote,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
              ),
              textAlign: textDirection,
            ),
          ),
          const SizedBox(height: 10),
          showColorPanel
              ? Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: colors
                        .map((e) => FloatingActionButton(
                            elevation: 2,
                            mini: true,
                            backgroundColor: e,
                            onPressed: () {
                              setState(() {
                                textColor = e;
                              });
                            }))
                        .toList(),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              heroTag: null,
              mini: true,
              elevation: 0,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.photo,
                color: Color(0xff303030),
              ),
              onPressed: () async {
                setState(() {
                  args.backgroundImage = (editorImageList
                              .indexOf(args.backgroundImage) ==
                          editorImageList.length - 1)
                      ? editorImageList[0]
                      : editorImageList[
                          editorImageList.indexOf(args.backgroundImage) + 1];
                });
              },
            ),
            FloatingActionButton(
              heroTag: null,
              mini: true,
              elevation: 0,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.color_lens_outlined,
                color: Color(0xff303030),
              ),
              onPressed: () {
                setState(() {
                  showColorPanel = !showColorPanel;
                });
              },
            ),
            FloatingActionButton(
              heroTag: null,
              mini: true,
              elevation: 0,
              backgroundColor: Colors.white,
              child: Icon(
                textAlignButtonIcon,
                color: const Color(0xff303030),
              ),
              onPressed: () {
                if (textDirection == TextAlign.center) {
                  textDirection = TextAlign.end;
                  textAlignButtonIcon = Icons.format_align_right_rounded;
                  setState(() {});
                } else if (textDirection == TextAlign.end) {
                  textDirection = TextAlign.start;
                  textAlignButtonIcon = Icons.format_align_left_rounded;
                  setState(() {});
                } else if (textDirection == TextAlign.start) {
                  textDirection = TextAlign.center;
                  textAlignButtonIcon = Icons.format_align_center_rounded;
                  setState(() {});
                } else {
                  textDirection = TextAlign.center;
                  textAlignButtonIcon = Icons.format_align_center_rounded;
                  setState(() {});
                }
              },
            ),
            FloatingActionButton(
              heroTag: null,
              mini: true,
              elevation: 0,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.copy_rounded,
                color: Color(0xff303030),
              ),
              onPressed: () async {
                ClipboardData data = ClipboardData(text: args.quote);
                await Clipboard.setData(data);
                Fluttertoast.showToast(
                    msg: "Quote's Copied",
                    backgroundColor: const Color(0xff303030),
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            ),
            FloatingActionButton(
                heroTag: null,
                mini: true,
                elevation: 0,
                backgroundColor: Colors.white,
                child: Icon(Icons.done_all_rounded,
                    color:
                        args.markedAsRead ? Colors.green : Color(0xff303030)),
                onPressed: () async {
                  args.markedAsRead = !args.markedAsRead;
                  setState(() {});
                }),
            FloatingActionButton(
              heroTag: null,
              mini: true,
              elevation: 0,
              backgroundColor: Colors.white,
              child: Icon(
                  args.favorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  color: const Color(0xff303030)),
              onPressed: () {
                args.favorite = !args.favorite;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
