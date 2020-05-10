import 'package:agenda_contatos/helpers/contact_helper.dart';

class Factories{    
  static Map<String,dynamic> getObject(Map map,String className)  {
    switch (className) {
      case "Contact":
          return {'Contact': Contact.fromMap(map)};       
      default:
        return null;
    }    
  }
}