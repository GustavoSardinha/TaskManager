import 'package:flutter/material.dart';
import 'package:projeto_flutter/repositories/task_repository.dart';
import 'package:projeto_flutter/widgets/task_item.dart';

import '../Models/task.dart';

class HomePage extends StatefulWidget {
    const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState(){
    super.initState();
    taskRepository.getTaskList().then((list) => {setState(() { tasks = list; })});
  }
  final TextEditingController tasksController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();
  List<Task> tasks = [];
  Task? deletedTask;
  int? deletedTaskPos;
  void addTask() {
    String text = tasksController.text;
    DateTime date = DateTime.now();
    Task task = Task(title: text, date: date);
    setState(() { tasks.add(task); });
    taskRepository.saveTaskList(tasks);
    tasksController.clear();
  }
  void clearTasks()
  {
    setState(() { tasks.clear(); });
    taskRepository.saveTaskList(tasks);
  }
  void showDeleteDialog(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Limpar Tudo?"),
          content: const Text("Tem certeza que quer apagar todas as tarefas?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Cancelar")
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  clearTasks();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Limpar tudo")
            ),
          ],
        )
    );
  }
  void fieldChange(String s)
  {
    setState(() {  });
  }
  void onDelete(Task tsk)
  {
    deletedTask = tsk;
    deletedTaskPos = tasks.indexOf(tsk);

    setState(() { tasks.remove(tsk); });
    taskRepository.saveTaskList(tasks);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${tsk.title} removida com sucesso!',
          style: const TextStyle(
            color: Colors.black,
          )
      ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: "Desfazer",
            textColor: Colors.red,
            onPressed: () {
              setState(() { tasks.insert(deletedTaskPos!, deletedTask!); });
              taskRepository.saveTaskList(tasks);
            }),
            duration: const Duration(seconds: 4),
      ),
    );
  }
  get isEmptyField { return (tasksController.text == '');}

  get isOneTask { return tasks.length == 1;}

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.task,
                        size: 35,

                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: Center(
                          child: Title(color: Colors.black, child: const Text(
                              "Gerenciador de Tarefas",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              ),
                          )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64,),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                            controller: tasksController,
                            onChanged: fieldChange,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Adicione uma tarefa",
                                hintText: "Ex. Estudar"
                                    ""
                            ),
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: isEmptyField ? null : addTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
    
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                          for(Task tk in tasks)
                            TaskItem(
                                task:tk,
                              onDelete: onDelete,
                            )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                       Expanded(
    
                        child: Center(
                          child: Text(
                           !isOneTask ? 'Você tem ${tasks.length.toString()} tarefas pendentes' : 'Você tem ${tasks.length.toString()} tarefa pendente' ,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: showDeleteDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        child: const Text(
                          "Limpar tudo",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
          )
      ),
    ),
  );
}

}
