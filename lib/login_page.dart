import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}
// to change the state of the page between login and register types
enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  String _email = ''; //stores de email form text box
  String _password = ''; //stores de password from text box
  FormType _formType = FormType.login; //initialize _formType
  final _formKey = GlobalKey<FormState>(); //Global key of the form
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
          key: _formKey,
          child: Column(
            children: buildInputs() + buildSubmitButtons(),
          ),
        )
      ),
    );
  }
//text boxes to get the account info from user
  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Email'),
        validator: (value) {
          if (value == null || value.isEmpty || !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
        onSaved: (value) => _email = value.toString(),
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty ) {
            return 'Password field can\'t be empty';
          }
          return null;
        },
        onSaved: (value) => _password = value.toString(),
      ),
      const SizedBox(height: 10), //space under the text boxes
    ];
  }
//buttons with login and sign in functions
  List<Widget> buildSubmitButtons() {
    //for login type
    if (_formType == FormType.login) {
      return [
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('cancel')
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      validateAndSubmit();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(
                            'Could not validate user credentials')),
                      );
                    }
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Login')
              ),
            ]
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            _formKey.currentState?.reset();
            setState(() {
              _formType = FormType.register;
            });
          },
          child: const Text('New user registration'),
        ),
      ]; //for register type
    } else {
      return [
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('cancel')
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      validateAndSubmit();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(
                            'Could not validate user credentials')),
                      );
                    }
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Sign in')
              ),
            ]
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            _formKey.currentState?.reset();
            setState(() {
              _formType = FormType.login;
            });
          },
          child: const Text('Already Signed in: back to Login'),
        ),
      ];
    }
  }
// async method for the Firebase interaction
  void validateAndSubmit() async {
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
  }
}