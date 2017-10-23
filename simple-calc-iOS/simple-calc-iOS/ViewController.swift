//
//  ViewController.swift
//  simple-calc-iOS
//
//  Created by zichu zheng on 10/22/17.
//  Copyright © 2017 zichu zheng. All rights reserved.
//

import UIKit

enum op {
    case none, add, sub, mul, div, mod, count, avg, fact, addRPN, subRPN, mulRPN, divRPN, modRPN
}

class ViewController: UIViewController {
    //for display result
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var rpnLabel: UILabel!
    //for enable and disable
    @IBOutlet weak var rpnEnter: UIButton!
    @IBOutlet weak var equalButton: UIButton!


    var oldResult : Double?
    var currentOp : op = .none
    var rpn = false
    var opNumber : [Double] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
        rpnLabel.text = "RPN off"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // add text to the result label
    @IBAction func numberButtonPress(_ sender: UIButton) {
        resultLabel.text = resultLabel.text! + (sender.titleLabel?.text)!
    }

    @IBAction func buttonDiv(_ sender: UIButton) {
        rpn ? rpnCal(op: .divRPN) : nonRPNCal(op: .div)
    }
    
    @IBAction func buttonMul(_ sender: UIButton) {
        rpn ? rpnCal(op: .mulRPN) : nonRPNCal(op: .mul)
    }
    
    @IBAction func buttonSub(_ sender: UIButton) {
        rpn ? rpnCal(op: .subRPN) : nonRPNCal(op: .sub)
    }
    
    @IBAction func buttonAdd(_ sender: UIButton) {
        rpn ? rpnCal(op: .addRPN) : nonRPNCal(op: .add)
    }
    
    @IBAction func buttonMod(_ sender: UIButton) {
        rpn ? rpnCal(op: .modRPN) : nonRPNCal(op: .mod)
    }
    
    @IBAction func buttonAC(_ sender: UIButton) {
        _ = clearResultLabel()
        oldResult = nil
        currentOp = .none
        opNumber = []
    }
    
    @IBAction func buttonEqual(_ sender: UIButton) {
        let newInput = clearResultLabel()
        if let value = newInput { opNumber.append(value) }
        let result = doOp(op: currentOp, first: oldResult, second: newInput)
        setLabel(num: result)
    }
    
    @IBAction func buttonCount(_ sender: UIButton) {
        currentOp = .count
        if let value = clearResultLabel() {
            opNumber.append(value)
        }
        if (rpn) { rpnCal(op: .count) }
    }
    
    @IBAction func buttonAvg(_ sender: UIButton) {
        currentOp = .avg
        if let value = clearResultLabel() {
            opNumber.append(value)
        }
        if (rpn) { rpnCal(op: .avg) }
    }
    
    @IBAction func buttonFact(_ sender: UIButton) {
        currentOp = .fact
        buttonEqual(sender)
    }
    
    @IBAction func buttonRPN(_ sender: UIButton) {
        rpn = !rpn
        rpnLabel.text = rpn ? "RPN on" : "RPN off"
        rpnEnter.isEnabled = rpn
        equalButton.isEnabled = !rpn
    }
    
    @IBAction func rpnEnterPress(_ sender: Any) {
        if let value = clearResultLabel() {
            opNumber.append(value)
        }
    }
    
    func nonRPNCal(op : op) {
        calOld(op: op)
        currentOp = op
        uiDoOp()
    }
        
    func rpnCal(op: op) {
        if let value = clearResultLabel() { opNumber.append(value) }
        let result = doOp(op: op, first: nil, second: nil)
        setLabel(num: result)
    }
    
    func clearResultLabel() -> Double? {
        if let result = Double(resultLabel.text!) {
            resultLabel.text = ""
            return result
        }
        return nil
    }
    
    func setLabel(num: Double) {
        if (floor(num) == num) {
            resultLabel.text = "\(Int(num))"
        } else {
            resultLabel.text = "\(num)"
        }
    }
    
    func uiDoOp() {
        if let old = oldResult {
            oldResult = doOp(op: currentOp, first: old, second: clearResultLabel())
        } else {
            oldResult = clearResultLabel()
        }
    }
    
    func calOld(op : op) {
        if let old = oldResult {
            oldResult = doOp(op: currentOp, first: old, second: clearResultLabel())
        }
    }
    
    // take op as string, and two doudle as parameter
    // return the result first op second.
    func doOp(op: op, first: Double?, second: Double?) -> Double {
        var result : Double? = nil
        let first = first != nil ? first! : 0.0
        let second = second != nil ? second! : 0.0
        switch op {
        case .add:
            result = first + second
        case .sub:
            result = first - second
        case .mul:
            result = first * second
        case .div:
            result = first / second
        case .mod:
            var num = first
            while (num >= second) { num -= second }
            result = num
        case .addRPN:
            for each in opNumber {
                result = result == nil ? each : result! + each
            }
        case .subRPN:
            for each in opNumber {
                result = result == nil ? each : result! - each
            }
        case .mulRPN:
            for each in opNumber {
                result = result == nil ? each : result! * each
            }
        case .divRPN:
            for each in opNumber {
                result = result == nil ? each : result! / each
            }
        case .count:
        
            result = Double(opNumber.count)
        case .avg:
            var sum = 0.0
            for i in 0...(opNumber.count - 1) {
                sum += opNumber[i]
            }
            result = sum / Double(opNumber.count)
        case .fact:
            result = floor(second) == second ? Double(fact(num: Int(floor(second)))) : 0
        default:
            result = 0
        }
        return result!
    }
    
    // retrun fact of given int
    func fact(num : Int) -> Int {
        if (num == 0) {
            return 1
        }
        return num * fact(num : num - 1)
    }
}