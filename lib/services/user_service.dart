import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/auth_service.dart';

class UserCard {
  UserCard({
    this.pfp,
    this.followers,
    this.likedRoutes,
    this.userLevel,
    this.userXp,
    this.name,
  });

  String? pfp;
  List<String>? followers;
  List<String>? likedRoutes;
  int? userLevel;
  int? userXp;
  String? name;
}

class UserService {
  final RouteCollection = FirebaseFirestore.instance.collection("routes");
  final UserCollection = FirebaseFirestore.instance.collection("users");
  final UserDetailsCollection = FirebaseFirestore.instance.collection("userdetails");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<UserCard?> getRouteCard(String UserId) async {
    UserCard? uc = UserCard();
    try {
      var docref1 = await UserCollection.doc(UserId).get();
      var querySnapshot = await UserDetailsCollection.where("userId",
          isEqualTo: UserId)
          .get();

      uc.pfp= docref1.get('profileImage');
      uc.name=docref1.get('name');
      uc.userLevel=querySnapshot.docs.first.get('userlevel');
      uc.userXp=querySnapshot.docs.first.get('userxp');
      uc.followers=querySnapshot.docs.first.get('followers') as List<String>;
      uc.likedRoutes=querySnapshot.docs.first.get('likedRoutes') as List<String>;


    } catch (e) {
      print("Error fetching UserCard: $e");
    }

    return uc;
    }





}