//
//  TaskStorage.swift
//  To-Do Manager
//
//  Created by Kirill on 10.07.2023.
//

import Foundation

protocol TasksStorageProtocol {
    func loadTask() -> [TaskProtocol]
    func saveTasks(tasksArray: [TaskProtocol]) -> Void
}

class TestTasksStorage: TasksStorageProtocol {
    
    func loadTask() -> [TaskProtocol] {
        // Временная реализация
        let testTasksArray: [TaskProtocol] = [
            Task(name: "Купить хлеб", type: .normal, status: .planned),
            Task(name: "Помыть кота", type: .important, status: .planned),
            Task(name: "Отдаль долг Арнольду", type: .important, status: .completed),
            Task(name: "Купить новый пылесос", type: .normal, status: .completed),
            Task(name: "Подарить цветы супруге", type: .important, status: .planned),
            Task(name: "Позвонить родителям", type: .important, status: .planned)
        ]
        return testTasksArray
    }
    
    func saveTasks(tasksArray: [TaskProtocol]) {}
    
}

class TaskStorage: TasksStorageProtocol {
    
    let storage = UserDefaults.standard
    let tasksKey = "tasksKey"
    
    enum TaskPropertyKeys: String {
        case name
        case type
        case status
    }
    
    func loadTask() -> [TaskProtocol] {
        var returnedTasksArray: [TaskProtocol] = []
        
        if let arrayFromTasksDictionaries = storage.object(forKey: tasksKey) as? [[String: String]] {
            for taskDictionary in arrayFromTasksDictionaries {
                
                var name: String
                var type: TaskPriority
                var status: TaskStatus
                
                let typeRawValue = taskDictionary[TaskPropertyKeys.type.rawValue] ?? "Текущие"
                let statusStringRawValue = taskDictionary[TaskPropertyKeys.status.rawValue] ?? "0"
                let statusRawValue = Int(statusStringRawValue) ?? 0
                
                name = taskDictionary[TaskPropertyKeys.name.rawValue] ?? "Название"
                type = TaskPriority.init(rawValue: typeRawValue) ?? TaskPriority.normal
                status = TaskStatus.init(rawValue: statusRawValue) ?? TaskStatus.planned
                
                returnedTasksArray.append(Task(name: name, type: type, status: status))
            }
        }
        return returnedTasksArray
    }

    func saveTasks(tasksArray: [TaskProtocol]) {
        var arrayFromTasks: [[String: String]] = []
        
        for task in tasksArray {
            var dictionaryFromTask: [String: String] = [:]
            
            dictionaryFromTask[TaskPropertyKeys.name.rawValue] = task.name
            dictionaryFromTask[TaskPropertyKeys.type.rawValue] = task.type.rawValue
            dictionaryFromTask[TaskPropertyKeys.status.rawValue] = String(task.status.rawValue)
            
            arrayFromTasks.append(dictionaryFromTask)
        }
        
        storage.set(arrayFromTasks, forKey: tasksKey)
    }


}
