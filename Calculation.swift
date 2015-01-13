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
                numstr.append("(-"+num+")")
                neg=false
                num=""
                fill=true
                return
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
        //empty, nothing to remove
        if number==[]&&operate==[]&&num==""&&neg==false {
            println("A")
            return
        }
        //unfinished parentheses
        else if include {
            println("B")
            if calList.last?.number.count==0&&calList.last?.operate.count==0&&calList.last?.num==""&&calList.last?.neg==false {
                calList.removeLast()
                number.removeLast()
                numstr.removeLast()
                calSpot.removeLast()
                include=false
            }
            else {
                calList.last?.remove()
            }
        }
        //finished parentheses
        else if numstr.count>operate.count&&numstr[numstr.count-1]=="" {
            println("C")
            calList.last?.finish=false
            include=true
        }
        //unfinished number,digit>=1
        else if countElements(num)>0 {
            println("D")
            num=(num as NSString).substringToIndex(countElements(num)-1)
        }
        //unfinished neg number to parentheses
        else if countElements(num)==0&&neg {
            println("E")
            neg=false
            dot=false
            parentheses()
        }
        //finished number
        else if countElements (num)==0&&operate.count<number.count {
            println("F")
            var tempstr=numstr.removeLast()
            var tempnum=number.removeLast()
            //only one digit positive
            if countElements(tempstr)==1 {
                return
            }
            //more than one digit positive
            else if tempnum>0 {
                num=(tempstr as NSString).substringToIndex(countElements(tempstr)-1)
            }
            //negative
            num=(tempstr as NSString).substringFromIndex(2)
            num=(num as NSString).substringToIndex(countElements(num)-1)
            neg=true
            if (num as NSString).containsString(".") {
                dot=true
            }
            else {
                dot=false
            }
            
        }
        //operator
        else{
            println("G")
            operate.removeLast()
            if number.last<0 {
                return
            }
            let temp=number.removeLast()
            var tempstr=numstr.removeLast()
            num = tempstr
            neg=false
            if temp%1>0 {
                dot=true
            }
            else {
                dot=false
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
        if num==""&&operate.count<number.count {
            operate.append(2)
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
        if countElements(num)==0&&operate.count==number.count {
            if operate.count==0 {
                return
            }
            operate.removeLast()
        }
        else if countElements(num)>0 {
            var n=(num as NSString).floatValue
            if neg==false {
                number.append(n)
                numstr.append(num)
            }
            else{
                number.append(0-n)
                numstr.append("(-"+num+")")
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
        println("===")
        println(numstr)
        println(number)
        println(operate)
        println(num)
        var p:String=""
        var pos=0
        calPos=0
        println(p)
        for (pos=0;pos<numstr.count;pos++){
            if numstr[pos]=="" {
                p+="("+calList[calPos].proc()
                if calList[calPos].finish {
                    p+=")"
                }
                calPos++
                println("1")
            }
            else {
                p+=numstr[pos]
                println("2")
            }
            if(operate.count<=pos) {
                println("3")
                continue
            }
            if(operate[pos]==0){
                println("4")
                p+="+"
            }
            if(operate[pos]==1){
                println("5")
                p+="-"
            }
            if(operate[pos]==2){
                println("6")
                p+="*"
            }
            if(operate[pos]==3){
                println("7")
                p+="/"
            }
        }
        if neg {
            p+="(-"
        }
        if countElements(num)>0{
            p+=num
        }
        println(p)
        println("===")
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
        calPos=0
        result=getNumber(numCounter)
        numCounter++
        while(operate.count>opCounter&&number.count>numCounter){
            
            var c=getNumber(numCounter)
            if getOperate(opCounter)==0{
                while number.count>numCounter&&operate.count>(opCounter+1)&&operate[opCounter+1]>1{
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
                while number.count>numCounter&&operate.count>(opCounter+1)&&operate[opCounter+1]>1{
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
        if result<1000&&result>(-1000) {
            return NSString(format: "%f", result)
        }
        result=abs(result)
        let digit:Int=(Int)(log10(result))
        var s=""
        for var i=digit-digit%3;i>=3;i-=3 {
            let base:Int=Int(pow(Double(10), Double(i)))
            var num:Int=Int(result)/base
            num%=1000
            
            if i==digit-digit%3 {
                s+=String(num)+","
            }
            else {
                if(num<10){
                    s+="00"
                }
                else if(num<100){
                    s+="0"
                }
                s+=String(num)+","
            }
        }
        let num=Int(result)%1000
        if(num<10){
            s+="00"
        }
        else if(num<100){
            s+="0"
        }
        s+=String(num)
        s+=NSString(format: "%f", result%1).substringFromIndex(1)
        if neg {
            result=0-result
            s="-"+s
        }
        return s
    }
    
    //wrapper
    //done
    func getNumber(pos:Int)->Float{
        if number.count>pos {
            if numstr[pos]=="" {
                for var i=0;i<calSpot.count;i+=1 {
                    if pos==calSpot[i]{
                        return calList[i].result
                    }
                }
            }
            else {
                return number[pos]
            }
        }
            return -1
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
