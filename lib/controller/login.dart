import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:demo/model/login.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import "package:demo/navigation/bottom.dart";
// class LoginScreen extends StatefulWidget {
//
//   @override
//   State<LoginScreen> createState() {
//     return new _LoginScreenState();
//   }
// }

class LoginScreen extends HookWidget {


  Future<String?> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('token');
    print(data);
    return data;
  }



//用于路由（就是界面的跳转），当跳转的事件没有写在build里面时用到（我这里抽到了loginButton里面）
//   static BuildContext context1;

//用于登录时判断输入的账号、密码是否符合要求
  bool? _accountState = false;
  bool? _passwordState = false;

  String? var_account;
  String? var_password;

  //提示语
  String? _checkHint;

  //监听账号输入框的文字变化
  static TextEditingController _accountController = new TextEditingController();

  //监听密码输入框的文字变化
  static TextEditingController _passwordController =
      new TextEditingController();

//账号输入框样式
  static Widget buildAccountTextFied(TextEditingController controller) {
    /**
     *需要定制一下某些颜色时返回Theme，不需要时返回TextField（如后面的密码）
     * 修改输入框颜色：没有获取焦点时为hintColor，获取焦点后为：primaryColor
     */
    return Theme(
      data: new ThemeData(
          primaryColor: Colors.amber, hintColor: Colors.greenAccent),
      child: new TextField(
        //键盘的样式
        keyboardType: TextInputType.text,
        //监听
        controller: controller,
        //最大长度
        maxLength: 30,
        //颜色跟hintColor
        //最大行数
        maxLines: 1,
        //是否自动更正
        autocorrect: true,
        //是否自动化对焦
        autofocus: false,
        //是否是密码格式(输入的内容不可见)
        obscureText: false,
        //文本对齐方式
        textAlign: TextAlign.start,
        //输入文本的样式
        style: TextStyle(fontSize: 20, color: Colors.black),
        //允许输入的格式(digitsOnly数字)
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[A-Z,a-z,0-9]"))
        ],
        //内容改变回调
        onChanged: (account) {
          print('change $account');
        },
        //提交触发回调
        onSubmitted: (account) {
          print('submit $account');
        },
        //是否禁用
        enabled: true,
        decoration: InputDecoration(
            fillColor: Colors.blue[50],
            //底色
            filled: true,
            //有聚焦，labelText就会缩小到输入框左上角，颜色primaryColor，没聚焦前颜色跟hintColor
            // labelText: '帳號',
            //聚焦时才显示,颜色跟hintColor
            hintText: 'Account',
            //红色
//            errorText: '输入错误',
            //红色，现在在输入框的左下角，跟errorText位置一样(优先显示errorText)
//            helperText: 'acount',
            //输入框内左侧，有聚焦，颜色跟primaryColor
            prefixIcon: Icon(Icons.person),
            //输入框左侧的widget（可是text、icon……）
            // icon: Text(
            //   '帳號：',
            //   style: TextStyle(fontSize: 20, color: Colors.black),
            // ),
            //输入框内右侧的widget
            suffixIcon: Icon(Icons.account_circle),
//            有聚焦显示颜色跟hintColor，显示在输入框的右边
            suffixText: "",
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(21.11), //边框裁剪成11.11°角
              borderSide: BorderSide(
                  color: Colors.black,
                  width: 25.0), //边框颜色、大小没有效果，所以使用返回的是Theme，
            )),
      ),
    );
  }

  //密码输入框样式
  static Widget buildPasswordTextFied(TextEditingController controller) {
    return TextField(
      //键盘的样式
      keyboardType: TextInputType.text,
      //监听
      controller: controller,
      //最大长度
      maxLength: 30,
      //颜色跟hintColor
      //最大行数
      maxLines: 1,
      //是否自动更正
      autocorrect: true,
      //是否自动化对焦
      autofocus: false,
      //是否是密码格式(输入的内容不可见)
      obscureText: true,
      //文本对齐方式
      textAlign: TextAlign.start,
      //输入文本的样式
      style: TextStyle(fontSize: 20, color: Colors.black),
      //允许输入的格式(digitsOnly数字)
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[A-Z,a-z,0-9]"))
      ],
      //内容改变回调
      onChanged: (password) {
        print('change $password');
      },
      //提交触发回调
      onSubmitted: (password) {
        print('submit $password');
      },
      //是否禁用
      enabled: true,
      decoration: InputDecoration(
          //底色配合filled：true才有效
          fillColor: Colors.blue[50],
          filled: true,
          //输入聚焦以后，labelText就会缩小到输入框左上角，红色,没聚焦前颜色跟hintColor
          // labelText: '密碼',
          //聚焦时才显示,颜色跟hintColor
          hintText: 'Password',
          //红色
//          errorText: '输入错误',
          //红色，现在在输入框的左下角，跟errorText位置一样(优先显示errorText)
//          helperText: 'password',
          //输入框内左侧widget，输入聚焦时，颜色跟primaryColor
          prefixIcon: Icon(Icons.lock),
          //输入框左侧的widget（可是text、icon……）
          // icon: Text(
          //   '密碼：',
          //   style: TextStyle(fontSize: 20, color: Colors.black),
          // ),
          //输入框内右侧的widget
          suffixIcon: Icon(Icons.remove_red_eye),
          //聚焦时才显示颜色跟hintColor，显示在输入框的右边
          suffixText: '',
          contentPadding: EdgeInsets.all(5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21.11), //边框裁剪成11.11°角
            borderSide: BorderSide(
                color: Colors.black, width: 25.0), //没有效果，想要修改就返回Theme（如前面账号样式）
          )),
    );
  }


  //pandd
  Widget topContainer = new Container(
    height: 100,
  );

  //Log
  Widget logo = new Container(
    height: 100,
    child: Center(
      child: Center(child: Image.asset('assets/images/White_Logo.png')),
    ),
  );

  Future<Login?> _getUserInfo(String account, String password,String deviceToken) async {
    try {
      print(account);
      print(password);
      print(deviceToken);
      print('before dio');
      Response response = await Dio().post(
        'https://test.k8s.maev02.com/api/login',
        data: {
          'account': account,
          'password': password,
          'deviceToken':deviceToken,
        },
      );
      print('done dio');
      print('okok');
      print(response);
      Login login = Login.fromJson(response.data);
      print(login.token);

      return login;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _test=useState("QQ");
    final _deviceToken=useState("");
    final _isObscureText=useState(true);
    final future = useMemoized(SharedPreferences.getInstance);
    final snapshot = useFuture(future, initialData: null);

    // useEffect(() {
    //   Future.microtask(() async {
    //     print("1235");
    //     print("QQQQQsss");
    //     final token = await getItems();
    //     if (token!=null && token!.isNotEmpty) {
    //       Navigator.pushNamed(context, '/Home');
    //     }
    //   });
    // }, const []);

    useEffect(() {
      final preferences = snapshot.data;
      if (preferences == null) {
        return;
      }
      final devicToken=preferences.getString('deviceToken');
      _deviceToken.value=devicToken ?? "";


      final token = preferences.getString('token');
      if(token!=null && token!.isNotEmpty){
        Future.delayed(Duration.zero,(){
          Navigator.pushReplacementNamed(context, '/Self');
        });
      }
      _test.value=token??"PP";

    }, [snapshot.data]);

    Future<void> saveItems(token) async {
      print('save items');
      print(token);
      final preferences = snapshot.data;
      // Save an String value to 'action' key.
      print("gogo");
      if (preferences == null) {
        return;
      }

      preferences.setString("token", token);
      _test.value=token??"PP!";
      // await prefs.setString('token', token);
      print('finish');
    }

    //帳號输入框样式
    Widget buildAccountTextFiedTest(TextEditingController controller) {
      return new Container(
        child: new Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                          child: Icon(Icons.account_box_sharp, size: 25, color: Colors.white)),
                      TextSpan(
                        text: " UserName",
                        style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "NotoSansTC"),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 5,),
            TextField(
              //键盘的样式
              keyboardType: TextInputType.text,
              //监听
              controller: controller,
              //最大长度
              maxLength: 30,
              //颜色跟hintColor
              //最大行数
              maxLines: 1,
              //是否自动更正
              autocorrect: true,
              //是否自动化对焦
              autofocus: false,
              //是否是密码格式(输入的内容不可见)
              obscureText: false,
              //文本对齐方式
              textAlign: TextAlign.start,
              //输入文本的样式
              style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "NotoSansTC"),
              //允许输入的格式(digitsOnly数字)
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[A-Z,a-z,0-9,@]"))
              ],
              //内容改变回调
              onChanged: (password) {
                print('change $password');
              },
              //提交触发回调
              onSubmitted: (password) {
                print('submit $password');
              },
              //是否禁用
              enabled: true,
              decoration: InputDecoration(
                //底色配合filled：true才有效
                fillColor:Color(0xff1B2937),

                filled: true,
                //输入聚焦以后，labelText就会缩小到输入框左上角，红色,没聚焦前颜色跟hintColor
                // labelText: '密碼',
                //聚焦时才显示,颜色跟hintColor
                hintText: 'BayTech@gmail.com',
                hintStyle: TextStyle(fontSize: 20,color: Colors.white54,fontFamily: "NotoSansTC"),
                //红色
//          errorText: '输入错误',
                //红色，现在在输入框的左下角，跟errorText位置一样(优先显示errorText)
//          helperText: 'password',
                //输入框内左侧widget，输入聚焦时，颜色跟primaryColor
                // prefixIcon: Icon(Icons.lock),
                //输入框左侧的widget（可是text、icon……）
                // icon: Text(
                //   '密碼：',
                //   style: TextStyle(fontSize: 20, color: Colors.black),
                // ),
                //输入框内右侧的widget




                //聚焦时才显示颜色跟hintColor，显示在输入框的右边
                suffixText: '',
                // contentPadding: EdgeInsets.all(5),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(21.11), //边框裁剪成11.11°角
                //   borderSide: BorderSide(
                //       color: Colors.black, width: 25.0), //没有效果，想要修改就返回Theme（如前面账号样式）
                // ),
              ),
            ),
          ],
        ),
      );
    }

    //密码输入框样式
    Widget buildPasswordTextFiedTest(TextEditingController controller) {
      return new Container(
        child: new Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                          child: Icon(Icons.lock, size: 25, color: Colors.white)),
                      TextSpan(
                        text: " Password",
                        style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "NotoSansTC"),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 5,),
            TextField(
              //键盘的样式
              keyboardType: TextInputType.text,
              //监听
              controller: controller,
              //最大长度
              maxLength: 30,
              //颜色跟hintColor
              //最大行数
              maxLines: 1,
              //是否自动更正
              autocorrect: true,
              //是否自动化对焦
              autofocus: false,
              //是否是密码格式(输入的内容不可见)
              obscureText: _isObscureText.value ,
              //文本对齐方式
              textAlign: TextAlign.start,
              //输入文本的样式
              style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "NotoSansTC"),
              //允许输入的格式(digitsOnly数字)
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[A-Z,a-z,0-9,@]"))
              ],
              //内容改变回调
              onChanged: (password) {
                print('change $password');
              },
              //提交触发回调
              onSubmitted: (password) {
                print('submit $password');
              },
              //是否禁用
              enabled: true,
              decoration: InputDecoration(
                //底色配合filled：true才有效
                fillColor:Color(0xff1B2937),
                filled: true,
                //输入聚焦以后，labelText就会缩小到输入框左上角，红色,没聚焦前颜色跟hintColor
                // labelText: '密碼',
                //聚焦时才显示,颜色跟hintColor
                hintText: 'BayTech2022',
                hintStyle: TextStyle(fontSize: 20,color: Colors.white54,fontFamily: "NotoSansTC"),
                //红色
//          errorText: '输入错误',
                //红色，现在在输入框的左下角，跟errorText位置一样(优先显示errorText)
//          helperText: 'password',
                //输入框内左侧widget，输入聚焦时，颜色跟primaryColor
                // prefixIcon: Icon(Icons.lock),
                //输入框左侧的widget（可是text、icon……）
                // icon: Text(
                //   '密碼：',
                //   style: TextStyle(fontSize: 20, color: Colors.black),
                // ),
                //输入框内右侧的widget
                suffixIcon:IconButton(
                  icon:_isObscureText.value?  
                  Icon(Icons.visibility_off,color: Colors.white,)
                  :Icon(Icons.visibility,color: Colors.white,),
                  onPressed: (){
                    _isObscureText.value=!_isObscureText.value;
                  },
                ),



                //聚焦时才显示颜色跟hintColor，显示在输入框的右边
                suffixText: '',
                // contentPadding: EdgeInsets.all(5),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(21.11), //边框裁剪成11.11°角
                //   borderSide: BorderSide(
                //       color: Colors.black, width: 25.0), //没有效果，想要修改就返回Theme（如前面账号样式）
                // ),
              ),
            ),
          ],
        ),
      );
    }



    //账号、密码输入框
    Widget textSection = new Container(
      margin: const EdgeInsets.only(top:40),
      padding: const EdgeInsets.all(40.0),
      child: new Column(
        //主轴Flex的值
        mainAxisSize: MainAxisSize.max,
        //MainAxisAlignment：主轴方向上的对齐方式，会对child的位置起作用
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildAccountTextFiedTest(_accountController),
          buildPasswordTextFiedTest(_passwordController),
          // buildAccountTextFied(_accountController),
          // buildPasswordTextFied(_passwordController),
        ],
      ),
    );



    Widget loginButton = new Container(
        margin: const EdgeInsets.only(left: 35, right: 35),
        //这个widget距离父控件左右35（还有个all就是距离左上右下四个方向）
        child: new SizedBox(
            //用来设置宽高，如直接使用RaisedButton则不能设置
            height: 50,
            child: new ElevatedButton(
              //一个凸起的材质矩形按钮
              child: new Text(
                '登入',
                style: TextStyle(color: Colors.black, fontSize: 20,fontFamily: "NotoSansTC"),
              ),
              onPressed: () async {
                print("gogo");
                Login? login = await _getUserInfo(
                    _accountController.text, _passwordController.text,_deviceToken.value);

                if (login!.code == "0000") {
                  await saveItems(login!.token);
                  Navigator.pushReplacementNamed(context, '/Home');
                } else {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('登入失敗'),
                        content: Text(login!.message ?? "登入失敗"),
                        actions: <Widget>[
                          TextButton(
                            child: Text('確定'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue[50]),

              ),
            )));

    return Scaffold(
        // appBar: new AppBar(
        //   title: new Text(_test.value),
        // ),
        body: Container(
          child: new ListView(
            children: [topContainer, logo, textSection, loginButton]
          ),
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('assets/images/login_sea.jpeg'),
            //   fit:BoxFit.cover,
            //   colorFilter: ColorFilter.mode(Colors.blue, BlendMode.darken),
            // ),
            color: Color(0xff354F6A),
          ),
        ),
        bottomNavigationBar:BottomMenu(
          selectedIndex: 0,
        ),
    );
  }
}
