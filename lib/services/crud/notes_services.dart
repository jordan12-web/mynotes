import 'dart:async';

import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' ;
import 'package:path/path.dart' show join;


class NotesServices {
  Database? _db;
 
 List<DataBaseNotes> _notes = [];

static final NotesServices _shared = NotesServices._sharedInstance();
NotesServices._sharedInstance();
factory NotesServices() => _shared;

 final _notesStreamController = StreamController<List<DataBaseNotes>>.broadcast();
Stream<List<DataBaseNotes>> get allNotes => _notesStreamController.stream;


Future<DataBaseUser> getOrCreateUser({required String email}) async {
  try{
    final user = await getUser(email: email);
    return user;
  }on CouldNotFindUser{
    final createdUser = await createUser(email: email);
    return createdUser;
  }catch(e){
    rethrow;
  }
}


 Future<void> __cacheNotes() async {
  final allNotes = await getAllNotes();
  _notes = allNotes.toList();
  _notesStreamController.add(_notes);
 }


Future<DataBaseNotes> updateNote({required DataBaseNotes note, required String text}) async {
 await _ensureDBIsOpen();
 final db = _getDatabaseOrThrow();
 
 await getNote(id: note.id);

final updateCount = await db.update(noteTable , {
  textColumn: text,
  isSyncedWithCloudColumn: 0,
 });
if(updateCount == 0){
  throw CouldNotUpdateNote();
}else{
  final updatedNote = await getNote(id: note.id);
_notes.removeWhere((note)=> note.id == updatedNote.id);
_notes.add(updatedNote);
_notesStreamController.add(_notes);
  return updatedNote;
}
}


Future<Iterable<DataBaseNotes>> getAllNotes() async {
  await _ensureDBIsOpen();
  final db = _getDatabaseOrThrow();
  final notes = await db.query(noteTable);
 return notes.map((n) => DataBaseNotes.fromRow(n));
}


Future<DataBaseNotes> getNote({required int id}) async {
 await _ensureDBIsOpen();
  final db = _getDatabaseOrThrow();
  final notes = await db.query(noteTable, where: 'id = ?', whereArgs: [id],limit: 1,);
  if(notes.isEmpty){
    throw CouldNotFindNote();
  }
  final note = DataBaseNotes.fromRow(notes.first);
  _notes.removeWhere((note)=> note.id == id);
  _notes.add(note);
  _notesStreamController.add(_notes);
  return note;
}


Future<int> deleteAllNotes() async {
  await _ensureDBIsOpen();
 final db = _getDatabaseOrThrow();
 final numberOfDeletions = await db.delete(noteTable);
 _notes = [];
 _notesStreamController.add(_notes);
 return numberOfDeletions;
}


Future<void> deleteNote({required int id}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(noteTable,where: 'id = ?',whereArgs: [id],);
    if(deleteCount == 0){
      throw CouldNotDeleteUser();
    }else{
      _notes.removeWhere((notes)=>notes.id == id);
      _notesStreamController.add(_notes);
    }
}  


Future<DataBaseNotes> createNote({required DataBaseUser owner}) async {
  await _ensureDBIsOpen();
  final db = _getDatabaseOrThrow();

  //making sure that the owner exists in the database with the correct id the same as the one we retrieved

final dbUser = await getUser(email: owner.email);
if(dbUser != owner){
  throw CouldNotFindUser();
}
const text = '';

final noteId = await db.insert(noteTable, {
  userIdColumn: owner.id,
  textColumn: text,
  isSyncedWithCloudColumn: 1,
});
final note = DataBaseNotes(id: noteId, userId: owner.id, text: text, isSyncedWithCloud: true,);

_notes.add(note);
_notesStreamController.add(_notes);
return note;
}  


Future<DataBaseUser> getUser({required String email}) async {
  await _ensureDBIsOpen();
  final db = _getDatabaseOrThrow();
  final result = await db.query(userTable,limit: 1,where: 'email = ?',whereArgs: [email.toLowerCase()]);
 if(result.isEmpty){
  throw CouldNotFindUser();
 }else{
  return DataBaseUser.fromRow(result.first);
 } 

} 
   

Future<DataBaseUser> createUser({required String email}) async {
 await _ensureDBIsOpen();
 final db = _getDatabaseOrThrow();
 final result = await db.query(userTable,limit: 1,where: 'email = ?',whereArgs: [email.toLowerCase()]);
 if(result.isNotEmpty){
  throw UserAlreadyExists();
 }
 
 final userId = await db.insert(userTable, {
  emailColumn : email.toLowerCase(), 
 });
 return DataBaseUser(id: userId, email: email);

}   


Future<void> deleteUser({required String email}) async{
  await _ensureDBIsOpen();
        final db = _getDatabaseOrThrow();
        final deleteCount = await db.delete(userTable,where: 'email = ?',whereArgs: [email.toLowerCase()]);
    if(deleteCount!=1){
      throw UnableToDeleteUser();
    }
}


Database _getDatabaseOrThrow(){
    final db = _db;

    if(db==null){
      throw DatabaseIsNotOpen();
    }else{
      return db;
    }
    

   }


Future<void> close() async{
  final db = _db;
  if(db == null){
    throw DatabaseIsNotOpen();
  }
  else{
    await db.close();
    _db = null;
  }
}


Future<void> _ensureDBIsOpen() async{
try{
  await open();
} on DatabaseAlreadyOpenExcetion{
//ignore the exception
}
}


Future<void> open() async {
    if(_db != null){
      throw DatabaseAlreadyOpenExcetion();
    }
    try{
      final docsPath = await getApplicationDocumentsDirectory();
      final dbpath = join(docsPath.path,dbName);
      final db = await openDatabase(dbpath);
      _db = db;

      // create user table
await db.execute(createUserTable);
   
   
  //create note table
await db.execute(createNoteTable);
 await __cacheNotes();

    }on MissingPlatformDirectoryException{
      throw UnableToGetDocumentsDirectory();
    }
   }
}

class DataBaseUser{
  final int id;
  final String email;

  DataBaseUser({required this.id, required this.email});
  
  
  DataBaseUser.fromRow(Map<String,Object?> map) : id = map[idColumn] as int, email = map[emailColumn] as String; 
  
  @override
  String toString() => 'person, ID = $id, email = $email';

@override
  bool operator == (covariant DataBaseUser other) => id == other.id;
  
  @override

  int get hashCode => id.hashCode;
  
}

class DataBaseNotes{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DataBaseNotes({required this.id, required this.userId, required this.text, required this.isSyncedWithCloud});

   DataBaseNotes.fromRow(Map<String,Object?> map) : id = map[idColumn] as int, userId = map[userIdColumn] as int,text = map[textColumn] as String, isSyncedWithCloud = map[isSyncedWithCloudColumn]==1 ? true : false; 

@override
String toString() => 'notes, ID = $id, userid = $userId, isSyncedWithCloud = $isSyncedWithCloud';

}

const noteTable = 'note';
const userTable = 'user';
const dbName = 'notes.db';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const idColumn = 'id';
const emailColumn = 'email';
const createUserTable = 
            '''CREATE TABLE IF NOT EXISTS "user" (
              "id"	INTEGER NOT NULL,
              "email"	TEXT NOT NULL UNIQUE,
              PRIMARY KEY("id" AUTOINCREMENT)
      ); '''
;
const createNoteTable = '''CREATE TABLE "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
) ''';