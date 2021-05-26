//
//  CalculatorViewController.swift
//  shoppingMemo
//
//  Created by yuma oishi on 2021/04/09.
//

import UIKit

class CalculatorViewController: UIViewController {

    
    enum CaluculateStatus {
        case none, plus, minus, multiplication, division
    }

    var firstNumber = ""
    var secondNumber = ""
    var calculateStatus:CaluculateStatus = .none
    
    let numbers = [
        ["C","%","÷"],
        ["7","8","9","×"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        ["0",".","="]
    ]
    
    let cellId = "cellId"
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
            calculatorCollectionView.delegate = self
            calculatorCollectionView.dataSource = self
            calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: cellId)
            calculatorHeightConstraint.constant = view.frame.width * 1.4
            calculatorCollectionView.backgroundColor = .clear
            calculatorCollectionView.contentInset = .init(top: 0, left: 14, bottom: 0, right: 14)
            
            numberLabel.text = "0"
            
            view.backgroundColor = .black
        }
    
    func clear() {
            firstNumber = ""
            secondNumber = ""
            numberLabel.text = "0"
            calculateStatus = .none
        }
}
extension CalculatorViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return numbers.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return numbers[section].count
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return .init(width: collectionView.frame.width, height: 10)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            var width: CGFloat = 0
            width = ((collectionView.frame.width - 10) - 14 * 5) / 4
            let height = width
            if indexPath.section == 4 && indexPath.row == 0 {
                width = width * 2 + 14 + 9
            }
            if indexPath.section == 0 && indexPath.row == 0{
                width = width * 2 + 14 + 9
            }
            return .init(width: width, height: height)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 14
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalculatorViewCell
            cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
            
            numbers[indexPath.section][indexPath.row].forEach { (numberString) in
                if "0"..."9" ~= numberString || numberString.description == "." {
                    cell.numberLabel.backgroundColor = .darkGray
                } else if numberString == "C" || numberString == "%" || numberString == "±" {
                    cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                    cell.numberLabel.textColor = .black
                }
            }
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let number = numbers[indexPath.section][indexPath.row]
            
            switch calculateStatus {
            case .none:
                handleFirstNumberSelected(number: number)
            case .plus, .minus, .multiplication, .division:
                handleSecondNumberSelected(number: number)
            }
        }
        
        private func handleFirstNumberSelected(number: String) {
            switch number {
            case "0":
                if firstNumber.count != 0{
                 firstNumber += number
                 numberLabel.text = firstNumber
                }
             case "1"..."9":
                 firstNumber += number
                 numberLabel.text = firstNumber
             case ".":
                 if !confirmIncludeDecimalPoint(numberString: firstNumber) {
                    if firstNumber.count == 0{
                        firstNumber += "0\(number)"
                    }else{
                        firstNumber += number
                    }
                    numberLabel.text = firstNumber
                 }
            case "%":
                if firstNumber.count != 0{
                    firstNumber = String(Float(firstNumber)! / 100)
                    numberLabel.text = firstNumber
                    if firstNumber.hasSuffix(".0"){
                        numberLabel.text = firstNumber.replacingOccurrences(of: ".0", with: "")
                    }
                }
             case "+":
                 calculateStatus = .plus
             case "-":
                 calculateStatus = .minus
             case "×":
                 calculateStatus = .multiplication
             case "÷":
                 calculateStatus = .division
             case "C":
                 clear()
             default:
                 break
             }
        }
        
        private func handleSecondNumberSelected(number: String) {
            switch number {
            case "0":
                if secondNumber.count != 0{
                    secondNumber += number
                    numberLabel.text = secondNumber
                }
             case "1"..."9":
                 secondNumber += number
                 numberLabel.text = secondNumber
             case ".":
                if secondNumber.count == 0{
                    secondNumber += "0\(number)"
                }else{
                    secondNumber += number
                }
                numberLabel.text = secondNumber
            case "%":
                if secondNumber.count != 0{
                    secondNumber = String(Float(secondNumber)! / 100)
                    numberLabel.text = secondNumber
                    if secondNumber.hasSuffix(".0"){
                        numberLabel.text = secondNumber.replacingOccurrences(of: ".0", with: "")
                    }
                }
             case "=":
                calculateResultNumber()
             case "C":
                 clear()
             default:
                 break
             }
        }
        
        private func calculateResultNumber() {
            let firstNum = Double(firstNumber) ?? 0
            let secondNum = Double(secondNumber) ?? 0
            
            var resultString: String?
            switch calculateStatus {
            case .plus:
                resultString = String(round((firstNum + secondNum)*100)/100)
            case .minus:
                resultString = String(round((firstNum - secondNum)*100)/100)
            case .multiplication:
                resultString = String(round((firstNum * secondNum)*100)/100)
            case .division:
                resultString = String(round((firstNum / secondNum)*100)/100)
            default:
                break
            }
            
            if let result = resultString, result.hasSuffix(".0") {
                resultString = result.replacingOccurrences(of: ".0", with: "")
            }
            
            numberLabel.text = resultString
            firstNumber = ""
            secondNumber = ""
            
            firstNumber += resultString ?? ""
            calculateStatus = .none
        }
        
        private func confirmIncludeDecimalPoint(numberString: String) -> Bool {
            if numberString.range(of: ".") != nil {
                return true
            } else {
                return false
            }}
}
