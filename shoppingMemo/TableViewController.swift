//
//  TableViewController.swift
//  shoppingMemo
//
//  Created by 大石優真 on 2021/05/14.
//

import UIKit

class TableViewController: UITableViewController{

   weak var testDelegate: TestDelegate?
    var GVar = GlobalVar.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GVar.memoRow
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! memoEditTableViewCell
        cell.checkmark.isHidden = GVar.boolArray[GVar.memoNumber][1]
        cell.circlemark.isHidden = GVar.boolArray[GVar.memoNumber][0]
        cell.label.isHidden = GVar.boolArray[GVar.memoNumber][2]
        cell.textField.isHidden = GVar.boolArray[GVar.memoNumber][3]
        
        return cell
    }

}
