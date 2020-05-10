import 'dart:async';
import 'package:agenda_contatos/helpers/db_helper.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

final List<ColumnTypes> listColumnsTypes= [
  ColumnTypes(idColumn,"INTEGER","PRIMARY KEY AUTOINCREMENT"),
  ColumnTypes(nameColumn,"TEXT",""),
  ColumnTypes(emailColumn,"TEXT",""),
  ColumnTypes(phoneColumn,"TEXT",""),
  ColumnTypes(imgColumn,"TEXT","")
];
class ContactHelper extends DbHelper{

  static final ContactHelper _instance = ContactHelper.internal();  
  factory ContactHelper() => _instance;    
  ContactHelper.internal() : super(contactTable,listColumnsTypes);

  Future<Contact> saveContact(Contact contact) async {
    return await save<Contact>(contact);
  }

  Future<Contact> getContact(int id) async{
    return await getOne<Contact>("$idColumn = ?", [id]);
  }

   Future<int> deleteContact(int id) async {    
    return await delete("$idColumn = ?", [id]);
  }

  Future<int> updateContact(Contact contact) async {    
    return await update<Contact>(contact,"$idColumn = ?",[contact.id]);
  }

  Future<List> getAllContacts() async{
    return await getAll<Contact>();    
  }
}


class Contact extends GenericClass{
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String,dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override 
  String toString() {
    return "Contact(id = $id, name: $name, email: $email, phone: $phone, img: $img)";    
  }
  
}


/*  
  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath,"contactsnew.db");
    return openDatabase(path, version:  1, onCreate: (Database db, int newerVersion) async{
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT,"
        " $phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }
}*/