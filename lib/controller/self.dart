import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:demo/model/login.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import "package:demo/navigation/bottom.dart";


class SelfScreen extends HookWidget {


  @override
  Widget build(BuildContext context) {
    final _deviceToken=useState("");
    final future = useMemoized(SharedPreferences.getInstance);
    final snapshot = useFuture(future, initialData: null);



    useEffect(() {
      final preferences = snapshot.data;
      if (preferences == null) {
        return;
      }
      final devicToken=preferences.getString('deviceToken');
      _deviceToken.value=devicToken ?? "";


      final token = preferences.getString('token');
      //如果沒有token 就是回到登出頁面吧
      if(token==null || token!.isEmpty){
        Navigator.pushReplacementNamed(context, '/');
      }


    }, [snapshot.data]);




    return Scaffold(

        body: Container(
            child:Center(
              child: Text("123"),
            )
        ),
        bottomNavigationBar:BottomMenu(
          selectedIndex: 2,
        ),
    );
  }
}
