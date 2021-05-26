//
//  MemoListViewController.swift
//  shoppingMemo
//
//  Created by 大石優真 on 2021/04/13.
//

import UIKit

class MemoNavigationViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    let navi :[String] = [
      "メモを削除",
      "よく購入する物に登録"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
}

extension MemoNavigationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoNaviCell", for: indexPath)
        cell.textLabel?.text = navi[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
