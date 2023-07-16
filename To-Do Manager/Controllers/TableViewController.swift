//
//  TableViewController.swift
//  To-Do Manager
//
//  Created by Kirill on 10.07.2023.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    
    // MARK: - Stored properties
    /*========================================================*/
    private var storage         : TasksStorageProtocol = TaskStorage()
    private var tasksDictionary : [TaskPriority: [TaskProtocol]] = [:] {
        didSet {
            for (taskPriority, tasksArray) in self.tasksDictionary {
                self.tasksDictionary[taskPriority] = tasksArray.sorted(by: { task1, task2 in
                    task1.status.rawValue < task2.status.rawValue
                })
            }
            var savingArray: [TaskProtocol] = []
            for taskArray in self.tasksDictionary.values {
                for task in taskArray {
                    savingArray.append(task)
                }
            }
            self.storage.saveTasks(tasksArray: savingArray)
        }
    }    // Словарь с задачами
    private var sectionsTypesPosition   : [TaskPriority] = [.important, .normal]  // Порядок отображения секций
    private var sectionsTitlesArray     : [String] = []                           // Заголовки секций
    
    private var editListButton          : UIBarButtonItem!  // Кнопка на панели навигации для активации режима редактирования
    /*========================================================*/
    
    
    
    // MARK: - "viewDidLoad" method
    /*========================================================*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Загрузка задач из хранилища
        self.loadTask()
        
        // Настройка панели навигации
        self.editListButton = UIBarButtonItem()
        if self.isEditing {
            self.editListButton.title = "Готово"
            self.editListButton.style = .done
        } else {
            self.editListButton.title = "Редакт."
            self.editListButton.style = .plain
        }
        self.editListButton.target = self
        self.editListButton.action = #selector(self.editListButtonHandler(sender:))
        self.navigationItem.setLeftBarButton(self.editListButton, animated: false)
    }
    /*========================================================*/
    
    
    
    // MARK: - "prepare" method. Срабатывает при переходе по нажатию на кнопку "Добавить"  навигационного бара
    /*========================================================*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taskEditController = segue.destination as? TaskEditController else { return }
        taskEditController.closureForTaskTransfer = { (task: TaskProtocol) -> Void in
            if let tranferredTask = taskEditController.task {
                self.tasksDictionary[tranferredTask.type]?.append(tranferredTask)
            }
            self.updateSectionsTitles()
            self.tableView.reloadData()
        }
    }
    /*========================================================*/
    
    
    
    // MARK: - func "loadTask"
    /*========================================================*/
    private func loadTask() -> Void {
        
        /*
         Обязательно сначала создаётся экземпляр массива задач из хранилища (tasksArray)
         и только потом словарю "tasksDictionary" присваиваются пустые массивы по соответствующим ключам.
         Если сначала изменить словарь, а только потом создать эксземпляр "tasksArray", то он будет пустым из-за того, что при присваивании словарю пустых массивов вызовется его наблюдатель "didSet" и изменит хранилище.
         */
        let tasksArray = self.storage.loadTask()
        
        self.sectionsTypesPosition.forEach({ (taskPriority: TaskPriority) -> Void in
            self.tasksDictionary[taskPriority] = []
        })
        
        for task in tasksArray {
            self.tasksDictionary[task.type]?.append(task)
        }
        
    }
    /*========================================================*/
    
    
    
    // MARK: - func "updateSectionsTitles". Метод для обновления заголовков разделов таблицы
    /*========================================================*/
    private func updateSectionsTitles() -> Void {
        if !self.sectionsTitlesArray.isEmpty {
            self.sectionsTitlesArray.removeAll()
        }

        for taskPriority in self.sectionsTypesPosition {
            if let tasksArray = self.tasksDictionary[taskPriority] {
                if !tasksArray.isEmpty {
                    self.sectionsTitlesArray.append(taskPriority.rawValue)
                }
            }
        }
    }
    /*========================================================*/
    
    
    
    // MARK: - Table view Data Source. Методы класса UITableViewDataSource
    /*========================================================*/
    
    
    
    // MARK: - Обработчик нажатия на кнопку "Редактировать" панели навигации
    /*========================================================*/
    @objc private func editListButtonHandler(sender: UIBarButtonItem) -> Void {
        guard sender.isEqual(self.editListButton) else { return }
        
        if self.isEditing {
            self.setEditing(false, animated: true)
        } else {
            self.setEditing(true, animated: true)
        }
        
        if self.isEditing {
            self.editListButton.title = "Готово"
            self.editListButton.style = .done
        } else {
            self.editListButton.title = "Редакт."
            self.editListButton.style = .plain
        }
        
    }
    
    /*========================================================*/
    
    
    // MARK: Метод, возвращающий число разделов
    /* - - - - - - - - - - - - - - - - - - - - - - */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsTypesPosition.count
    }
    /* - - - - - - - - - - - - - - - - - - - - - - */
    
    
    
    // MARK: Метод, возвращающий число строк внутри разделов
    /* - - - - - - - - - - - - - - - - - - - - - - */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskType = self.sectionsTypesPosition[section]
        if let tasksArray = self.tasksDictionary[taskType] {
            return tasksArray.count
        }
        return 1
    }
    /* - - - - - - - - - - - - - - - - - - - - - - */
    
    
    
    // MARK: Метод, возвращающий ячейки для строк таблицы
    /* - - - - - - - - - - - - - - - - - - - - - - */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.sectionsTypesPosition.count > indexPath.section else { return UITableViewCell() }
        let taskPriority = self.sectionsTypesPosition[indexPath.section]
        guard let tasksArray = self.tasksDictionary[taskPriority] else { return UITableViewCell() }
        guard tasksArray.count > indexPath.row else { return UITableViewCell() }
        let task = tasksArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        guard let symbolLabel = cell.viewWithTag(1) as? UILabel else { return UITableViewCell() }
        guard let titleLabel = cell.viewWithTag(2) as? UILabel else { return UITableViewCell() }
        
        symbolLabel.text = self.getSymbolForTask(task: task)
        symbolLabel.textColor = self.getColorForTask(task: task)
        titleLabel.text = task.name
        titleLabel.textColor = self.getColorForTask(task: task)
        
        return cell
    }
    /* - - - - - - - - - - - - - - - - - - - - - - */
    
    
    
    // MARK: Метод установки заголовков разделов
    /* - - - - - - - - - - - - - - - - - - - - - - */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.updateSectionsTitles()
        guard self.sectionsTitlesArray.count > section else { return nil }
        return self.sectionsTitlesArray[section]
    }
    /* - - - - - - - - - - - - - - - - - - - - - - */
    
    
    
    // MARK: Метод выбора режима редактирвоания строк таблицы
    /* - - - - - - - - - - - - - - - - - - - - - - */
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    /* - - - - - - - - - - - - - - - - - - - - - - */
    
    
    
    // MARK: Метод обработки взаимодействия со строками в режиме редактирования
    /* - - - - - - - - - - - - - - - - - - - - - - */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard self.sectionsTypesPosition.count > indexPath.section else { return }
        guard let tasksArray = self.tasksDictionary[self.sectionsTypesPosition[indexPath.section]] else { return }
        guard tasksArray.count > indexPath.row else { return }
        
        if editingStyle == .delete {
            self.tasksDictionary[self.sectionsTypesPosition[indexPath.section]]!.remove(at: indexPath.row)
            self.updateSectionsTitles()
            self.tableView.reloadData()
        }
    }
    /* - - - - - - - - - - - - - - - - - - - - - - */
    
    
    
    // MARK: Метод для установки метки статуса задачи
    /* - - - - - - - - - - - - - - - - - - - - - - */
    private func getSymbolForTask(task: TaskProtocol) -> String {
        if task.status == .planned {
            return "\u{25CB}"
        } else {
            return "\u{25C9}"
        }
    }
    /* - - - - - - - - - - - - - - - - - - - - - - */
    
    
    
    // MARK: Метод для установки цвета статуса задачи
    /* - - - - - - - - - - - - - - - - - - - - - - */
    private func getColorForTask(task: TaskProtocol) -> UIColor {
        if task.status == .planned {
            return UIColor.black
        } else {
            return UIColor.systemGray3
        }
    }
    /* - - - - - - - - - - - - - - - - - - - - - - */
    
    /*========================================================*/
    
    
    
    // MARK: - Table view Delegate. Методы класса UITableViewDelegate
    /*========================================================*/
    
    // MARK: "didSelectRowAt". Метод, срабатывающий при выборе строки
    /* - - - - - - - - - - - - - - - - - - - - - - */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard self.sectionsTypesPosition.count > indexPath.section else { return }
        guard let tasksArray = self.tasksDictionary[self.sectionsTypesPosition[indexPath.section]] else { return }
        guard tasksArray.count > indexPath.row else { return }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
        if let taskEditController = mainStoryboard.instantiateViewController(identifier: "TaskEditController") as? TaskEditController {
            taskEditController.task = self.tasksDictionary[self.sectionsTypesPosition[indexPath.section]]![indexPath.row]
            taskEditController.closureForTaskTransfer = { (task: TaskProtocol) -> Void in
                self.tasksDictionary[self.sectionsTypesPosition[indexPath.section]]?.remove(at: indexPath.row)
                if let tranferredTask = taskEditController.task {
                    self.tasksDictionary[tranferredTask.type]?.append(tranferredTask)
                }
                self.updateSectionsTitles()
                self.tableView.reloadData()
            }
            if let navigationController {
                navigationController.pushViewController(taskEditController, animated: true)
            }
        }
    }
    /* - - - - - - - - - - - - - - - - - - - - - - */
    
    
    /*========================================================*/
    
    
    

}
