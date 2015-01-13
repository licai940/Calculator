//
//  ViewController.swift
//  Calculator
//
//  Created by Li Cai on 1/8/15.
//  Copyright (c) 2015 LC. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    var calculation:Calculation=Calculation()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        calculation.base=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBOutlet var Result: UILabel!
    
    @IBOutlet var Formula: UILabel!
    
    //done
    @IBAction func remove(sender: UIButton) {
        calculation.remove()
        Formula.text=calculation.proc()
    }
    
    //done
    @IBAction func number(sender: UIButton) {
        println(sender.currentTitle!)
        calculation.addNumber(sender.currentTitle!)
        Formula.text=calculation.proc()
    }
    
    //done
    @IBAction func operate(sender: UIButton) {
        var button=sender.currentTitle!
        println(button)
        calculation.addOperate(sender.currentTitle!)
        if button=="=" {
            Result.text=calculation.print()
            calculation.clear()
        }
        else {
            Formula.text=calculation.proc()
        }
    }
    
    //done
    @IBAction func clear(sender: UIButton) {
        println("clear")
        calculation.clear()
        Formula.text=""
        Result.text=""
    }
    
    @IBAction func parentheses(sender: UIButton) {
        println("parentheses")
        calculation.parentheses()
        Formula.text=calculation.proc()
    }
    
}




