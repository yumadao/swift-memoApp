//
//  AddMemoViewController.swift
//  shoppingMemo
//
//  Created by 大石優真 on 2021/04/12.
//

import UIKit

class AddMemoViewController: UIViewController {

    
    @IBOutlet weak var productNameText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var quantityText: UITextField!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var toCalcuButton: UIButton!
    
    var GVar = GlobalVar.shared
    var index:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toCalcuButton.isHidden = true
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        toCalcuButton.layer.cornerRadius = 10
        toCalcuButton.layer.borderWidth = 4
        toCalcuButton.layer.borderColor = UIColor.black.cgColor
        toCalcuButton.backgroundColor = .orange
        toCalcuButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        if GVar.productNameArray[GVar.memoNumber] != []{
        productNameText.text = GVar.productNameArray[GVar.memoNumber][index]
        priceText.text = GVar.priceArray[GVar.memoNumber][index]
        quantityText.text = GVar.quantityArray[GVar.memoNumber][index]
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        GVar.productNameArray[GVar.memoNumber].append(productNameText.text ?? "")
        GVar.priceArray[GVar.memoNumber].append(priceText.text ?? "0")
        GVar.quantityArray[GVar.memoNumber].append(quantityText.text ?? "0")
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toCalcu(_ sender: Any) {
        self.performSegue(withIdentifier: "toCalcu", sender: nil)
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            toCalcuButton.isHidden = true
        case 1:
            toCalcuButton.isHidden = false
        default:
            break
        }
    }
    
}
