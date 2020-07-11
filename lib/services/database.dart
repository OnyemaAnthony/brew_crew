import 'package:brewcrew/model/brews.dart';
import 'package:brewcrew/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uId;
  DatabaseService({this.uId});

  final CollectionReference brewColection = Firestore.instance.collection('brews');

  Future updateuserData(String sugar, String name, int strength)async{
    return await brewColection.document(uId).setData({
      'sugars': sugar,
      'name': name,
      'strength':strength,
    });
  }
  UserData _userDataFromSnapShot(DocumentSnapshot snapshot){
    return UserData(
      uId:  uId,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
     strength: snapshot.data['strength'],

    );
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return Brew(
        name: doc.data['name'] ?? 0,
        sugars: doc.data['sugars'] ?? '0',
        strength: doc.data['strength'] ?? 0,
      );
    }).toList();
  }
  Stream<List<Brew>> get brews {
    return  brewColection.snapshots().
    map(_brewListFromSnapshot);
  }

  //get user document stream

Stream <UserData> get userData {
    return brewColection.document(uId).snapshots().map(_userDataFromSnapShot);
}



}