//
//  EditViewController.swift
//  shoppingMemo
//
//  Created by yuma oishi on 2021/03/19.
//

import UIKit
import Foundation



class EditViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMemoRowButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var toFavoButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toCalcuButton: UIBarButtonItem!
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
        tableView.tableFooterView = UIView()
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGR.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tapGR)
        if UIDevice.current.userInterfaceIdiom != .phone{
            toCalcuButton.isEnabled = false
            toCalcuButton.title = ""
        }
        if UserDefaults.standard.object(forKey: "product") != nil{
            GVar.memoArray = UserDefaults.standard.stringArray(forKey: "product") ?? []
        }
        if UserDefaults.standard.object(forKey: "bool") != nil{
            GVar.boolArray = load(key: "bool")
        }
        if UserDefaults.standard.object(forKey: "favo") != nil{
            GVar.favoArray = UserDefaults.standard.stringArray(forKey: "favo") ?? []
        }
        if UserDefaults.standard.object(forKey: "favoBool") != nil{
            GVar.favoBoolArray = load(key: "favoBool")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func load(key:String) -> [[Bool]]{
        let value = UserDefaults.standard.object(forKey: key)
        guard let array = value as? [[Bool]] else {
            return []
        }
        return array
    }
    
    @objc func dismissKeyboard(){
        if textFieldisHidden == false{
            switch textFieldStatus {
            case .add:
                GVar.memoArray.removeLast()
                GVar.boolArray.removeLast()
            case .edit:
                GVar.boolArray[editIndex][2].toggle()
                GVar.boolArray[editIndex][3].toggle()
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
            GVar.memoArray.append("")
            GVar.boolArray.append([true,false,true,false])
            textFieldFirstResponder = true
            tableView.reloadData()
    }
    
    @IBAction func memoRowEditAction(_ sender: Any) {
        if GVar.memoArray.count >= 1{
            if editButton.title == "編集"{
                tableView.isEditing = true
                editButton.title = "完了"
            }else{
                tableView.isEditing = false
                editButton.title = "編集"
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "すべて削除しますか？", message: "", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除", style: .default, handler: {(action:UIAlertAction) -> Void in
            self.GVar.memoArray.removeAll()
            self.GVar.boolArray.removeAll()
            UserDefaults.standard.set(self.GVar.memoArray, forKey: "product")
            UserDefaults.standard.set(self.GVar.boolArray, forKey: "bool")
            self.tableView.reloadData()
            self.viewDidLoad()
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func toCalcu(_ sender: Any) {
        performSegue(withIdentifier: "toCalcu", sender: nil)
    }
    
    @IBAction func toFavo(_ sender: Any) {
        performSegue(withIdentifier: "toFavoMemo", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            dismissKeyboard()
        }else{
            switch textFieldStatus{
            case .add:
                returnAction(TF: textField, index: GVar.memoArray.count - 1)
            case .edit:
                returnAction(TF: textField, index: editIndex)
                textFieldStatus = .add
            }
            UserDefaults.standard.set(GVar.memoArray, forKey: "product")
            UserDefaults.standard.set(GVar.boolArray, forKey: "bool")
            textFieldisHidden = true
            textFieldFirstResponder = false
            tableView.reloadData()
            textField.text = ""
        }
        return true
    }
    
    func returnAction(TF:UITextField,index:Int){
        GVar.boolArray[index][2].toggle()
        GVar.boolArray[index][3].toggle()
        GVar.memoArray[index] = TF.text ?? ""
    }
    
    func buttonsIsHidden(bool:Bool){
        self.addMemoRowButton.isEnabled = bool
        self.deleteButton.isEnabled = bool
        self.toFavoButton.isEnabled = bool
        self.editButton.isEnabled = bool
        if UIDevice.current.userInterfaceIdiom == .phone{
            self.toCalcuButton.isEnabled = bool
        }
    }
}

extension EditViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GVar.memoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! memoEditTableViewCell
        cell.checkmark.isHidden = GVar.boolArray[indexPath.row][0]
        cell.squaremark.isHidden = GVar.boolArray[indexPath.row][1]
        cell.label.isHidden = GVar.boolArray[indexPath.row][2]
        cell.textField.isHidden = GVar.boolArray[indexPath.row][3]
        if textFieldisHidden == false{
            buttonsIsHidden(bool: false)
        }else if textFieldisHidden == true{
            buttonsIsHidden(bool: true)
        }
        if textFieldFirstResponder{
            cell.textField.becomeFirstResponder()
        }else{
            cell.textField.resignFirstResponder()
        }
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:GVar.memoArray[indexPath.row])
        switch cell.checkmark.isHidden {
        case true:
            attributeString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            cell.label.attributedText = attributeString
        case false:
            attributeString.addAttributes([
                .strikethroughStyle:1,
                .foregroundColor:UIColor.gray
            ], range: NSMakeRange(0, attributeString.length))
            cell.label.attributedText = attributeString
        }
        cell.label.attributedText = attributeString
        cell.textField.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.GVar.memoArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        self.GVar.boolArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        UserDefaults.standard.set(self.GVar.memoArray, forKey: "product")
        UserDefaults.standard.set(self.GVar.boolArray, forKey: "bool")
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GVar.boolArray[indexPath.row][0].toggle()
        GVar.boolArray[indexPath.row][1].toggle()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "編集"){
            (action,view,success) in
            self.editIndex = indexPath.row
            self.GVar.boolArray[indexPath.row][0] = true
            self.GVar.boolArray[indexPath.row][1] = false
            self.GVar.boolArray[indexPath.row][2].toggle()
            self.GVar.boolArray[indexPath.row][3].toggle()
            self.textFieldStatus = .edit
            self.textFieldisHidden = false
            self.textFieldFirstResponder = true
            tableView.reloadData()
        
            success(true)
        }
        let deleteAction = UIContextualAction(style: .normal, title: "削除"){
            (action,view,success) in
            self.GVar.memoArray.remove(at: indexPath.row)
            self.GVar.boolArray.remove(at: indexPath.row)
            UserDefaults.standard.set(self.GVar.memoArray, forKey: "product")
            UserDefaults.standard.set(self.GVar.boolArray, forKey: "bool")
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.viewDidLoad()
            self.addMemoRowButton.isEnabled = true
            
            success(true)
        }
        let favoAction = UIContextualAction(style: .normal, title: "☆"){
            (action,view,success) in
            self.GVar.favoArray.append(self.GVar.memoArray[indexPath.row])
            self.GVar.favoBoolArray.append([true,false,false,true])
            UserDefaults.standard.set(self.GVar.favoArray, forKey: "favo")
            UserDefaults.standard.set(self.GVar.favoBoolArray, forKey: "favoBool")
            let alert = UIAlertController(title: "", message: "よく購入する物に追加しました", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            success(true)
        }
        editAction.backgroundColor = .orange
        deleteAction.backgroundColor = .red
        favoAction.backgroundColor = .gray
        if textFieldisHidden == true{
            return UISwipeActionsConfiguration(actions: [favoAction,editAction,deleteAction])
        }else{ return UISwipeActionsConfiguration(actions: [])}
    }
}
