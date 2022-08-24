import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
  //final _formKey = GlobalKey<FormState>(); //Global key of the form
  //the widget tree of the login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('login page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(100),
        child: Form(
          //key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _entryFields() + _submitButtons(),
          ),
        )
      ),
    );
  }
//text boxes to get the account info from user
  List<Widget> _entryFields() {
    return [
      TextFormField(
        controller: _controllerEmail,
        decoration: const InputDecoration(labelText: 'Email'),
        /*validator: (value) {
          if (value == null || value.isEmpty || !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
        onSaved: (value) => _email = value.toString(),*/
      ),
      TextFormField(
        controller: _controllerPassword,
        decoration: const InputDecoration(labelText: 'Password'),
        obscureText: true,
        /*validator: (value) {
          if (value == null || value.isEmpty ) {
            return 'Password field can\'t be empty';
          }
          return null;
        },
        onSaved: (value) => _password = value.toString(),**/
      ),
      const SizedBox(height: 10), //space under the text boxes
      Text(errorMessage == '' ? '' : '$errorMessage'),
      const SizedBox(height: 10), //space under the text boxes
    ];
  }
//buttons with login and sign in functions
  List<Widget> _submitButtons() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.cancel),
            label: const Text('Cancel')
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed:
              isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
              icon: Icon(isLogin ? Icons.login : Icons.person_add),
              label: Text(isLogin ? 'Login' : 'Register'),
          ),
        ]
      ),
      const SizedBox(height: 10),
      TextButton(
        onPressed: () {setState(() {isLogin = !isLogin;});},
        child: Text(isLogin ? 'Register instead' : 'Login instead'),
      ),
    ]; //for register type
  }

// async method for the Firebase interaction
  /*void validateAndSubmit() async {
    try{
      if(_formType == FormType.login) {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email,
            password: _password
        );
      } else {
        UserCredential userCredential =
        await  FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email,
            password: _password
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }*/
}