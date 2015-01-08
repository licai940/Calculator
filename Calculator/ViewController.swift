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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet var Result: UILabel!
    
    @IBOutlet var Formula: UILabel!
    
    @IBAction func click(sender: UIButton) {
        var button=sender.currentTitle
        if calculation.prev {
            Formula.text!=""
            calculation.prev=false
        }
        Formula.text!+=button!
        
        calculation.add(sender.currentTitle!)
        if button=="=" {
            Result.text=String(calculation.result)
        }
        else{
            Result.text=""}
        
    }
    @IBAction func symbol(sender: UIButton) {
        calculation.transform()
        if calculation.neg==false {
            Formula.text!+="-"
        }
    }
    
}




