//
//  Calculation.swift
//  Calculator
//
//  Created by Li Cai on 1/8/15.
//  Copyright (c) 2015 LC. All rights reserved.
//

import UIKit

class Calculation: NSObject {
    var operate=[-1]
    var number=[-1]
    var num=0
    var result=0
    var neg=false
    var prev=false
    //only do append number0-9, and operators +-, and (+/-)
    func add(str:String){
        if operate.count>0&&operate[0]==(-1) {
            operate.removeAtIndex(0);}
        if number.count>0&&number[0]==(-1) {
            number.removeAtIndex(0);}
        if str=="+"||str=="-"||str=="*"||str=="/"||str=="=" {
            if neg==false{number.append(num)}
            else{number.append(-num)}
            neg=false
            num=0
        }
        println(str)
        println(operate)
        println(number)
        println()
        num*=10
        switch(str){
        case("0"):
            num+=0
        case("1"):
            num+=1
        case("2"):
            num+=2
        case("3"):
            num+=3
        case("4"):
            num+=4
        case("5"):
            num+=5
        case("6"):
            num+=6
        case("7"):
            num+=7
        case("8"):
            num+=8
        case("9"):
            num+=9
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
    }
    func transform(){
        if neg==true{
            neg=false
        }
        else{
            neg=true
        }
    }
    func getresult(){
        while(operate.count>0&&number.count>1){
            println("===")
            println(number)
            println(operate)
            println("===")
            var a=getValue();
            var b=getOperator();
            var c=getValue();
            if(b==0){
                while (operate.count>0)&&(operate.last>1){
                    let secOp=getOperator()
                    if secOp==2||secOp==3{
                        let secNum=getValue()
                        if secOp==3 {
                            c/=secNum
                        }
                        else {
                            c*=secNum
                        }
                    }
                }
                number.append(a+c)
            }
            if(b==1){
                while (operate.count>0)&&(operate.last>1){
                    let secOp=getOperator()
                    if secOp==2||secOp==3{
                        let secNum=getValue()
                        if secOp==3 {
                            c/=secNum
                        }
                        else {
                            c*=secNum
                        }
                    }
                }
                number.append(c-a)
            }
            if(b==2){
                number.append(a*c)}
            if(b==3){
                number.append(c/a)}}
        
        result=number.first!
        number=[-1]
        operate=[-1]
        num=0
        neg=false
        prev=true
    }
    func getValue() -> Int{
        if(number.count>0){return number.removeLast();}
        else{return -1;}
    }
    func getOperator() -> Int{
        if(operate.count>0){return operate.removeLast();}
        else{return -1;}
    }
}
