import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

final FirebaseFirestore fireStore = FirebaseFirestore.instance;
String userAutoId = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.createUserWithEmailAndPassword(email: "email@mail.ru", password: "password");
//FirebaseAuth.instance.signInWithEmailAndPassword(email: "email@mail.ru", password: "password").then((value) => print(value.user?.email));
  runApp(const MyApp());
}

ConfirmationResult? confirmationResult;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class RegPage extends StatefulWidget {
  const RegPage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _phoneCodeController = TextEditingController();
    TextEditingController _emailLinkController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
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
            //Почта ссылка
            Text('Email link'),

            TextFormField(
              controller: _emailLinkController,
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
            //Код
            TextFormField(
              maxLength: 13,
              controller: _phoneCodeController,
              decoration: const InputDecoration(
                hintText: 'Код',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  signInEmail(_emailController.text, _passwordController.text);
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
                  'Отправить код',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  signInCode(_phoneCodeController.text);
                },
                child: const Text(
                  'Авторизация (код)',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  signInEmailLink(
                      _emailController.text, _emailLinkController.text);
                },
                child: const Text(
                  'Авторизация (email-link)',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegPageF()));
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
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResultPageF())));
    var acs = ActionCodeSettings(
      url: 'https://www.example.com/finishSignUp?cartId=1234',
      handleCodeInApp: true,
    );
    await FirebaseAuth.instance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
    final user = FirebaseAuth.instance.currentUser;

    final userCurrent = fireStore.collection("user").doc(user!.uid);
    userAutoId = userCurrent.id;
  }

  Future<void> signInEmailLink(String email, String link) async {
    await FirebaseAuth.instance
        .signInWithEmailLink(email: email, emailLink: link)
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResultPageF())));
  }

  void signInAnon() {
    FirebaseAuth.instance.signInAnonymously().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => ResultPageF())));
  }

  void signInPhone(String phone) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    confirmationResult = await auth.signInWithPhoneNumber(phone);

    //   UserCredential userCredential = await confirmationResult.confirm('123456');
  }

  void signInCode(String code) async {
    UserCredential userCredential = await confirmationResult!.confirm(code);
    if (userCredential.user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ResultPageF()));
    }
  }
}

class ResultPageF extends StatelessWidget {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _typeController = TextEditingController();
    TextEditingController _damageController = TextEditingController();

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
            Text("Получилось"),
                 SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddItem()));
                },
                child: const Text(
                  'Добавить данные',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserPage()));
                },
                child: const Text(
                  'Профиль',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: "oof",
                              )));
                },
                child: const Text(
                  'Обратно на логин',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            StreamBuilder(
                stream: fireStore.collection("item").snapshots(),
                builder: (context, snapshot) {
                  List<Widget> childrenVal = <Widget>[];
                  if (snapshot.hasData) {
                    childrenVal = <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < snapshot.data!.docs.length; i++)
                            Column(
                              children: [
                                Text(
                                    "Имя: ${snapshot.data?.docs.elementAt(i).get("name")}",
                                    style: TextStyle(fontSize: 18)),
                                Text(
                                    "Тип: ${snapshot.data?.docs.elementAt(i).get("type")}",
                                    style: TextStyle(fontSize: 18)),
                                Text(
                                    "Урон: ${snapshot.data?.docs.elementAt(i).get("damage")}",
                                    style: TextStyle(fontSize: 18)),
                                SizedBox(
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                          deleteItem(snapshot.data?.docs.elementAt(i).id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ResultPageF()));
                                    },
                                    child: const Text(
                                      'Удалить',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                 SizedBox(
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                          changeItem(snapshot.data?.docs.elementAt(i).id,_nameController.text,_typeController.text,_damageController.text);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ResultPageF()));
                                            
                                    },
                                    child: const Text(
                                      'Изменить',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                          TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
 TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(
                hintText: 'Тип',
                border: OutlineInputBorder(),
              ),
            ),
 TextFormField(
              controller: _damageController,
              decoration: const InputDecoration(
                hintText: 'Урон',
                border: OutlineInputBorder(),
              ),
            ),
                    ];
                  }
               

                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: childrenVal,
                  ));
                }),
       
          ],
        ),
      ),
    );
  }

  // Stream<List<QueryDocumentSnapshot>> getItems() async {
  //   final item = fireStore.collection("item");
  //   List<QueryDocumentSnapshot> finale = <QueryDocumentSnapshot>[];
  //  await item.get().then(
  //     (querySnapshot) {
        
  //       for (var docSnapshot in querySnapshot.docs) {
  //         finale.add(docSnapshot);
  //       }
  //     },
  //     onError: (e) => print("Error completing: $e"),
  //   );
  //   return finale;
  // }
  
 Future< void> deleteItem(String? id) async{
  final item = fireStore.collection("item");
  item.doc(id)
        .delete()
        .then((value) => print("Item deleted"))
        .catchError((error) => print(error.toString()));;
 }
 
 Future< void> changeItem(String? id, String name, String type, String damage) async{
    final item = fireStore.collection("item");
    if (name != "" &&type!=""&&damage!="") {
      item
          .doc(id)
          .set({'name': name, 'type': type,'damage':damage})
          .then((value) => print("Item updated"))
          .catchError((error) => print(error.toString()));
    }
  }
}

class UserPage extends StatelessWidget {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _oldemailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _oldpasswordController = TextEditingController();
    TextEditingController _nameController = TextEditingController();

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
            Text("Смена данных аккаунта"),
            Text('Старый email'),

            TextFormField(
              maxLength: 25,
              controller: _oldemailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            Text('Email'),

            TextFormField(
              maxLength: 25,
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            //Имя
            Text('Имя'),

            TextFormField(
              maxLength: 25,
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            //Имя

            //Пароль
            TextFormField(
              maxLength: 30,
              controller: _oldpasswordController,
              decoration: const InputDecoration(
                hintText: 'Старый Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              maxLength: 30,
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  changeProfile(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                          _oldemailController.text,
                          _oldpasswordController.text)
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultPageF())));
                },
                child: const Text(
                  'Изменить',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  userDelete(_emailController.text, _passwordController.text)
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                    title: "BEGONE",
                                  ))));
                },
                child: const Text(
                  'Удалить профиль',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> changeProfile(String email, String password, String name,
      String oldemail, String oldpas) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: oldemail, password: oldpas)
        .then((userCredential) {
      userCredential.user?.updateEmail(email);
    });
    await userChange(name, email);
  }

  Future<void> userChange(String name, String email) async {
    final user = fireStore.collection("user");
    if (name != "")
      return user
          .doc(userAutoId)
          .set({'email': email, 'name': name})
          .then((value) => print("User updated"))
          .catchError((error) => print(error.toString()));
  }

  Future<void> userDelete(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      userCredential.user?.delete();
    });
    final user = fireStore.collection("user");

    return user
        .doc(userAutoId)
        .delete()
        .then((value) => print("User updated"))
        .catchError((error) => print(error.toString()));
  }
}

class RegPageF extends StatelessWidget {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _ageController = TextEditingController();
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
            //Имя
            Text('Имя'),

            TextFormField(
              maxLength: 25,
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            //Имя

            //Пароль
            TextFormField(
              maxLength: 30,
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            // //Телефон
            // TextFormField(

            //   maxLength: 100,
            //   controller: _phoneController,

            //   decoration: const InputDecoration(
            //     hintText: 'Телефон',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  signUpEmail(_emailController.text, _passwordController.text,
                      _nameController.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: "oof",
                              )));
                },
                child: const Text(
                  'Регистрация (почта)',
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: "oof",
                              )));
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

  void signUpEmail(String email, String password, String name) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await userAdd(name, email);
  }

  Future<void> userAdd(String name, String email) {
    final user = fireStore.collection("user");
    return user
        .add({'name': name, 'email': email})
        .then((value) => print("User added"))
        .catchError((error) => print(error.toString()))
        .whenComplete(() => userAutoId = user.id);
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

class AddItem extends StatelessWidget {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    TextEditingController _itemNameController = TextEditingController();
    TextEditingController _itemTypeController = TextEditingController();
    TextEditingController _itemDamageController = TextEditingController();

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
            Text("Добавление предмета"),
            TextFormField(
              maxLength: 30,
              controller: _itemNameController,
              decoration: const InputDecoration(
                hintText: 'Имя предмета',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              maxLength: 30,
              controller: _itemTypeController,
              decoration: const InputDecoration(
                hintText: 'Тип предмета',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              maxLength: 30,
              controller: _itemDamageController,
              decoration: const InputDecoration(
                hintText: 'Урон предмета',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  addItem(_itemNameController.text, _itemTypeController.text,
                      _itemDamageController.text);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ResultPageF()));
                },
                child: const Text(
                  'Добавить предмет',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addItem(String name, String type, String damage) async {
    final item = fireStore.collection("item");

    return item
        .add({'name': name, 'type': type, 'damage': damage})
        .then((value) => print("item added"))
        .catchError((error) => print(error.toString()));
  }
}
