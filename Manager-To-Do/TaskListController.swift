//
//  TaskListController.swift
//  Manager-To-Do
//
//  Created by Viktor Kizera on 30.04.2024.
//

import UIKit

class TaskListController: UITableViewController {
    // хранилище задач
    var tasksStorage: TasksStorageProtocol = TasksStorage() // коллекция задач
    var tasks: [TaskPriority:[TaskProtocol]] = [:] {
        didSet {
             // сортування списка задач
            for (taskGroupPriority, taskGroup) in tasks {
                tasks[taskGroupPriority] = taskGroup.sorted {
                    task1, task2 in
            let task1position = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
            let task2position = tasksStatusPosition.firstIndex(of:  task2.status) ?? 0
            return task1position < task2position
                }
            }
        }
    }
    // порядок отображения секций по типам
    // индекс в массиве соответствует индексу секции в таблице
    var sectionsTypesPosition: [TaskPriority] = [.important, .normal]
    var tasksStatusPosition: [TaskStatus] = [.planned, .completed]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // загружаємо задачі
        loadTasks()
        // кнопка активації режиму редагування
        navigationItem.leftBarButtonItem = editButtonItem
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateScreen" {
            let destination = segue.destination as! TaskEditController
            destination.doAfterEdit = { [unowned self] title, type, status in
                let newTask = Task(title: title, type: type, status: status)
                tasks[type]?.append(newTask)
                tableView.reloadData()
            }
        }
    }
   private func loadTasks() {
       sectionsTypesPosition.forEach { taskType in tasks[taskType] = []
       }
       // загрузка и разбор задач из хранилища
       tasksStorage.loadTasks().forEach { task in
       tasks[task.type]?.append(task) }
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // секція з якої відбувається переміщення
        let taskTypeFrom = sectionsTypesPosition[sourceIndexPath.section]
        // секція в яку відбудеться переміщення
        let taskTypeTo = sectionsTypesPosition[destinationIndexPath.section]
        // безпечно витягуємо задачу, тим самим копіюємо її
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return
        }
        // видаляємо задачу з того місця, звідки вона була перетягнута
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        // встановлюємо задачу в нову позицію (нове місце)
        tasks[taskTypeTo]?.insert(movedTask, at: destinationIndexPath.row)
        // якщо секція змінилася, то змінюємо тип задачі відповідно новій позиції
        if taskTypeFrom != taskTypeTo {
            tasks[taskTypeTo]![destinationIndexPath.row].type = taskTypeTo
        }
        // оновляємо всі таблицю (дані)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let taskType = sectionsTypesPosition[indexPath.section]
        // видаляємо задачу
        tasks[taskType]?.remove(at: indexPath.row)
        // видаляємо рядок, який відповідає задачі
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// определяем приоритет задач, соответствующий текущей секции
        let taskType = sectionsTypesPosition[section]
        guard let currentTasksType = tasks[taskType] else { 
            return 0
        }
        return currentTasksType.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ячейка на основі констрейнтів
//        return getConfiguredTaskCell_constraints(for: indexPath)
        // ячейка на основі стеку
        return getConfiguredTaskCell_stack(for: indexPath)
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let tasksType = sectionsTypesPosition[section]
            if tasksType == .important {
                title = "Важливі"
            } else if tasksType == .normal{
                title = "Поточні"
            }
        return title
    }
    
    private func getConfiguredTaskCell_constraints(for indexPath: IndexPath) -> UITableViewCell {
        // загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        // получаем данные о задаче, которую необходимо вывести в ячейке
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        // текстовая метка символа
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        // текстовая метка названия задачи
        let textLabel = cell.viewWithTag(2) as? UILabel
        // изменяем символ в ячейке
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        // изменяем текст в ячейке
        textLabel?.text = currentTask.title
        // изменяем цвет текста и символа
        if currentTask.status == .planned {
            textLabel?.textColor = .black
            symbolLabel?.textColor = .black
        } else {
            textLabel?.textColor = .lightGray
            symbolLabel?.textColor = .lightGray
        }
        return cell
    }
    // возвращаем символ для соответствующего типа задачи
    private func getSymbolForTask(with status: TaskStatus) -> String {
        var resultSymbol: String
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .completed {
            resultSymbol = "\u{25C9}"
        } else {
            resultSymbol = "" }
        return resultSymbol
    }
    private func getConfiguredTaskCell_stack (for indexPath: IndexPath) -> UITableViewCell {
        // загружаємо прототип ячейки
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskCells
        // отримуємо дані про задачу, які необхідно вивести в ячейку
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        // змінюємо текст в ячейці
        cell.title.text = currentTask.title
        // змінюмо символ в ячейці
        cell.symbol.text = getSymbolForTask(with: currentTask.status)
        
        // змінюємо колір тексту
        if currentTask.status == .planned {
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        } else if currentTask.status == .completed {
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // провіряємо на існування дану задачу
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return
        }
        // впенюємося що задача не являється виконаною
        guard tasks[taskType]![indexPath.row].status == .planned else {
            // знімаємо виділення з рядка
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        // відмічаємо задачу як виконану
        tasks[taskType]![indexPath.row].status = .completed
        // перегружаємо секцію таблиці
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // отримуємо дані про задачу яку потрібно перевести в "заплановану"
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return nil
        }
        // провіряємо чи задача має статус "виконана"
//        guard tasks[taskType]![indexPath.row].status == .completed else {
//            return nil
//        }
        // створюємо дію для зміни статуса
//        let actionSwipeInstance = UIContextualAction(style: .normal, title: "Не виконана") { _,_,_ in
//            self.tasks[taskType]![indexPath.row].status = .planned
//            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
//        }
//        return UISwipeActionsConfiguration(actions: [actionSwipeInstance])
        
        // дії для зміни статусу задачі на "запланована"
        let actionSwipeInstanse = UIContextualAction(style: .normal, title: "НЕ виконана") { _,_,_ in
            self.tasks[taskType]![indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        // дії для переходу в екран редагування
        let actionEditInstanse = UIContextualAction(style: .normal, title: "Редагувати") { _, _, _ in
            // загрузка сцени зі Storyboard
            let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TaskEditController") as! TaskEditController
            // передача значень редагуємій задачі
            editScreen.taskText = self.tasks[taskType]![indexPath.row].title
            editScreen.taskType = self.tasks[taskType]![indexPath.row].type
            editScreen.taskStatus = self.tasks[taskType]![indexPath.row].status
            // передача обробнику для зберігання задачі
            editScreen.doAfterEdit = { [unowned self] title, type, status in
                let editTask = Task(title: title, type: type, status: status)
                tasks[taskType]![indexPath.row] = editTask
                tableView.reloadData()
            }
            // перехід до екрану редагування
            self.navigationController?.pushViewController(editScreen, animated: true)
        }
        // змінюємо колір фону кнопки дії
        actionEditInstanse.backgroundColor = .darkGray
        
        // створюємо обʼєкт, який описує доступні дії
        // в залежності від стану задачі буде відображено 1 або 2 дії
        let actionsConfiguration: UISwipeActionsConfiguration
        if tasks[taskType]![indexPath.row].status == .completed {
            actionsConfiguration = UISwipeActionsConfiguration(actions: [actionSwipeInstanse,actionEditInstanse])
        } else {
            actionsConfiguration = UISwipeActionsConfiguration(actions: [actionEditInstanse])
        }
        return actionsConfiguration
    }
  
}
