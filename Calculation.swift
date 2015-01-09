//
//  Calculation.swift
//  Calculator
//
//  Created by Li Cai on 1/8/15.
//  Copyright (c) 2015 LC. All rights reserved.
//

import UIKit

class Calculation: NSObject {
    var operate:[Int] = []
    var number:[Float] = []
    var num=""
    var neg=false
    var dot=false
    var process:[String] = []
    
    //only do append number0-9, and . and (+/-)
    func addNumber(str:String){
        if countElements(str)>1{
            if !neg{
                neg=true
            }
            else {
                neg=false
            }
        }
        else{
            if(str=="."){
                if !dot {
                    dot=true
                    num+=str
                }
            }
            else{
                num+=str
            }
        }
    }
    func proc()->String{
        var p:String=""
        for (var i=0;i<countElements(process);i++){
            p+=process[i]
        }
        if neg{
            p+="(-"
        }
        if countElements(num)>0 {
            p+=num
        }
        return p
    }
    //only do append + _ * /
    func addOperate(str:String){
        if countElements(num)>0 {
            var n=(num as NSString).floatValue
            if neg==false {
                number.append(n)
                process.append(num)
            }
            else{
                number.append(0-n)
                process.append("-("+num+")")
            }
            neg=false
            num=""
        }
        if operate.count>=number.count{
            return
        }
        switch(str){
        case("+"):
            operate.append(0)
        case("-"):
            operate.append(1)
        case("*"):
            operate.append(2)
        case("/"):
            operate.append(3)
        case("="):
            getresult()
        default:
            operate.append(-1)
        }
        process.append(str)
    }
    
    //do calculation O(N)
    func getresult(){
        while(operate.count>0&&number.count>1){
            println(number)
            println(operate)
            var a=getValue()
            var b=getOperator()
            var c=getValue()
            if(b==0){
                while (operate.count>0)&&(operate.last>1){
                    let secOp=getOperator()
                    let secNum=getValue()
                    if secOp==3 {
                        c/=secNum
                    }
                    else {
                        c*=secNum
                    }
                }
                number.append(a+c)
            }
            if(b==1){
                var temp=false
                while (operate.count>0)&&(operate.last>0){
                    let secOp=getOperator()
                    let secNum=getValue()
                    if secOp==3 {
                        c/=secNum
                        break
                        
                    }
                    else if secOp==2{
                        c*=secNum
                        break
                    }
                    else{
                        number.append(secNum)
                        operate.append(secOp)
                        number.append(c+a)
                        temp=true
                        break
                    }
                }
                if !temp{
                    number.append(c-a)
                }
            }
            if(b==2){
                number.append(c*a)
            }
            if(b==3){
             number.append(c/a)
            }
        }
    }
    
    func clear(){
        operate = []
        number = []
        num=""
        neg=false
        dot=false
        process = []
    }
    //output result
    func print()->String{
        let s = NSString(format: "%f", number.first!)
        return s
        }
    
    //wrapper
    func getValue() -> Float{
        if(number.count>0){
            return number.removeLast();
        }
        else{
            return -1;
        }
    }
    
    //wrapper
    func getOperator() -> Int{
        if(operate.count>0){
            return operate.removeLast();
        }
        else{
            return -1;
        }
    }
}
