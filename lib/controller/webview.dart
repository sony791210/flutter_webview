import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:demo/model/tokenModel.dart';
import 'package:dio/dio.dart';

class WebviewScreen  extends HookWidget {

  final LocalStorage storage = new LocalStorage('brick-game');
  Future<String> getItems() async {
    // final LocalStorage storage = new LocalStorage('brick-game');
    final data  = await storage.getItem('token');
    print(data);
    return data;
  }

  Future<TokenModel?> _getUrl(String token) async {
    try {
      print("_getUrl");
      Response response = await Dio().post(
        'https://636774b3f5f549f052d5af8c.mockapi.io/api/token',
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
    Future<String> fetchData() async {
      final token=await getItems();
      final tokenModel =await _getUrl(token);
      if(tokenModel!.code=="0000") {
        print("gogogog");
        return tokenModel!.url ?? "";
      }else{
        await storage.deleteItem("token");
        Navigator.pushNamed(context, '/');
      }

      await Future.delayed(Duration(seconds: 5));
      return 'ehe';
    }

    final selectedUrl = useState("");
    final future = useMemoized(fetchData);
    final snapshot = useFuture(future);

    useEffect(() {
      Future.microtask(()async {
        print("34567");
        final token=await getItems();
        if(token.isEmpty){
          Navigator.pushNamed(context, '/');
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

    return MaterialApp(


        home:Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //       snapshot.data.toString()
          //
          //   ),
          // ),
        body: Container(
          child:  SafeArea(
            child:  snapshot.hasData?
            WebView(
              initialUrl:  snapshot.data.toString(),
              javascriptMode: JavascriptMode.unrestricted,
            )
            :Center(
                child:CircularProgressIndicator()
            )
          ),
        ),
      )


    );
  }
}
