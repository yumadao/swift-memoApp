//
//  MemoListViewController.swift
//  shoppingMemo
//
//  Created by 大石優真 on 2021/04/13.
//

import UIKit

class MemoListViewController: UIViewController {

   
    @IBOutlet weak var tableView: UITableView!
    var GVar = GlobalVar.shared
    
    var memoList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "memoNum") != nil{
            GVar.memoArray = UserDefaults.standard.integer(forKey: "memoNum")
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
}

extension MemoListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoListCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GVar.memoNumber = indexPath.row
        UserDefaults.standard.set(GVar.memoNumber,forKey: "memoNum")
    }
}
