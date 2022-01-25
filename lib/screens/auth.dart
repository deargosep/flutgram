import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class AuthScreen extends HookWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final auth = useState(true);
    Widget getForm() {
      if (auth.value) {
        return AuthForm();
      } else {
        return RegisterForm();
      }
    }

    void changeForm() {
      auth.value = !auth.value;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${auth.value ? 'Auth' : 'Register'}'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getForm(),
          TextButton(onPressed: changeForm, child: Text('Change'))
        ],
      )),
    );
  }
}

class AuthForm extends HookWidget {
  const AuthForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    final emailError = useState('');
    final passwordError = useState('');
    void validate() {
      if (GetUtils.isEmail(email.value.text) == false) {
        emailError.value = 'not an email';
      }
    }

    void submit() async {
      validate();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.value.text, password: password.value.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emailError.value = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          passwordError.value = 'Wrong password provided for that user.';
        }
      }
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            controller: email,
            decoration: InputDecoration(label: Text('Email')),
          ),
          Text(
            emailError.value,
            style: TextStyle(color: Colors.red),
          ),
          TextFormField(
            autocorrect: false,
            controller: password,
            obscureText: true,
            decoration: InputDecoration(label: Text('Password')),
            onFieldSubmitted: (text) {
              submit();
            },
          ),
          Text(
            passwordError.value,
            style: TextStyle(color: Colors.red),
          ),
          TextButton(onPressed: submit, child: Text('Submit'))
        ],
      ),
    );
  }
}

class RegisterForm extends HookWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final password = useTextEditingController();
    final passwordError = useState('');
    if (GetUtils.isLengthGreaterOrEqual(password.value.text.length, 8)) {
      passwordError.value = '';
    }

    final email = useTextEditingController();
    final displayName = useTextEditingController();
    final emailError = useState('');
    void validate() {
      if (GetUtils.isEmail(email.value.text) == false) {
        emailError.value = 'not an email';
      }
    }

    void submit() async {
      validate();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.value.text, password: password.value.text);
        userCredential.user?.updateDisplayName(displayName.value.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emailError.value = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          passwordError.value = 'Wrong password provided for that user.';
        }
      } finally {
        var data = {
          "name": displayName.value.text,
          "email": email.value.text,
          "uid": FirebaseAuth.instance.currentUser?.uid
        };
        FirebaseFirestore.instance.collection('Users').add(data);
      }
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextFormField(
            controller: displayName,
            decoration: InputDecoration(label: Text('Name')),
          ),
          TextFormField(
            autocorrect: false,
            controller: email,
            decoration: InputDecoration(label: Text('Email')),
          ),
          Text(
            emailError.value,
            style: TextStyle(color: Colors.red),
          ),
          TextFormField(
            autocorrect: false,
            controller: password,
            obscureText: true,
            decoration: InputDecoration(label: Text('Password')),
            onFieldSubmitted: (text) {
              submit();
            },
          ),
          Text(
            passwordError.value,
            style: TextStyle(color: Colors.red),
          ),
          TextButton(onPressed: submit, child: Text('Submit'))
        ],
      ),
    );
  }
}
