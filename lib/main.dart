import 'package:dbminor_quotesapp/screens/homepage.dart';
import 'package:dbminor_quotesapp/screens/quotes_details.dart';
import 'package:dbminor_quotesapp/screens/quotes_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const Homepage(),
        "quotes_list_page": (context) => QuotesPage(),
        "open_editor": (context) => Quotes_Detail_Page(),

        
      },
    ),
  );
}
