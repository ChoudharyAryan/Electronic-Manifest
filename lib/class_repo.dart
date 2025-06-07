import 'dart:developer';
import 'package:manifest/class_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClassRepo {
  Future<List<Class>> fetchClasses() async {
    try {
      List<Map> response = [];
      response = await Supabase.instance.client.from('categories').select('*');
      List<Class> myClasses = [];
      for (Map myClass in response) {
        if (myClass['name'] != null) {
          myClasses.add(Class.fromJson(myClass));
        }
      }
      return myClasses;
    } catch (e) {
      log('this is the error in the fetchClasses function in class_repo.dart ${e.toString()}');
      log(e.toString());
      return [];
    }
  }

  void addClass(Map<String, dynamic> data) async {
    try {
      final response = await Supabase.instance.client
          .from('categories')
          .insert(data)
          .select();
      if (response.isEmpty) {
        log("Error: No data returned from the insert operation.");
      } else {
        log("Data inserted successfully: $response");
      }
    } catch (e) {
      log("this is the error in the addClass function in class_repo.dart ${e.toString()}");
    }
  }
}
