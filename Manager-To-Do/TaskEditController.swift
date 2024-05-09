//
//  TaskEditController.swift
//  Manager-To-Do
//
//  Created by Viktor Kizera on 08.05.2024.
//

import UIKit

class TaskEditController: UITableViewController {
    
    
    @IBOutlet weak var taskTypeLabel: UILabel!

    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?

    @IBOutlet weak var taskTitle: UITextField!
    private var taskTitles: [TaskPriority: String] = [
        .important: "Важливі",
        .normal: "Поточні"
    ]
    // параметри задачі
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    override func viewDidLoad() {
        super.viewDidLoad()
        // оновлення текстового поля з назвою задачі
        taskTitle?.text = taskText
        // оновлення текстової мітки в соотвествеї з типом
        taskTypeLabel?.text = taskTitles[taskType]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
}
