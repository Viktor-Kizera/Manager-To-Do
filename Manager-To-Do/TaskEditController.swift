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
    
    // переключатель задачі
    @IBOutlet weak var taskStatusSwitch: UISwitch!
    
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
        // оновлюємо статус задачі
        if taskStatus == .completed {
            taskStatusSwitch.isOn = true
        }
    }
    @IBAction func saveTask(_ sender: UIBarItem) {
        // отримуємо актуальні значення
        let title = taskTitle?.text ?? ""
        let type = taskType
        let status: TaskStatus = taskStatusSwitch.isOn ? .completed: .planned
        // викликаємо обрабника
        doAfterEdit?(title, type, status)
        // повертаємося до попереднього екрану
        navigationController?.popViewController(animated: true)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen" {
            // посилання на контроллер призначення
            let destination = segue.destination as! TaskTypeController
            // передача вибраного типу
            destination.selectedType = taskType
            // передача обробника вибраного типу
            destination.doAfterTypeSelected = { [unowned self] selectedType in
                self.taskType = selectedType
                // оновлюємо мітку с текущем типом
                taskTypeLabel?.text = taskTitles[taskType]
            }
        }
    }
}
