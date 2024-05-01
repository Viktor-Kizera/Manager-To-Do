//
//  TaskStorage.swift
//  Manager-To-Do
//
//  Created by Viktor Kizera on 30.04.2024.
//

import Foundation
import UIKit

protocol TasksStorageProtocol {
    func loadTasks() -> [TaskProtocol]
    func saveTasks(_ tasks: [TaskProtocol])
}
class TasksStorage: TasksStorageProtocol {
    func loadTasks() -> [TaskProtocol] {
    let testTasks: [TaskProtocol] = [
    Task(title: "Купить хлеб", type: .normal, status: .planned), 
    Task(title: "Помыть кота", type: .important, status: .planned),
    Task(title: "Отдать долг Арнольду", type: .important, status:
    .completed),
    Task(title: "Купить новый пылесос", type: .normal, status:
    .completed),
    Task(title: "Подарить цветы супруге", type: .important, status:
    .planned), Task(title: "Позвонить родителям", type: .important, status: .planned),
    Task(title: "Садок вишневий коло хати, хрущі над вишнями гудуть, плягатарі з плугами йдуть, співають ідучи дівчата, а матері вечерять ждуть", type: .important, status: .planned)]
        return testTasks
    }
     func saveTasks(_ tasks: [TaskProtocol]) {}
}
