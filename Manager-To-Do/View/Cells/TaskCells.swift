//
//  TaskCells.swift
//  Manager-To-Do
//
//  Created by Viktor Kizera on 30.04.2024.
//

import UIKit

class TaskCells: UITableViewCell {
    @IBOutlet var symbol: UILabel!
    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
