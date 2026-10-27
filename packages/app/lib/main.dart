import 'package:flutter/material.dart';
import 'package:whatnow_core/whatnow_core.dart';

void main() {
  runApp(const WhatnowApp());
}

class WhatnowApp extends StatelessWidget {
  const WhatnowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatnow App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WhatnowHomePage(title: 'Eisenhower Todo'),
    );
  }
}

class WhatnowHomePage extends StatefulWidget {
  const WhatnowHomePage({required this.title, super.key});

  final String title;

  @override
  State<WhatnowHomePage> createState() => _WhatnowHomePageState();
}

class _WhatnowHomePageState extends State<WhatnowHomePage> {
  late TaskRepository _taskRepo;

  @override
  void initState() {
    super.initState();
    _taskRepo = CoreTaskRepository();
  }

  void _toggleTask(String id) {
    setState(() {
      _taskRepo = _taskRepo.toggleTask(id);
    });
  }

  void _addItem() {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _taskRepo = _taskRepo.addTask(
        Task(id: newId, title: 'New Quick Task', importance: 0).validate(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final corePrio = CorePriority();
    final prioritized = _taskRepo.prioritizedItems(corePrio);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: prioritized.length,
        itemBuilder: (context, index) {
          final item = prioritized[index];
          const defaultTopic = Topic.unnamed;
          final topicColor = defaultTopic.color;
          final color = Color.fromARGB(
            topicColor.a,
            topicColor.r,
            topicColor.g,
            topicColor.b,
          );
          final description = item.description;

          return ListTile(
            leading: Checkbox(
              value: item.isClosed,
              onChanged: (_) => _toggleTask(item.id),
            ),
            title: Text(
              item.title,
              style: TextStyle(
                decoration: item.isClosed
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            subtitle: description != null ? Text(description) : null,
            trailing: Chip(
              label: Text(
                item.topicId,
                style: const TextStyle(color: Colors.black87, fontSize: 11),
              ),
              backgroundColor: color,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
