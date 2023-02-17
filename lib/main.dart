import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
 // await FirebaseAuth.instance.createUserWithEmailAndPassword(email: "email@mail.ru", password: "password");
//FirebaseAuth.instance.signInWithEmailAndPassword(email: "email@mail.ru", password: "password").then((value) => print(value.user?.email));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class RegPage extends StatefulWidget {
  const RegPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
 
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
      GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Почта
            Text('Email'),

                  TextFormField(
                    maxLength: 25,
                    controller: _emailController,
                   
                  
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  //Пароль
                  TextFormField(
                    maxLength: 30,
                    controller: _passwordController,
                  
                   
                    decoration: const InputDecoration(
                      hintText: 'Пароль',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  //Телефон
                  TextFormField(
                    
                    maxLength: 100,
                    controller: _phoneController,
                  
                    decoration: const InputDecoration(
                      hintText: 'Телефон',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                      
                          signInEmail(_emailController.text,
                              _passwordController.text);
                    
                      },
                      child: const Text(
                        'Авторизация',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                     SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                      
                          signInAnon();
                    
                      },
                      child: const Text(
                        'Авторизация (анонимно)',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                       SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                      
                          signInPhone(_phoneController.text);
                    
                      },
                      child: const Text(
                        'Авторизация (телефон)',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                       Navigator.push(context,MaterialPageRoute(builder: (context) => RegPageF()));
                      },
                      child: const Text(
                        'Регистрация',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
  Future<void> signInEmail(String email, String password) async {

    FirebaseAuth.instance.signInWithEmailAndPassword(email:email, password: password).then((value) => Navigator.push(context,MaterialPageRoute(builder: (context) => ResultPageF())));
    var acs = ActionCodeSettings(
   url: 'https://www.example.com/finishSignUp?cartId=1234',
    handleCodeInApp: true,
  
    );
  await  FirebaseAuth.instance.sendSignInLinkToEmail(email: email, actionCodeSettings: acs).catchError((onError) => print('Error sending email verification $onError'))
    .then((value) => print('Successfully sent email verification'));
    final user = FirebaseAuth.instance.currentUser;




 
  }
    void signInAnon() {

    FirebaseAuth.instance.signInAnonymously().then((value) => Navigator.push(context,MaterialPageRoute(builder: (context) => ResultPageF())));
  }
  
  void signInPhone(String phone) {
    FirebaseAuth.instance.signInWithPhoneNumber(phone).then((value) => Navigator.push(context,MaterialPageRoute(builder: (context) => ResultPageF())));
  }
}

class ResultPageF extends StatelessWidget {
  int _counter = 0;
  
 
  

  @override
  Widget build(BuildContext context) {
      GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text("Получилось")
          ],
        ),
      ),
  
    );
  }
  
  
}
class RegPageF extends StatelessWidget {
  int _counter = 0;
  
  

  @override
  Widget build(BuildContext context) {
      GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
    
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        //Почта
            Text('Email'),

                  TextFormField(
                    maxLength: 25,
                    controller: _emailController,
                   
                  
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  //Пароль
                  TextFormField(
                    maxLength: 30,
                    controller: _passwordController,
                  
                   
                    decoration: const InputDecoration(
                      hintText: 'Пароль',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  //Телефон
                  TextFormField(
                    
                    maxLength: 100,
                    controller: _phoneController,
                  
                    decoration: const InputDecoration(
                      hintText: 'Телефон',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                      
                          signUpEmail(_emailController.text,
                              _passwordController.text);
                      Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage(title: "oof",)));
                      },
                      child: const Text(
                        'Регистраци (почта)',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  //    SizedBox(
                  //   height: 35,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                      
                  //         signUpPhone(_phoneController.text);
                  //     Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage(title: "oof",)));
                  //     },
                  //     child: const Text(
                  //       'Регистраци (телефон)',
                  //       style: TextStyle(fontSize: 18),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                       Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage(title: "oof",)));
                      },
                      child: const Text(
                        'Обратно на логин',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
          ],
        ),
      ),
  // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
  void signUpEmail(String email, String password) async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }
  
//   void signUpPhone(String phone) async{
//      await FirebaseAuth.instance.verifyPhoneNumber(
//   phoneNumber: phone,
//   verificationCompleted: (PhoneAuthCredential credential) {},
//   verificationFailed: (FirebaseAuthException e) {},
//   codeSent: (String verificationId, int? resendToken) {},
//   codeAutoRetrievalTimeout: (String verificationId) {},
  
// );

  // }
  
  
}