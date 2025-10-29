import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', (){
    final provider = MockAuthProvider();
    test('should not be initializec to begin with', (){
      expect(provider.isInitialized, false);
    });
    test('cannot logout if not initialized', (){
      expect(provider.logOut(),throwsA(TypeMatcher<NotInitializedException>() ));
    });
    test('should be able to be initalized', () async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('user should be null after initialization', (){
      expect(provider.currentUser, null);
    });
    test('should initialize in less than two seconds', () async{
      await provider.initialize();
      expect(provider.isInitialized, true);

    },
    timeout: const Timeout(Duration(seconds: 2)),
    );

    test('create user should delegate to login function', () async {
      final bademail=provider.createUser(email: 'bobo12@gmail.com', password: 'abc');
      expect(bademail, throwsA(TypeMatcher<UserNotFoundAuthException>()));
   final badpassword=provider.createUser(email: 'somebody@gmail.com', password: '123');
    expect(badpassword, throwsA(TypeMatcher<InvalidCredentialAuthException>()));
    final user= await provider.createUser(email: 'boo', password: 'yoyo');
     expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);

     });
     test('login user should be able to get verified', (){
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
     });
    test('should be able to login and logout again', () async{
      await provider.logOut();
      await provider.login(email: "email", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });


  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
    
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'bobo12@gmail.com') throw UserNotFoundAuthException();
    if (password == '123') throw InvalidCredentialAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async{
    if (!_isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newuser = AuthUser(isEmailVerified: true);
    _user = newuser;
   
  }
}
