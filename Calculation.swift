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
    var include=false
    var finish=false
    var calList:[Calculation]=[]
    var calSpot:[Int]=[]
    var base=false
    
    //add a new parentheses
    func parentheses(){
        var fill=false
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
            fill=true
        }
        
        if !include {
            if base{//base: create new () calculation
                if fill {
                    operate.append(2)
                    process.append("*")
                }
                calList.append(Calculation())
                calSpot.append(number.count)
                number.append(-1)
                process.append("?")
                include=true
            }
            else if fill {//end the current one
                finish=true
                getresult()
            }
            else{
                calList.append(Calculation())
                calSpot.append(number.count)
                number.append(-1)
                process.append("?")
                include=true
            }
        }
        else {
            calList.last?.parentheses()
            if calList.last?.finish==true {
                include=false
            }
        }
    }

    //relating to "X" button
    //done
    func remove(){
        if countElements(num)>0 {
            num=(num as NSString).substringToIndex(countElements(num)-1)
        }
        else if (process.count==0) {
            return
        }
        else{
            if process.last=="?" {
                if calList.last?.process.count>0||(!(calList.last?.num=="")) {
                    calList.last?.remove()
                    if calList.last?.finish==false{
                        include=true
                    }
                }
                else {
                    calList.removeLast()
                    number.removeLast()
                    calSpot.removeLast()
                    process.removeLast()
                    include=false
                    
                }
            }
            else {
                if process.last=="+"||process.last=="-"||process.last=="*"||process.last=="/" {
                    process.removeLast()
                    operate.removeLast()
                    let temp=number.removeLast()
                    num = process.removeLast()
                    if temp<0 {
                        neg=true
                    }
                    else {
                        neg=false
                    }
                    if temp%1>0 {
                        dot=true
                    }
                    else {
                        dot=false
                    }
                }
            }

        }
    }
    
    //only do append number0-9, and . and (+/-)
    //done
    func addNumber(str:String){
        if include {
            calList.last?.addNumber(str)
            return
        }
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
                    if(num=="") {
                        num+="0"
                    }
                    num+=str
                }
            }
            else {
                if countElements(num)>1||(!(num=="0")){
                    num+=str
                }
                else {
                    num=str
                }
            }
        }
    }

    func proc()->String{
        var p:String=""
        var pos=0
        for (var i=0;i<countElements(process);i++){
            if process[i]=="?" {
                
                p+="("+calList[pos].proc()
                if calList[pos].finish {
                    p+=")"
                }
                pos++
            }
            else {
                p+=process[i]
            }
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
    //done
    func addOperate(str:String)->Bool{
        if include {
            let val=calList.last?.addOperate(str)
            return val!
        }
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
            return false
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
        return true
    }
    
    //do calculation O(N)
    //done
    func getresult(){
        while(operate.count>0&&number.count>1){
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
    
    //done
    func clear(){
        operate = []
        number = []
        num=""
        neg=false
        dot=false
        process = []
        include=false
        finish=false
        calList=[]
        calSpot=[]
    }
    
    //output result
    //done
    func print()->String{
        let s = NSString(format: "%f", number.first!)
        return s
        }
    
    //wrapper
    //done
    func getValue() -> Float{
        if(number.count>0){
            
            if calSpot.count==0||(calSpot.last != number.count-1){
                return number.removeLast()
            }
            else {
                number.removeLast()
                return calList[calSpot.count-1].number[0];
            }
        }
        else{
            return -1;
        }
    }
    
    //wrapper
    //done
    func getOperator() -> Int{
        if(operate.count>0){
            return operate.removeLast();
        }
        else{
            return -1;
        }
    }
}
