import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:demo/model/login.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


// class LoginScreen extends StatefulWidget {
//
//   @override
//   State<LoginScreen> createState() {
//     return new _LoginScreenState();
//   }
// }

class LoginScreen extends HookWidget {
  final LocalStorage storage = new LocalStorage('brick-game');
  Future<String> getItems() async {
    // final LocalStorage storage = new LocalStorage('brick-game');
    // storage.setItem('token', 'Abolfazl');
    final data  = await storage.getItem('token');
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
            labelText: '帳號',
            //聚焦时才显示,颜色跟hintColor
            hintText: '請輸入帳號',
            //红色
//            errorText: '输入错误',
            //红色，现在在输入框的左下角，跟errorText位置一样(优先显示errorText)
//            helperText: 'acount',
            //输入框内左侧，有聚焦，颜色跟primaryColor
            prefixIcon: Icon(Icons.person),
            //输入框左侧的widget（可是text、icon……）
            icon: Text(
              '帳號：',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
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
          labelText: '密碼',
          //聚焦时才显示,颜色跟hintColor
          hintText: '請輸入密碼',
          //红色
//          errorText: '输入错误',
          //红色，现在在输入框的左下角，跟errorText位置一样(优先显示errorText)
//          helperText: 'password',
          //输入框内左侧widget，输入聚焦时，颜色跟primaryColor
          prefixIcon: Icon(Icons.lock),
          //输入框左侧的widget（可是text、icon……）
          icon: Text(
            '密碼：',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
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

  //账号、密码输入框
  Widget textSection = new Container(
    padding: const EdgeInsets.all(32.0),
    child: new Column(
      //主轴Flex的值
      mainAxisSize: MainAxisSize.max,
      //MainAxisAlignment：主轴方向上的对齐方式，会对child的位置起作用
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildAccountTextFied(_accountController),
        buildPasswordTextFied(_passwordController),
      ],
    ),
  );

  Future<Login?> _getUserInfo(String account, String password) async {
    try {
      print("QQQQQ");
      Response response = await Dio().post(
        'https://636774b3f5f549f052d5af8c.mockapi.io/api/login',
        data: {
          'account': account,
          'password': password,
        },
      );
      Login login = Login.fromJson(response.data);
      print(login.accesstoken);

      return login;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.microtask(()async {
        print("1235");
        final token=await getItems();
        if(token.isNotEmpty){
          Navigator.pushNamed(context, '/Home');
        }
      });
    }, const []);
    Widget loginButton = new Container(
        margin: const EdgeInsets.only(left: 35, right: 35),
        //这个widget距离父控件左右35（还有个all就是距离左上右下四个方向）
        child: new SizedBox(
            //用来设置宽高，如直接使用RaisedButton则不能设置
            height: 50,
            child: new ElevatedButton(
              //一个凸起的材质矩形按钮
              child: new Text(
                'login',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                print(_accountController.text);
                print(_passwordController.text);
                Login? login = await _getUserInfo(
                    _accountController.text, _passwordController.text);
                if (login!.code == "0000") {
                  storage.setItem("token", login!.accesstoken);
                  Navigator.pushNamed(context, '/Home');

                } else {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('登入失敗'),
                        content: Text( login!.message ??  "登入失敗"  ),
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
            )));

    return Scaffold(
        appBar: new AppBar(
          title: new Text('login'),
        ),
        body: new ListView(children: [textSection, loginButton]));
  }
}
