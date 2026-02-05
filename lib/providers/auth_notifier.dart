import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intelliafy_app/exports.dart';
import 'package:intelliafy_app/services/auth_service.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  List<String> _courseNames = [];
  List<String> get courseNames => _courseNames;

  String _currentTestId = '';
  String _currentTitle = '';
  String _currentCourse = '';
  String _currentDateText = '';
  Timestamp? _currentDeadlineStamp;

  String get currentTestId => _currentTestId;

  String? _selectedCourse;
  String? get selectedCourse => _selectedCourse;

  Map<int, String> _selectedAnswers = {};
  Map<int, String> get selectedAnswers => _selectedAnswers;
  int _lastScore = 0;
  int get lastScore => _lastScore;

  void setTestData({
    required String id,
    required String title,
    required String course,
    required String dateText,
    required Timestamp? deadline,
  }) {
    _currentTestId = id;
    _currentTitle = title;
    _currentCourse = course;
    _currentDateText = dateText;
    _currentDeadlineStamp = deadline;
    notifyListeners();
  }

  AuthNotifier() {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        fetchUserData(user.uid);
        fetchCourses();
      } else {
        _userData = null;
        _courseNames = [];
      }
      notifyListeners();
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    _setLoading(true);
    try {
      _user = await _authService.signIn(email, password);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    required File? imageFile,
  }) async {
    if (imageFile == null) {
      _errorMessage = "Por favor selecciona una imagen";
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      _user = await _authService.signUp(
        fullName: fullName,
        email: email,
        password: password,
        imageFile: imageFile,
      );
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<File?> pickImage(ImageSource source) async {
    return await _authService.pickAndCropImage(source);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchUserData(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        _userData = doc.data();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCourses() async {
    _setLoading(true);
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('course').get();
      _courseNames =
          querySnapshot.docs.map((doc) => doc.get('name') as String).toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error al cargar cursos: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> uploadTest({
    required String title,
    required String course,
    required Timestamp? deadline,
  }) async {
    if (deadline == null) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('tests').add({
        'testTitle': title,
        'courseName': course,
        'deadline': deadline,
        'createdAt': Timestamp.now(),
        'authorId': user.uid,
      });

      _isLoading = false;
      notifyListeners();
      return docRef.id;
    } catch (e) {
      print("Error en uploadTest: $e");
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> uploadCompleteTest(List<Map<String, dynamic>> questions) async {
    _setLoading(true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('tests')
          .doc(_currentTestId)
          .set({
        'testId': _currentTestId,
        'uploadedBy': uid,
        'testTitle': _currentTitle,
        'author': _userData?['name'],
        'courseName': _currentCourse,
        'deadlineDate': _currentDateText,
        'deadlineDateTimeStamp': _currentDeadlineStamp,
        'questions': questions,
        'recruitment': true,
        'createdAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void setCourseFilter(String? course) {
    _selectedCourse = course;
    notifyListeners();
  }

  void setAnswer(int questionIndex, String answer) {
    _selectedAnswers[questionIndex] = answer;
    notifyListeners();
  }

  void clearAnswers() {
    _selectedAnswers = {};
    notifyListeners();
  }

  Future<bool> submitTestResult({
    required String testId,
    required List<dynamic> originalQuestions,
    required Map<int, String> studentAnswers,
  }) async {
    _setLoading(true);
    try {
      int correctCount = 0;
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) throw "Debes estar conectado para enviar el test";

      for (int i = 0; i < originalQuestions.length; i++) {
        final dynamic correctIndexRaw =
            originalQuestions[i]['correctAnswerIndex'];
        final int correctIndex = correctIndexRaw is int
            ? correctIndexRaw
            : int.parse(correctIndexRaw.toString());
        final List<dynamic> answersList = originalQuestions[i]['answers'];
        final String correctAnswerText = answersList[correctIndex].toString();

        if (studentAnswers[i] == correctAnswerText) {
          correctCount++;
        }
      }

      _lastScore = correctCount;

      await FirebaseFirestore.instance.collection('submissions').add({
        'testId': testId,
        'studentId': uid,
        'studentName': _userData?['name'] ?? 'Estudiante',
        'score': "$correctCount / ${originalQuestions.length}",
        'points': correctCount,
        'totalQuestions': originalQuestions.length,
        'submittedAt': FieldValue.serverTimestamp(),
      });

      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print("ERROR AL SUBIR: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> checkIfAlreadySubmitted(String testId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final query = await FirebaseFirestore.instance
        .collection('submissions')
        .where('testId', isEqualTo: testId)
        .where('studentId', isEqualTo: uid)
        .get();

    return query.docs.isNotEmpty;
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _userData = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
