import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(SchoolSyncApp());

class SchoolSyncApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SchoolSync',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SchoolSync', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Bayview High • Port Elizabeth', style: TextStyle(fontSize: 12)),
          ],
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back, Liyema 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Grade 12 • Class 12A • No paper needed today', style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 20),
            // Announcement Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(Icons.campaign, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(child: Text('Announcement: Matric photos tomorrow at 10am. No late coming!', style: TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('What do you want to do?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _menuCard(context, 'Timetable', Icons.schedule, Colors.blue, TimetableScreen()),
                  _menuCard(context, 'My Marks', Icons.grade, Colors.green, MarksScreen()),
                  _menuCard(context, 'Homework', Icons.book, Colors.purple, HomeworkScreen()),
                  _menuCard(context, 'Attendance', Icons.check_circle, Colors.teal, AttendanceScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.3))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// --- TIMETABLE ---
class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});
  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  List timetable = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTimetable();
  }

  Future<void> fetchTimetable() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/timetable'));
      if (response.statusCode == 200) {
        setState(() {
          timetable = jsonDecode(response.body);
          loading = false;
        });
      }
    } catch (e) {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Timetable - Live from Python')),
      body: ListView.builder(
        itemCount: timetable.length,
        itemBuilder: (context, index) {
          final t = timetable[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.schedule, color: Colors.blue),
              title: Text(t['subject']?.toString() ?? 'Subject'),
              subtitle: Text(t['day']?.toString() ?? ''),
              trailing: Text(t['time']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}

// --- MARKS ---

class MarksScreen extends StatefulWidget {
  const MarksScreen({super.key});
  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  List marks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchMarks();
  }

  Future<void> fetchMarks() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/marks'));
      if (response.statusCode == 200) {
        setState(() {
          marks = jsonDecode(response.body);
          loading = false;
        });
      }
    } catch (e) {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('My Marks - Live from Python')),
      body: ListView.builder(
        itemCount: marks.length,
        itemBuilder: (context, index) {
          final m = marks[index];
          return Card(
            child: ListTile(
              title: Text(m['subject']),
              trailing: Text(m['mark'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          );
        },
      ),
    );
  }
}

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});
  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  List homework = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchHomework();
  }

  Future<void> fetchHomework() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/homework'));
      if (response.statusCode == 200) {
        setState(() {
          homework = jsonDecode(response.body);
          loading = false;
        });
      }
    } catch (e) {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Homework - Live from Python')),
      body: ListView.builder(
        itemCount: homework.length,
        itemBuilder: (context, index) {
          final h = homework[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.assignment, color: Colors.orange),
              title: Text(h['task']?.toString() ?? h['title']?.toString() ?? 'Homework'),
              subtitle: Text(h['subject']?.toString() ?? ''),
              trailing: Text(h['due']?.toString() ?? h['due_date']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List attendance = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/attendance'));
      if (response.statusCode == 200) {
        setState(() {
          attendance = jsonDecode(response.body);
          loading = false;
        });
      }
    } catch (e) {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance - Live from Python')),
      body: ListView.builder(
        itemCount: attendance.length,
        itemBuilder: (context, index) {
          final a = attendance[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(a['subject']?.toString() ?? 'Subject'),
              subtitle: Text('${a['present']} / ${a['total']} days present'),
              trailing: Text(a['percentage']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          );
        },
      ),
    );
  }
}