import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'factory.dart';


 class DbHelper {
  Database _db;
  String tableName;
  List<ColumnTypes> listColumnsTypes;
  String _databasePath;
  String _path;


  DbHelper(String tableName,List<ColumnTypes> listColumnsTypes) {
    this.tableName = tableName;
    this.listColumnsTypes = listColumnsTypes;
  }

  Future<String> get databasePath async {
    _databasePath = await getDatabasesPath();
    return _databasePath;
  }
  
  Future<String> get path async {
    _path = join(await databasePath,"contactsnew.db");
    return _path;
  }
  

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;      
    }
  }

  Future<Database> initDb() async {   
    return openDatabase(await path, version:  1, onCreate: (Database db, int newerVersion) async{
      String columns = "";
      for (ColumnTypes colType in listColumnsTypes){
        columns += (columns != "") ? ",${colType.name} ${colType.type} ${colType.argument}" : "${colType.name} ${colType.type} ${colType.argument}";
      }           
      await db.execute("CREATE TABLE $tableName($columns)");     
    });
  }
 
  
  Future<bool> tableExists() async {
     Database dBase = await db;     
     final tabela = await dBase.rawQuery("SELECT * FROM sqlite_master WHERE name ='$tableName' and type='table'");
     return ((tabela != null) && (tabela.length > 0));     
  }

  Future dropTable() async {    
    Database dBase = await db;          
    await dBase.execute("DROP TABLE $tableName");
  }

  Future create() async {    
    Database dBase = await db;  
    String columns = "";
    for (ColumnTypes colType in listColumnsTypes){
      columns += (columns != "") ? ",${colType.name} ${colType.type} ${colType.argument}" : "${colType.name} ${colType.type} ${colType.argument}";
    }     
    await dBase.execute("CREATE TABLE $tableName($columns)");
  }

  Future<T> save<T extends GenericClass>(T object) async {
    Database dBase = await db;
    var map = object.toMap();    
    object.id =await dBase.insert(tableName, map);
    return object;
  }

  Future<T> getOne<T extends GenericClass>(String where,List<dynamic> argumentos) async{
    Database dBase = await db;
    List<Map> maps = await dBase.query(
      tableName,
      columns: listColumnsTypes.map((value) => value.name).toList(),      
      where: where,
      whereArgs: argumentos
    );
    if(maps.length > 0){
      return Factories.getObject(maps.first, T.runtimeType.toString())[ T.runtimeType.toString()];
    } else {
      return null;
    }
  }

  Future<int> delete(String where,List<dynamic> arguments) async {
    Database dBase = await db;
    return await dBase.delete(tableName, where: where,whereArgs: arguments);
  }

  Future<int> update<T extends GenericClass>(T object,String where,List<dynamic> arguments) async {
    Database dBase = await db;
    return await dBase.update(tableName, object.toMap(), where: where,whereArgs: arguments);
  }

  Future<List> getAll<T>() async{    
    Database dBase = await db;
    List listMap = await dBase.rawQuery("SELECT * FROM $tableName");
    List<T> list = List();
    String className =  T.toString();
    for(Map m in listMap){
      list.add(Factories.getObject(m,className)[className]);
    }
    return list;
  }

  Future<int> getNumber() async {
    Database dBase = await db;
    return Sqflite.firstIntValue(await dBase.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dBase = await db;
    dBase.close();
  }

}

abstract class GenericClass {  
  int id;  
  Map toMap();
}

class ColumnTypes {
  String name;
  String type;
  String argument;

  ColumnTypes(this.name,this.type,this.argument);
}