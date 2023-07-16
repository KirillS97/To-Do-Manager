//
//  Task.swift
//  To-Do Manager
//
//  Created by Kirill on 10.07.2023.
//

import Foundation

enum TaskPriority: String {
    case normal = "Текущие"
    case important = "Важные"
}

enum TaskStatus: Int {
    case planned = 0
    case completed = 1
}

protocol TaskProtocol {
    var name: String { get set }
    var type: TaskPriority { get set }
    var status: TaskStatus { get set }
}

struct Task: TaskProtocol {
    var name: String
    var type: TaskPriority
    var status: TaskStatus
    
    init(name: String, type: TaskPriority, status: TaskStatus) {
        self.name = name
        self.type = type
        self.status = status
    }
    
    init() {
        self.name = ""
        self.type = .normal
        self.status = .planned
    }
    
}
