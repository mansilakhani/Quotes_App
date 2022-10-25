import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '../helpers/api_helper.dart';
import '../helpers/database_helper.dart';
import '../models/models.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({Key? key}) : super(key: key);

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  bool seened = false;

  int bottomBarIndex = 0;
  late List<Quote>? dbFetchData;
  late Future<List<Quote>?> finalDBData;
  late List<Quote>? apiData;
  @override
  initState() {
    super.initState();
    finalDBData = initProcess();
  }

  Future<List<Quote>?> initProcess() async {
    dbFetchData = await DBHelper.dbHelper.fetchData();
    if (dbFetchData!.isEmpty || dbFetchData == null) {
      apiData = await APIHelper.apiHelper.getQuotesList();
      apiData?.forEach((e) {
        DBHelper.dbHelper.insertDataIntoTable(e);
      });
      return initProcess();
    }
    return DBHelper.dbHelper.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text("$query Quotes"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: finalDBData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            List<Quote>? allQuotes = snapshot.data;
            return ListView(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              physics: const BouncingScrollPhysics(),
              children: allQuotes!
                  .map((e) => GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "open_editor",
                              arguments: e);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.quote,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "by : ${e.author}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xffEDEDED),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.copy_rounded,
                                        color: Color(0xff303030),
                                      ),
                                      onPressed: () async {
                                        ClipboardData data =
                                            ClipboardData(text: e.quote);
                                        await Clipboard.setData(data);
                                        Fluttertoast.showToast(
                                            msg: "Quote's Copied",
                                            backgroundColor:
                                                const Color(0xff303030),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.share_rounded,
                                        color: Color(0xff303030),
                                      ),
                                      onPressed: () {
                                        Share.share(
                                            "${e.quote}\nby ${e.author}",
                                            subject: "Kivi Quote's");
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.done_all_rounded,
                                        color: e.markedAsRead
                                            ? Colors.green
                                            : const Color(0xff303030),
                                      ),
                                      onPressed: () async {
                                        e.markedAsRead = !e.markedAsRead;
                                        int res = await DBHelper.dbHelper
                                            .markAsRead(
                                                id: e.id,
                                                markAsRead:
                                                    e.markedAsRead.toString());
                                        if (res == 1) {
                                          setState(() {
                                            finalDBData = initProcess();
                                          });
                                          Fluttertoast.showToast(
                                              msg: "Marked As Read",
                                              backgroundColor:
                                                  const Color(0xff303030),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        e.favorite
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_outline_rounded,
                                        color: const Color(0xff303030),
                                      ),
                                      onPressed: () {
                                        e.favorite = !e.favorite;
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
