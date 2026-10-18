import 'package:flutter/material.dart';
import 'package:todo_core/todo_core.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoHomePage(title: 'Eisenhower Todo'),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({required this.title, super.key});

  final String title;

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  late TaskRepository _taskRepo;
  late TopicRepository _topicRepo;

  @override
  void initState() {
    super.initState();
    _taskRepo = CoreTaskRepository();
    _topicRepo = CoreTopicRepository();
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
        Task(id: newId, title: 'New Quick Task', importance: 0),
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
          // TODO: Handle default tpoics in the core library!
          final defaultTopic = Topic(id: "def", name: "default");
          final topic = item.topicId != null
              ? _topicRepo.getTopic(item.topicId!)
              : defaultTopic;
          final topicColor = topic?.color;
          final color = Color.fromARGB(
            topicColor!.a,
            topicColor.r,
            topicColor.g,
            topicColor.b,
          );

          return ListTile(
            leading: Checkbox(
              value: item.isClosed,
              onChanged: (_) => _toggleTask(item.id),
            ),
            title: Text(
              item.title,
              style: TextStyle(
                decoration: item.isClosed ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(item.description!),
            trailing: Chip(
              label: Text(
                item.description!,
                style: const TextStyle(color: Colors.white, fontSize: 11),
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
