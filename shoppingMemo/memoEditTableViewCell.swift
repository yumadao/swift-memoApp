//
//  memoEditTableViewCell.swift
//  shoppingMemo
//
//  Created by yuma oishi on 2021/04/27.
//

import UIKit

class memoEditTableViewCell: UITableViewCell {
    
    var GVar = GlobalVar.shared
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var squaremark: UIImageView!
    @IBOutlet weak var checkmark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.borderStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
