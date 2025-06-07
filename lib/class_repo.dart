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
      log('THIS IS THE ERROR IN CLASSREPO.DART FILE');
      log(e.toString());
      return [];
    }
  }

  void addClass(Map data){}
}
