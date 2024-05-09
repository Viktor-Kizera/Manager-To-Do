//
//  TaskTypeController.swift
//  Manager-To-Do
//
//  Created by Viktor Kizera on 08.05.2024.
//

import UIKit

class TaskTypeController: UITableViewController {
    // 1. кортеж, що описує тип задачі
    typealias TypeCellDescription = (type: TaskPriority, title: String, description: String)
    // 2. колекція доступних типів задач з їх описом
    private var taskTypesInformation: [TypeCellDescription] = [(type: .important, title: "Важливе", description: "Такий тип задачі,є найбільш пріорітетним для виконання. Всі важливі дії виводяться в перших рядках таблиці"),
      (type: .normal, title: "Поточні", description: "Задача зі звичайним пріорітетом")]
    // 3. вибраний пріорітет
    var selectedType: TaskPriority = .normal
    // обробник вибору типа
    var doAfterTypeSelected: ((TaskPriority) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
    // 1. получаємо значення типу UINib, відповідно до xib-файлу кастомної ячейки
    let cellTypeNib = UINib(nibName: "TaskTypeCell", bundle: nil)
    // 2. реєстрація кастомної ячейки в табличному представленні
        tableView.register(cellTypeNib, forCellReuseIdentifier: "TaskTypeCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskTypesInformation.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. Получаємо перевикористовування кастомної ячейки за її ідентифікатором
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTypeCell", for: indexPath) as! TaskTypeCell

        // 2. Получаємо тимчасовий елемент, інформація про якого повинна бути виведена в рядку
        let typeDescription = taskTypesInformation[indexPath.row]
        
        // 3. Заповнюємо ячейку даними
        cell.typeTitle.text = typeDescription.title
        cell.typeDescription.text = typeDescription.description
        // 4. Якщо тип вибраний, то відмічаємо галочкою
        if selectedType == typeDescription.type {
            cell.accessoryType = .checkmark
        // в іншому випадку знімаємо галочку
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // отримуємо вибраний тип
        let selectedType = taskTypesInformation[indexPath.row].type
        // визиваємо обрабника
        doAfterTypeSelected?(selectedType)
        // повертаємо екран
        navigationController?.popViewController(animated: true)
    }
}
