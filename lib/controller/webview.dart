import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:demo/model/tokenModel.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:demo/navigation/bottom.dart";


class WebviewScreen  extends HookWidget {

  final LocalStorage storage = new LocalStorage('brick-game');

  Future<String> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('token');
    print("data");
    print(data);
    return data ?? "";
  }

  Future<void> deleteItems() async {
    print('GOGO');
    final prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.remove('token');
    print("down");
  }

  Future<TokenModel?> _getUrl(String token) async {
    try {
      print("_getUrl");
      print("QQQQQ");
      print(token);
      Response response = await Dio().post(
        'https://test.k8s.maev02.com/api/token',
        data: {
          'token': token,
        },
      );
      TokenModel tokenModel = TokenModel.fromJson(response.data);
      print("tokenDATA");
      print(tokenModel!.url);
      return tokenModel;
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    //強制改成android
    // WebView.platform=AndroidWebView();

    final _isLoading= useState(true);
    Future<String> fetchData() async {
      final token=await getItems();
      final tokenModel =await _getUrl(token);
      if(tokenModel!.code=="0000") {
        print("gogogog");
        return tokenModel!.url ?? "";
      }else{
        await deleteItems();
        Navigator.pushReplacementNamed(context, '/');
      }

      // await Future.delayed(Duration(seconds: 5));
      return 'ehe';

    }

    final selectedUrl = useState("");
    final future = useMemoized(fetchData);
    final snapshot = useFuture(future);

    useEffect(() {
      Future.microtask(()async {
        final token=await getItems();
        if(token.isEmpty){
          Navigator.pushReplacementNamed(context, '/');
        }

        // final tokenModel =await _getUrl(token);
        // print(tokenModel?.url);
        // if(tokenModel!.code=="0000"){
        //   print("gogogog");
        //   selectedUrl.value =tokenModel!.url ?? "";
        //
        //
        // }else{
        //   await storage.deleteItem("token");
        //   Navigator.pushNamed(context, '/');
        // }


      });
    }, const []);

    return
        Scaffold(
          // appBar: AppBar(
          //   title:Center(
          //     child:  TextButton(
          //         child: Text('返回'),
          //         onPressed: ()async {
          //             await deleteItems();
          //            Future.delayed(Duration.zero,(){
          //              Navigator.of(context).pop();
          //            });
          //           },
          //         style: ButtonStyle(
          //           backgroundColor: MaterialStateProperty.all(Colors.black),
          //         )
          //     ),
          //   )
          // ),
        body: Container(
          child:  SafeArea(
            child:  snapshot.hasData?

                Stack(
                  children: [

                    // if(_isLoading.value) Center(child:CircularProgressIndicator() ,),
                    WebView(
                      initialUrl:  snapshot.data.toString(),
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageFinished: (str) async{
                       print("done loading");
                        _isLoading.value = false;
                      },
                      onPageStarted: (str)async {
                        print("start");
                        _isLoading.value = true;

                      },
                    ),
                    if(_isLoading.value) Center(child:Image.asset('assets/gif/test.gif') ,),
                  ],
                )
            :Center(
                child:Image.asset('assets/gif/test.gif')
            )
          ),
        ),
        bottomNavigationBar:BottomMenu(
          selectedIndex: 1,
        ),
      );
  }
}
