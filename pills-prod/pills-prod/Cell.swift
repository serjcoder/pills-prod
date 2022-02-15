//
//  TableViewCell.swift
//  drugs list
//
//  Created by Sergey Ivchenko on 05.02.2022.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var tradeLabel: UILabel!
    @IBOutlet weak var manufacturerName: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tradeLabel.sizeToFit()
        manufacturerName.sizeToFit()
    }
}
