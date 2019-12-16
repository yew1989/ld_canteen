import 'package:flutter/material.dart';

void pushToPage(BuildContext context,StatefulWidget page) {
    if(page == null) return;
    final MaterialPageRoute route = MaterialPageRoute(builder: (BuildContext context) => page);
    Navigator.of(context).push(route);
  }