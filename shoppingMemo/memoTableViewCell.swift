//
//  memoTableViewCell.swift
//  shoppingMemo
//
//  Created by 大石優真 on 2021/03/19.
//

import UIKit

class memoTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var moneyText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
