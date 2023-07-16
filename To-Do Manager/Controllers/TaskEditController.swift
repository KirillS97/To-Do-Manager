//
//  TaskEditController.swift
//  To-Do Manager
//
//  Created by Kirill on 13.07.2023.
//

import UIKit



/*__________________________________________________________________________*/
/*--------------------------------------------------------------------------*/
class TaskEditController: UITableViewController {
    
    
    
    // MARK: - Properties
    /*=========================================================================*/
    var task: TaskProtocol?
    var closureForTaskTransfer: ((TaskProtocol) -> Void)?
    var taskPriorityTitles: [TaskPriority: String] = [.important: "Важная", .normal: "Текущая"]
    
    var barButtonDone                       : UIBarButtonItem!
    var keyboardButtonDone                  : UIBarButtonItem!
    @IBOutlet var taskTitleTF               : UITextField!
    @IBOutlet var taskPriorityLabel         : UILabel!
    @IBOutlet var taskCompletionStatusSwitch: UISwitch!
    /*=========================================================================*/
    
    
    
    // MARK: - viewDidLoad
    /*=========================================================================*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // MARK: Настройка таблицы
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        self.tableView.keyboardDismissMode = .interactive
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        
        
                
        // MARK: Наполнение элементов ячеек
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        if let task = self.task {
            
            //Настройка первой (верхней) ячейки
            /* - - - - - - - - - - - - */
            self.taskTitleTF.text = task.name
            /* - - - - - - - - - - - - */
            
            //Настройка второй ячейки
            /* - - - - - - - - - - - - */
            self.taskPriorityLabel.text = self.taskPriorityTitles[task.type]
            /* - - - - - - - - - - - - */
            
            //Настройка третьей (нижней) ячейки
            /* - - - - - - - - - - - - */
            if task.status == .completed {
                self.taskCompletionStatusSwitch.isOn = true
            } else {
                self.taskCompletionStatusSwitch.isOn = false
            }
            /* - - - - - - - - - - - - */
            
        } else {
            //Настройка третьей (нижней) ячейки
            /* - - - - - - - - - - - - */
            self.taskCompletionStatusSwitch.isOn = false
            /* - - - - - - - - - - - - */
        }
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        
        
        
        // MARK: Настройка текстового поля с названием задачи
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        self.taskTitleTF.addTarget(self,
                                   action: #selector(self.taskTitleTFHandler(sender:)),
                                   for: .allEditingEvents)
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        
        
        
        // MARK: Настройка панели навигации
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        self.barButtonDone = UIBarButtonItem()
        self.barButtonDone.title = "Готово"
        self.barButtonDone.target = self
        self.barButtonDone.action = #selector(self.buttonDoneHandler(sender:))
        self.navigationItem.setRightBarButton(self.barButtonDone, animated: false)
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        
        
        
        // MARK: Настройка переключателя
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        self.taskCompletionStatusSwitch.addTarget(self, action: #selector(self.switchHandler(sender:)), for: .valueChanged)
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        
        
        
        // MARK: Настройка панели инструментов для input view (клавиатуры)
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let emptyButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.keyboardButtonDone = UIBarButtonItem(title: "Готово",
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(self.keyboardButtonDoneHandler(sender:)))
        toolbar.setItems([emptyButton, self.keyboardButtonDone], animated: false)
        self.taskTitleTF.inputAccessoryView = toolbar
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - */
        
    }
    /*=========================================================================*/
    
    
    
    // MARK: - prepare method. Метод подготовки к переходу на другую сцену с помощью segue
    /*=========================================================================*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let taskPriorityVC = segue.destination as? TaskPriorityController else { return }
        
        if self.task != nil {
            taskPriorityVC.selectedPriority = self.task!.type
        } else {
            taskPriorityVC.selectedPriority = .normal
        }
        
        taskPriorityVC.closureForTaskPriorityTransfer = { (taskPriority: TaskPriority) -> Void in
            if let taskPriorityTitle = self.taskPriorityTitles[taskPriority] {
                if self.task == nil { self.task = Task() }
                self.task?.type = taskPriority
                self.taskPriorityLabel.text = taskPriorityTitle
            }
        }
    }
    /*=========================================================================*/
    
    
    
    // MARK: - UITableViewDataSource
    /*=========================================================================*/
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /*=========================================================================*/

    
    
    // MARK: - Обработчик нажатия на кнопку "Готово" панели навигации
    /*=========================================================================*/
    @objc private func buttonDoneHandler(sender: UIBarButtonItem) -> Void {
        
        guard sender.isEqual(self.barButtonDone) else { return }
        
        let alertController = UIAlertController(title: "Заполните название задачи", message: nil, preferredStyle: .alert)
        let okAlertButton = UIAlertAction(title: "Ок", style: .cancel)
        alertController.addAction(okAlertButton)
        
        if self.task == nil {
            self.present(alertController, animated: true)
        } else {
            var taskNameWhithoutSpaces = ""
            for character in self.task!.name {
                if character != Character("\u{0020}") {
                    taskNameWhithoutSpaces.append(character)
                }
            }
            if taskNameWhithoutSpaces == "" {
                self.present(alertController, animated: true)
            } else {
                self.closureForTaskTransfer!(self.task!)
                if let navigationController {
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }
    /*=========================================================================*/
    
    
    
    // MARK: - Обработчик нажатия на кнопку "Готово"
    /*=========================================================================*/
    @objc private func keyboardButtonDoneHandler(sender: UIBarButtonItem) -> Void {
        guard sender.isEqual(self.keyboardButtonDone) else { return }
        self.view.endEditing(true)
    }
    /*=========================================================================*/
    
    
    
    // MARK: - Обработчик изменения значения в текстово поле "taskTitleTF"
    /*=========================================================================*/
    @objc private func taskTitleTFHandler(sender: UITextField) -> Void {
        guard sender.isEqual(self.taskTitleTF) else { return }
        if self.task == nil { self.task = Task() }
        if let textForTaskName = self.taskTitleTF.text {
            self.task?.name = textForTaskName
        }
    }
    /*=========================================================================*/
    
    
    // MARK: - Обработчик нажатия на переключатель статуса задачи
    /*=========================================================================*/
    @objc private func switchHandler(sender: UISwitch) -> Void {
        guard sender.isEqual(self.taskCompletionStatusSwitch) else { return }
        if self.task == nil { self.task = Task() }
        if sender.isOn == true {
            self.task!.status = .completed
        } else {
            self.task!.status = .planned
        }
    }
    /*=========================================================================*/
    

}
/*__________________________________________________________________________*/
/*--------------------------------------------------------------------------*/


