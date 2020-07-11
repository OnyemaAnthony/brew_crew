

import 'package:brewcrew/model/user.dart';
import 'package:brewcrew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uId: user.uid): null;

  }
  Future registerWithEmailAndPassword(String email, String password)async{

    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uId: user.uid).updateuserData('0', 'new crew member', 100);


      return _userFromFirebaseUser(user);

    }catch(e){
     print(e.toString());
     return null;
    }
  }
  Stream<User> get user{
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);


    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    return await _auth.signOut();
  }

  Future signInWithEmailAndPassword(String email, String password)async{

    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }
}
