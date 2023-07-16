//
//  TaskPriorityCell.swift
//  To-Do Manager
//
//  Created by Kirill on 13.07.2023.
//

import UIKit

class TaskPriorityCell: UITableViewCell {
    
    @IBOutlet var taskPriorityNameLabel: UILabel!
    @IBOutlet var taskPriorityDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
