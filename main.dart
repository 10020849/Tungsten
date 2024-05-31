import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(const Color(0xFF90BEE3)),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Tungsten')),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 42, 91),
      body: Stack(
        children: [
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/tungsten_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/tungsten_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              title: const Text(
                'Tungsten',
                style: TextStyle(
                  fontFamily: 'Legion Sabina',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Legion Sabina',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 42, 91),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Image.asset(
              'assets/tungsten_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _roleController.text;

    if (email.isNotEmpty && password.isNotEmpty && role.isNotEmpty) { 
      if (role == 'Student') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const StudentDashboardPage()),
        );
      } else if (role == 'Teacher') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TeacherDashboardPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid role. Please enter Student or Teacher.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email, password, and role.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Container(
          width: 300, 
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: _roleController,
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('LOGIN'),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Have no account? ',
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  void _signup() {
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _roleController.text;
    if (email.isNotEmpty && password.isNotEmpty && role.isNotEmpty) { 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email, password, and role.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Page'),
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: _roleController,
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Chemistry Level'),
                  items: const [
                    DropdownMenuItem(value: 'Chemistry in Community', child: Text('Chemistry in Community')),
                    DropdownMenuItem(value: 'Chemistry I', child: Text('Chemistry I')),
                    DropdownMenuItem(value: 'Honors Chemistry I', child: Text('Honors Chemistry I')),
                    DropdownMenuItem(value: 'AP Chemistry', child: Text('AP Chemistry')),
                  ],
                  onChanged: (value) {
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signup,
                  child: const Text('SIGNUP'),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Have an account? ',
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({Key? key}) : super(key: key);

  @override
  _StudentDashboardPageState createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  final TextEditingController _classCodeController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();
  List<String> _joinedClasses = []; 

  void _joinClass() {
    String classCode = _classCodeController.text;
    String studentName = _studentNameController.text;
    String? className = ClassManager().getClass(classCode);
    if (className != null && studentName.isNotEmpty) {
      setState(() {
        _joinedClasses.add(className); 
        ClassManager().addStudentToClass(classCode, studentName, 0); 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class joined successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid class code or empty student name.')),
      );
    }
  }

  void _navigateToQuizScreen(String className) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => QuizScreen(className: className)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the Student Dashboard!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Class Code:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _classCodeController,
                    decoration: const InputDecoration(
                      hintText: 'Enter class code',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Student Name:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _studentNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _joinClass,
                  child: const Text('Join'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Your Classes:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _joinedClasses.length,
                itemBuilder: (BuildContext context, int index) {
                  String className = _joinedClasses[index];
                  return GestureDetector(
                    onTap: () {
                      _navigateToQuizScreen(className);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 33, 243, 44),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          className,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String className;

  const QuizScreen({Key? key, required this.className}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String _selectedMode = 'Quiz';
  String _selectedCategory = 'Atomic Structure';
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startMusic() async {
    await audioPlayer.play('assets/manufacturing-bliss.mp3', isLocal: true);
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className),
      ),
      body: Center(
        child: Container(
          width: 300, 
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), 
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Mode',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedMode,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMode = newValue!;
                  });
                },
                items: <String>['Quiz', 'Puzzle']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: <String>[
                  'Atomic Structure',
                  'Periodic Table',
                  'Chemical Bonding',
                  'Mole Concept',
                  'States of Matter',
                  'Thermodynamics',
                  'Thermochemistry',
                  'Chemical Equilibrium',
                  'Redox Reactions',
                  'Hydrogen'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  startMusic();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(
                        mode: _selectedMode,
                        category: _selectedCategory,
                      ),
                    ),
                  ).then((_) => audioPlayer.stop());
                },
                child: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({Key? key}) : super(key: key);

  @override
  _TeacherDashboardPageState createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  final TextEditingController _classNameController = TextEditingController();
  List<String> _createdClasses = [];  
  List<String> _classCodes = []; 

  String generateClassCode() {
    var rng = Random();
    return (rng.nextInt(900000) + 100000).toString();
  }

  void _createClass() {
    String className = _classNameController.text;
    String classCode = generateClassCode();
    if (className.isNotEmpty) {
      setState(() {
        _createdClasses.add(className); 
        _classCodes.add(classCode);
        ClassManager().addClass(classCode, className);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Class created successfully! Class code: $classCode')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a class name.')),
      );
    }
  }

  void _viewClassDetails(String classCode) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ClassDetailsPage(classCode: classCode)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the Teacher Dashboard!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Class Name:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _classNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter class name',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _createClass,
                  child: const Text('Create Class'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Classes:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _createdClasses.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text('${_createdClasses[index]}'),
                      subtitle: Text('Code: ${_classCodes[index]}'),
                      onTap: () {
                        _viewClassDetails(_classCodes[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClassDetailsPage extends StatelessWidget {
  final String classCode;

  const ClassDetailsPage({Key? key, required this.classCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final className = ClassManager().getClass(classCode);
    final students = ClassManager().getStudentsInClass(classCode);

    return Scaffold(
      appBar: AppBar(
        title: Text('$className - Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Students:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (BuildContext context, int index) {
                  final student = students[index];
                  return Card(
                    child: ListTile(
                      title: Text(student['name']),
                      subtitle: Text('Score: ${student['score']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String mode;
  final String category;

  const GameScreen({Key? key, required this.mode, required this.category}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the atomic number of hydrogen?',
      'options': ['1', '2', '3', '4'],
      'correctAnswerIndex': 0
    },
    {
      'question': 'Which element has the symbol He?',
      'options': ['Helium', 'Hydrogen', 'Hassium', 'Holmium'],
      'correctAnswerIndex': 0
    },
    {
      'question': 'What is the chemical symbol for water?',
      'options': ['O2', 'H2O', 'CO2', 'H2O2'],
      'correctAnswerIndex': 1
    },
    {
      'question': 'Which element is a noble gas?',
      'options': ['Nitrogen', 'Oxygen', 'Neon', 'Carbon'],
      'correctAnswerIndex': 2
    },
    {
      'question': 'What is the atomic number of carbon?',
      'options': ['6', '7', '8', '9'],
      'correctAnswerIndex': 0
    },
    {
      'question': 'Which element has the chemical symbol Na?',
      'options': ['Sodium', 'Nitrogen', 'Nickel', 'Neon'],
      'correctAnswerIndex': 0
    },
    {
      'question': 'What is the chemical symbol for gold?',
      'options': ['Au', 'Ag', 'Pb', 'Fe'],
      'correctAnswerIndex': 0
    },
    {
      'question': 'Which element is represented by the symbol O?',
      'options': ['Osmium', 'Oxygen', 'Oganesson', 'Oxonium'],
      'correctAnswerIndex': 1
    },
  ];

  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  int score = 0;
  int correctAnswers = 0;
  Timer? countdownTimer;
  int timerSeconds = 30; 
  bool gameOver = false; 

  @override
  void initState() {
    super.initState();
    if (widget.mode == "puzzles") {
      timerSeconds = 10; 
      startTimer();
    }
  }

  void startTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerSeconds > 0) {
        setState(() {
          timerSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          gameOver = true; 
        });
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedAnswerIndex = null; 
        if (widget.mode == "puzzles") {
          timerSeconds = 10;
          startTimer();
        }
      } else {
        gameOver = true; 
      }
    });
  }

  void updateScore(bool correct) {
    setState(() {
      if (correct) {
        score += 100;
        correctAnswers++;
      } else {
        score -= 50;
      }
    });
  }

  void checkAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
      bool isCorrect = index == questions[currentQuestionIndex]['correctAnswerIndex'];
      updateScore(isCorrect);
      if (isCorrect) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Correct!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} - ${widget.mode}"),
      ),
      body: Center(
        child: gameOver
            ? buildGameOverScreen()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.mode == "puzzles")
                    Text("Time: $timerSeconds", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("Score: $score", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  buildQuestionSection(),
                ],
              ),
      ),
    );
  }

  Widget buildQuestionSection() {
    var currentQuestion = questions[currentQuestionIndex];
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentQuestion['question'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...currentQuestion['options'].asMap().entries.map((entry) {
            int idx = entry.key;
            String text = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ElevatedButton(
                onPressed: selectedAnswerIndex == null && !gameOver
                    ? () {
                        checkAnswer(idx);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedAnswerIndex != null
                      ? (idx == currentQuestion['correctAnswerIndex']
                          ? Colors.green
                          : idx == selectedAnswerIndex
                              ? Colors.red
                              : Colors.grey)
                      : null,
                ),
                child: Text(text),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedAnswerIndex != null && !gameOver
                ? () {
                    nextQuestion();
                  }
                : null,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget buildGameOverScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Game Over!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 24)),
        Text("Final Score: $score", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text("Questions Correct: $correctAnswers/${questions.length}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Game Over'),
        ),
      ],
    );
  }
}

class ClassManager {
  static final ClassManager _instance = ClassManager._internal();

  factory ClassManager() {
    return _instance;
  }

  ClassManager._internal();

  final Map<String, String> _classes = {}; 
  final Map<String, List<Map<String, dynamic>>> _studentsInClass = {}; 

  void addClass(String classCode, String className) {
    _classes[classCode] = className;
    _studentsInClass[classCode] = [];
  }

  String? getClass(String classCode) {
    return _classes[classCode];
  }

  void addStudentToClass(String classCode, String studentName, int score) {
    if (_studentsInClass.containsKey(classCode)) {
      _studentsInClass[classCode]!.add({'name': studentName, 'score': score});
    }
  }

  List<Map<String, dynamic>> getStudentsInClass(String classCode) {
    return _studentsInClass[classCode] ?? [];
  }
}
