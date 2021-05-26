//
//  favoMemoViewController.swift
//  shoppingMemo
//
//  Created by yuma oishi on 2021/05/18.
//

import UIKit

class favoMemoViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMemoRowButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    var GVar = GlobalVar.shared
    var editIndex:Int = 0
    enum TextFieldStatus {
        case add ,edit
    }
    var textFieldStatus:TextFieldStatus = .add
    var textFieldisHidden:Bool = true
    var textFieldFirstResponder:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = false
        tableView.allowsSelectionDuringEditing = true
        navigationController?.delegate = self
        tableView.tableFooterView = UIView()
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGR.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func dismissKeyboard(){
        if textFieldisHidden == false{
            switch textFieldStatus {
            case .add:
                GVar.favoArray.removeLast()
                GVar.favoBoolArray.removeLast()
            case .edit:
                GVar.favoBoolArray[editIndex][2].toggle()
                GVar.favoBoolArray[editIndex][3].toggle()
                textFieldStatus = .add
            }
            textFieldisHidden = true
            textFieldFirstResponder = false
            buttonsIsHidden(bool: true)
            tableView.reloadData()
        }
    }
    
    @IBAction func addMemoRow(_ sender: Any) {
        textFieldisHidden = false
        GVar.favoArray.append("")
        GVar.favoBoolArray.append([true,false,true,false])
        textFieldFirstResponder = true
        tableView.reloadData()
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "すべて削除しますか？", message: "", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.GVar.favoArray.removeAll()
            self.GVar.favoBoolArray.removeAll()
            UserDefaults.standard.set(self.GVar.favoArray, forKey: "favo")
            UserDefaults.standard.set(self.GVar.favoBoolArray, forKey: "favoBool")
            self.tableView.reloadData()
            self.viewDidLoad()
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func memoRowEditAction(_ sender: Any) {
        if GVar.favoArray.count >= 1{
            if editButton.title == "編集"{
                tableView.isEditing = true
                editButton.title = "完了"
            }else{
                tableView.isEditing = false
                editButton.title = "編集"
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            dismissKeyboard()
        }else{
        switch textFieldStatus{
        case .add:
            returnAction(TF: textField, index: GVar.favoArray.count - 1)
        case .edit:
            returnAction(TF: textField, index: editIndex)
            textFieldStatus = .add
        }
           UserDefaults.standard.set(GVar.favoArray, forKey: "favo")
           UserDefaults.standard.set(GVar.favoBoolArray, forKey: "favoBool")
           textFieldisHidden = true
           textFieldFirstResponder = false
           tableView.reloadData()
           textField.text = ""
        }
          return true
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            if viewController is EditViewController {
                dismissKeyboard()
            }
        }
    
    func returnAction(TF:UITextField,index:Int){
        GVar.favoBoolArray[index][2].toggle()
        GVar.favoBoolArray[index][3].toggle()
        GVar.favoArray[index] = TF.text ?? ""
    }
    
    func buttonsIsHidden(bool:Bool){
        self.addMemoRowButton.isEnabled = bool
        self.deleteButton.isEnabled = bool
        self.editButton.isEnabled = bool
    }
}
extension favoMemoViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GVar.favoArray.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoCell", for: indexPath) as! favoMemoTableViewCell
        cell.checkmark.isHidden = GVar.favoBoolArray[indexPath.row][0]
        cell.squaremark.isHidden = GVar.favoBoolArray[indexPath.row][1]
        cell.Label.isHidden = GVar.favoBoolArray[indexPath.row][2]
        cell.textfield.isHidden = GVar.favoBoolArray[indexPath.row][3]
        if textFieldisHidden == false{
            buttonsIsHidden(bool: false)
        }else if textFieldisHidden == true{
            buttonsIsHidden(bool: true)
        }
        if textFieldFirstResponder == true{
            cell.textfield.becomeFirstResponder()
        }else{
            cell.textfield.resignFirstResponder()
        }
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:GVar.favoArray[indexPath.row])
        switch cell.checkmark.isHidden {
        case true:
            attributeString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            cell.Label.attributedText = attributeString
        case false:
            attributeString.addAttributes([
                .strikethroughStyle:1,
                .foregroundColor:UIColor.gray
            ], range: NSMakeRange(0, attributeString.length))
            cell.Label.attributedText = attributeString
        }
        cell.Label.attributedText = attributeString
        cell.textfield.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.GVar.favoArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        self.GVar.favoBoolArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        UserDefaults.standard.set(self.GVar.favoArray, forKey: "favo")
        UserDefaults.standard.set(self.GVar.favoBoolArray, forKey: "favoBool")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GVar.favoBoolArray[indexPath.row][0].toggle()
        GVar.favoBoolArray[indexPath.row][1].toggle()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "編集"){
            (action,view,success) in
            self.editIndex = indexPath.row
            self.GVar.favoBoolArray[indexPath.row][0] = true
            self.GVar.favoBoolArray[indexPath.row][1] = false
            self.GVar.favoBoolArray[indexPath.row][2].toggle()
            self.GVar.favoBoolArray[indexPath.row][3].toggle()
            self.textFieldStatus = .edit
            self.textFieldisHidden = false
            self.textFieldFirstResponder = true
            tableView.reloadData()
            
            success(true)
        }
        let deleteAction = UIContextualAction(style: .normal, title: "削除"){
            (action,view,success) in
            self.GVar.favoArray.remove(at: indexPath.row)
            UserDefaults.standard.set(self.GVar.favoArray, forKey: "favo")
            self.GVar.favoBoolArray.remove(at: indexPath.row)
            UserDefaults.standard.set(self.GVar.favoBoolArray, forKey: "favoBool")
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.addMemoRowButton.isEnabled = true
            self.viewDidLoad()
            
            success(true)
        }
        let memoAction = UIContextualAction(style: .normal, title: "メモ"){
            (action,view,success) in
            self.GVar.memoArray.append(self.GVar.favoArray[indexPath.row])
            self.GVar.boolArray.append([true,false,false,true])
            UserDefaults.standard.set(self.GVar.memoArray, forKey: "product")
            UserDefaults.standard.set(self.GVar.boolArray, forKey: "bool")
            let alert = UIAlertController(title: "", message: "メモに追加しました", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            success(true)
        }
        editAction.backgroundColor = .orange
        deleteAction.backgroundColor = .red
        memoAction.backgroundColor = .gray
        if self.textFieldisHidden == true{
            return UISwipeActionsConfiguration(actions: [memoAction,editAction,deleteAction])
        }else{ return UISwipeActionsConfiguration(actions: []) }
    }
}

