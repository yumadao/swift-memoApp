//
//  favoMemoTableViewCell.swift
//  shoppingMemo
//
//  Created by yuma oishi on 2021/05/18.
//

import UIKit

class favoMemoTableViewCell: UITableViewCell {

    var GVar = GlobalVar.shared
    
    
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var squaremark: UIImageView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var textfield: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textfield.borderStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
}
