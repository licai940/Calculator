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
    var numstr:[String] = []
    var neg=false
    var dot=false
    var include=false
    var finish=false
    var calList:[Calculation]=[]
    var calSpot:[Int]=[]
    var base=false
    var calPos:Int=0
    
    var result:Float=0
    
    //add a new parentheses
    func parentheses(){
        var fill=false
        if countElements(num)>0 {
            var n=(num as NSString).floatValue
            if neg==false {
                number.append(n)
                numstr.append(num)
            }
            else{
                number.append(0-n)
                numstr.append("-("+num+")")
            }
            neg=false
            num=""
            fill=true
        }
        
        if !include {
            if base{//base: create new () calculation
                if operate.count<number.count {
                    operate.append(2)
                }
                calList.append(Calculation())
                calSpot.append(number.count)
                number.append(-1)
                numstr.append("")
                include=true
            }
            else if number.count>operate.count {//end the current one
                finish=true
                getresult()
            }
            else{
                calList.append(Calculation())
                calSpot.append(number.count)
                number.append(-1)
                numstr.append("")
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
        else if neg {
            parentheses()
            neg=false
        }
        else if number==[]&&operate==[] {
            return
        }
        else{
            if include {
                if calList.last?.number.count==0&&calList.last?.operate.count==0&&calList.last?.num=="" {
                    calList.removeLast()
                    number.removeLast()
                    numstr.removeLast()
                    calSpot.removeLast()
                    include=false
                }
                else {
                    println(calList.last?.number.count)
                    println(calList.last?.operate.count)
                    println(calList.last?.num)
                    calList.last?.remove()
                }
            }
            else if numstr.count>operate.count&&numstr[numstr.count-1]=="" {
                calList.last?.finish=false
                include=true
            }
            else if numstr.count>operate.count {
                let temp=number.removeLast()
                var tempstr=numstr.removeLast()
                if countElements(tempstr)==0 {
                    return
                }
                num = tempstr
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
            else{
                operate.removeLast()
                let temp=number.removeLast()
                var tempstr=numstr.removeLast()
                num = tempstr
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
    
    //only do append + _ * /
    //done
    func addOperate(str:String){
        if include {
            calList.last?.addOperate(str)
            return
        }
        if countElements(num)==0&&(!(numstr.last=="")) {
            return
        }
        else if countElements(num)>0 {
            var n=(num as NSString).floatValue
            if neg==false {
                number.append(n)
                numstr.append(num)
            }
            else{
                number.append(0-n)
                numstr.append("-("+num+")")
            }
            neg=false
            num=""
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
    }
    
    func proc()->String{
        var p:String=""
        var pos=0
        var calpos=0
        for (pos=0;pos<numstr.count;pos++){
            if numstr[pos]=="" {
                p+="("+calList[calpos].proc()
                if calList[calpos].finish {
                    p+=")"
                }
                calpos++
            }
            else {
                p+=numstr[pos]
            }
            if(operate.count<=pos) {
                continue
            }
            if(operate[pos]==0){
                p+="+"
            }
            if(operate[pos]==1){
                p+="-"
            }
            if(operate[pos]==2){
                p+="*"
            }
            if(operate[pos]==3){
                p+="/"
            }
        }
        if neg {
            p+="(-"
        }
        if countElements(num)>0{
            p+=num
        }
        return p
    }
   
    //do calculation O(N)
    //done
    func getresult(){
        if number.count==0 {
            return
        }
        var numCounter=0
        var opCounter=0
        result=getNumber(numCounter)
        numCounter++
        while(operate.count>opCounter&&number.count>numCounter){
            var c=getNumber(numCounter)
            if getOperate(opCounter)==0{
                while operate.count>(numCounter+1)&&operate[opCounter+1]>1{
                    numCounter++
                    opCounter++
                    if operate[opCounter]==3 {
                        c/=getNumber(numCounter)
                    }
                    else {
                        c*=getNumber(numCounter)
                    }
                }
                result+=c
            }
            else if getOperate(opCounter)==1{
                while operate.count>(numCounter+1)&&operate[opCounter+1]>1{
                    numCounter++
                    opCounter++
                    if operate[opCounter]==3 {
                        c/=getNumber(numCounter)
                    }
                    else {
                        c*=getNumber(numCounter)
                    }
                }
                result-=c
            }
            else if getOperate(opCounter)==2{
                result*=c
            }
            else if getOperate(opCounter)==3{
             result/=c
            }
            opCounter++
            numCounter++
        }

    }
    
    //done
    func clear(){
        operate = []
        number = []
        num=""
        numstr=[]
        neg=false
        dot=false
        include=false
        finish=false
        calList=[]
        calSpot=[]
        result=0
    }
    
    //output result
    //done
    func print()->String{
        let s = NSString(format: "%f", result)
        return s
        }
    
    //wrapper
    //done
    func getNumber(pos:Int)->Float{
        if number.count>pos {
            if numstr[pos]=="" {
                return calList[calPos++].result
            }
            else {
                return number[pos]
            }
        }
        else {
            return -1
        }
    }
    
    //wrapper
    //done
    func getOperate(pos:Int)->Int{
        if operate.count>pos {
            return operate[pos]
        }
        else {
            return -1
        }
        
    }
}
