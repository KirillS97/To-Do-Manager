//
//  TaskPriorityController.swift
//  To-Do Manager
//
//  Created by Kirill on 13.07.2023.
//

import UIKit

class TaskPriorityController: UITableViewController {
    
    var tasksPriorityArray : [TaskPriority] = [.important, .normal]
    var taskPriorityNamesDictionary: [TaskPriority: String] = [.important: "Важная", .normal: "Текущая"]
    var taskPriorityDescriptionsDictionary: [TaskPriority: String] = [.important: "Такой тип задач является наиболее приоритетным для выполнения. Все важные задачи отображаются в самом верху списка задач", .normal: "Задача с обычным приоритетом"]
    var selectedPriority: TaskPriority!
    
    var closureForTaskPriorityTransfer: ((TaskPriority) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let taskPriorityCellNib = UINib(nibName: "TaskPriorityCell", bundle: nil)
        self.tableView.register(taskPriorityCellNib, forCellReuseIdentifier: "TaskPriorityCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closureForTaskPriorityTransfer!(self.selectedPriority)
    }
    
    
    private func setUpAccessoryTypeForCell(cell: UITableViewCell, indexPath: IndexPath) -> Void {
        if let cell = cell as? TaskPriorityCell {
            if self.tasksPriorityArray[indexPath.row] == self.selectedPriority {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskPriorityNamesDictionary.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "TaskPriorityCell",
                                                         for: indexPath) as? TaskPriorityCell {
            cell.taskPriorityNameLabel.text = self.taskPriorityNamesDictionary[self.tasksPriorityArray[indexPath.row]]
            cell.taskPriorityDescriptionLabel.text = self.taskPriorityDescriptionsDictionary[self.tasksPriorityArray[indexPath.row]]
            self.setUpAccessoryTypeForCell(cell: cell, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPriority = self.tasksPriorityArray[indexPath.row]
        self.tableView.reloadData()
    }
    
    
    
}
