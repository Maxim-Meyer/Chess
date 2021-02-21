//
//  ViewController.swift
//  chess
//
//  Created by Maxim Meyer on 26.12.20.
//
// function computerMove-->calculates moves for computer...
// class Figure.possibleMoves contains possible options...
// func isFieldUnderAttack checks if a specific target field is available for a move
// K=KW, L=KS, M=SS, N=SW, O=BS, P=BW, Q=DW, R=TW, T=TS, V=LS, W=DS, B=LW, 7 = Space


import Cocoa
import AppKit

class ViewController: NSViewController {
    var firstclick=100
    var secondclick=100
    var firstchar = ""
    var secondchar = ""
    var rochadeW = 0
    var rochadeS = 0
    var move = 0
    var BlackcomputerPlayer = true
    
    var chessfield = ["TS","SS", "LS", "DS", "KS","LS","SS","TS","BS","BS","BS","BS","BS","BS","BS","BS","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","BW","BW","BW","BW","BW","BW","BW","BW","TW","SW","LW","DW","KW","LW","SW","TW"] //ALT+5

    var chessfield_new = ["TS","SS", "LS", "DS", "KS","LS","SS","TS","BS","BS","BS","BS","BS","BS","BS","BS","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","LL","BW","BW","BW","BW","BW","BW","BW","BW","TW","SW","LW","DW","KW","LW","SW","TW"] //ALT+5
    
    var ChessFieldforEachMove = [[String]]() // speicher alle Züge im Feld... (chessfield_new)


    class Figure {
        var name: String = "" //Name der Figur, bspw. KW = weißer König
        var value: Int = 0 //Wert der Figur, bspw. Dame = 5, Bauer = 1
        var protected: Int = 0 //durch wieviele Figuren ist die Figur gesichert?
        var position: Int = 0 //auf welchem Feld 0..63 steht die Figur?
        var underattack: Int = 0 //von wievielen Figuren wird die Figur angegriffen?
        var canattack: Int = 0 //wieviele Figuren kann die Figur direkt angreifen?
        var canmove: Int = 0 //wieviele Möglichkeiten gibt es die Figur zu bewegen?
        var canattacknext: Int = 0 //wieviele Figuren kann die Figur mit 2 Zügen direkt angreifen?
        var possibleMoves = [Int:Int]()
        var moveValue: Int = 0 // der Wert des Zuges von 0 bis 5 (0=OK, 1=strategisches Feld besetzen, 2=gleiche Figur schlagen, 3=höhere Figur schlagen, 4=andere Figur angreifen, 5=andere eigene Figure decken, 6 = Dame gegen Bauern eintauschen, 7 = König aus Schach nehmen, ...)
//        var moveValues = [Int:Int]() //a dictionary with the move and the value of the move
 
    }
    var allfigures = [Figure]()

    func isKingUnderAttack(color:Character)->Bool{
        var underattack = false
        if (allfigures.count>0){
            for i in 0...allfigures.count-1 {//suche den [s/w] König
                if (color == "W"){
                    if allfigures[i].name == "KW" {
                        //print ("check if WKing is under attack on \(allfigures[i].position) by S")

                        if (isFieldUnderAttack(field: allfigures[i].position, attacker: "S")) {
                            print ("WKing is under attack \(allfigures[i].position)")
                            underattack = true
                        }
                    } //König weiß...
                }else
                {
                    if allfigures[i].name == "KS" { break } //König weiß...
                }
            }
        }
        if (underattack) { return true} else { return false}
    }
    
    func update_field(){

        var labelArray = [F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10]//have to be separate arrays to avoid compiler error
        var labelArray1 = [F11, F12, F13, F14, F15, F16, F17, F18, F19, F20]
        var labelArray2 = [F21, F22, F23, F24, F25, F26, F27, F28, F29, F30]
        var labelArray3 = [F31, F32, F33, F34, F35, F36, F37, F38, F39, F40]
        var labelArray4 = [F41, F42, F43, F44, F45, F46, F47, F48, F49, F50]
        var labelArray5 = [F51, F52, F53, F54, F55, F56, F57, F58, F59, F60, F61, F62, F63]
        
        //update button field
        labelArray += labelArray1
        labelArray += labelArray2
        labelArray += labelArray3
        labelArray += labelArray4
        labelArray += labelArray5

        ChessFieldforEachMove.append(chessfield_new)
        allfigures.removeAll() // collect available figures and their current position

        for i in 0...63{
            switch chessfield_new[i] {
            case "BW":
                labelArray[i]!.title="P"
                let figure = Figure()
                figure.value = 1
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
            case "SW":
                labelArray[i]!.title="N"
                let figure = Figure()
                figure.value = 2
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)

            case "LW":
                labelArray[i]!.title="B"
                let figure = Figure()
                figure.value = 2
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
            case "TW":
                labelArray[i]!.title="R"
                let figure = Figure()
                figure.value = 3
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
            case "KW":
                labelArray[i]!.title="K"
                let figure = Figure()
                figure.value = 5
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
            case "DW":
                labelArray[i]!.title="Q"
                let figure = Figure()
                figure.value = 4
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
            case "BS":
                labelArray[i]!.title="O"
                let figure = Figure()
                figure.value = 1
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
            case "SS":
                labelArray[i]!.title="M"
                let figure = Figure()
                figure.value = 2
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
            case "LS":
                labelArray[i]!.title="V"
                let figure = Figure()
                figure.value = 2
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
            case "TS":
                let figure = Figure()
                figure.value = 3
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
                labelArray[i]!.title="T"
            case "KS":
                let figure = Figure()
                figure.value = 5
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
                labelArray[i]!.title="L"
            case "DS":
                let figure = Figure()
                figure.value = 4
                figure.name = chessfield_new[i]
                figure.position = i
                figure.protected = 0
                figure.underattack = 0
                figure.canattack = 0
                figure.canattacknext = 0
                allfigures.append(figure)
                labelArray[i]!.title="W"
            case "LL":
                labelArray[i]!.title="7"
            default:
                print ("default")
            }
        }

        if(move%2 == 0){ //weiss hat gesetzt - Zug wird geprüft bevor Anzeige & nächster Zug für schwarz...
//            nextmove.title="schwarz" //change radio button title
            if(isKingUnderAttack(color:"W")) {
                print ("WKing is under attack")
                revert_update_field()
                help.stringValue="Du stehst im Schach!"
            } else {
                nextmovefigure.stringValue="O"//zeige als nächsten Player "schwarz"
                move += 1
                currentMove.stringValue = String(move)
                help.stringValue=""
                chessfield=chessfield_new//guard (Int(s) != nil) else { return false }
//                print ("update field - chessfield_new \(chessfield_new)")
            }
            if(isKingUnderAttack(color:"S")) {
                print ("SKing is under attack")
                help.stringValue="Schach!"
            }
//            nextmove.state = NSControl.StateValue.on //switch radio button
        } else // nächster Zug für weiß...
        {
//            nextmove.title="weiß"//change radio button title
            if(isKingUnderAttack(color:"S")) {
                print ("SKing is under attack")
                revert_update_field()
                help.stringValue="Du stehst im Schach!"
            } else {
                nextmovefigure.stringValue="P"//zeige als nächsten Player "weiß"
                chessfield=chessfield_new//guard (Int(s) != nil) else { return false }
                move += 1
                help.stringValue=""
                currentMove.stringValue = String(move)
                

            }
            if(isKingUnderAttack(color:"W")) {
                print ("WKing is under attack")
                help.stringValue="Schach!"
            }


//            nextmove.state = NSControl.StateValue.off
        }
        for i in 0...63{ // if all save do the move and update the field...
            switch chessfield_new[i] {
            case "BW": labelArray[i]!.title="P"
            case "SW": labelArray[i]!.title="N"
            case "LW": labelArray[i]!.title="B"
            case "TW": labelArray[i]!.title="R"
            case "KW": labelArray[i]!.title="K"
            case "DW": labelArray[i]!.title="Q"
            case "BS": labelArray[i]!.title="O"
            case "SS": labelArray[i]!.title="M"
            case "LS": labelArray[i]!.title="V"
            case "TS": labelArray[i]!.title="T"
            case "KS": labelArray[i]!.title="L"
            case "DS": labelArray[i]!.title="W"
            case "LL": labelArray[i]!.title="7"
            default: print ("default")
            }
        }

        
    }

    func revert_update_field(){
        chessfield_new=chessfield
//        chessinput.stringValue=chessfield.joined()
        return
    }
    
    func isLineUp(to_tmp: Int, from_tmp: Int, x:Int)->Bool{
        if ((to_tmp/8)-(from_tmp/8))==x{
            return true
        }else{
            return false
        }
    }
    
    func isFieldUnderAttack(field:Int, attacker:Character)->Bool{
        var spalte = field % 8 //die Spalte des zu prüfenden Feldes
        let zeile = field / 8
        var last = "" //letzte Figur vor dem zu prüfenden Feld
        var next = ""
        var under_attack = false

        func areLinesUnderAttack(direction:String, attacker:Character)->Bool{
            var owncolor: Character
            var Angreifer_links = [String]()
            var Angreifer_rechts = [String]()


            if (attacker=="W"){owncolor="S"}else{owncolor="W"}
            var nextfield = 0
            for i in 0...7 {//gibt es angreifende Figuren in der gleichen Spalte?
                switch direction{
                    case "UpandDown":
                        spalte=i*8 + field % 8
                        nextfield=8
                    case "LeftandRight":
                        spalte=(field/8)*8+i
                        nextfield=1
                    case "TopLeftandDownRight":
                        if ((((field/8)*8 + field%8 - (field%8)*9 + i*9)<64) && (((field/8)*8 + field%8 - (field%8)*9 + i*9)>0))  {
                            spalte = (field/8)*8
                            spalte += field%8
                            spalte -= (field%8)*9
                            spalte += i*9
                            nextfield=9
                        }
                    case "TopRightandDownLeft":
                        if (((field/8)*8 + field%8 - (field%8)*7 + i*7)<64) &&
                            (((((field/8)*8 + field%8 - (field%8)*7 + i*7)) % 8) >= (field%8))
                            {
                            spalte = (field/8)*8
                            spalte += field%8
                            spalte -= (field%8)*7
                            spalte += i*7
                            nextfield=7
                            //print ("SPALTE TopRightandDownLeft: \(spalte)")
                        }
                    default: print ("default")//spalte=i*8 + field % 8
                }
                //print ("SPALTE after case: \(spalte)")
                if spalte<field {
                    if chessfield_new[spalte] != "LL" { Angreifer_links.append(chessfield_new[spalte])
                        //last=chessfield_new[spalte]
                    }
                    last=chessfield_new[spalte]
//                    if (direction == "TopRightandDownLeft") {print("\(direction) < \(chessfield_new[spalte])")}
                }
                if spalte==field {
//                    if (direction == "TopRightandDownLeft") {print("\(direction) = \(chessfield_new[spalte]) last = \(last)")}

                //    if Angreifer_links.last! == ("K" + String(attacker)) {
                //        under_attack=true
                //        print ("Angriff durch König von Feld \(spalte) auf Feld \(field)")
                //        return true
                //    }else{
                        if !Angreifer_links.isEmpty {
                        //    print ("Angreifer_links.count \(Angreifer_links.count)")
                            var j=Angreifer_links.count//-1
                            //print ("\(Angreifer_links.first!):\(field): \(direction): j: \(j) :\(Angreifer_links.last!)")
                            while j>0 {
//                                if Angreifer_links.last?.last! == owncolor {
                                if last.last == owncolor {
                          //          print ("Angreifer_links.last?last! \(Angreifer_links.last?.last!)")
                                    return false
//                                    break //exit for loop // because safe...
                            //        print ("Angreifer_links \(Angreifer_links[j-1])")
                                    
                                }
                                else if (direction == "UpandDown") || (direction == "LeftandRight"){
                                    if Angreifer_links[j-1] == "D"+String(attacker) ||
                                        Angreifer_links[j-1] == "T"+String(attacker) {
                                        print ("\(field) gesichert/angegriffen durch \(Angreifer_links[j-1]) last: \(Angreifer_links.last!)")
                                      under_attack=true
                                        return true
                                            }
                                }
                                else if direction == "TopLeftandDownRight" || direction == "TopRightandDownLeft" {
                                    if Angreifer_links.last! == "D"+String(attacker) ||
                                        Angreifer_links.last! == "L"+String(attacker) {
                                        //print ("\(field) gesichert/angegriffen durch \(Angreifer_links[j-1]) last: \(Angreifer_links.last!)")
                                        under_attack=true
                                        return true
                                            }
                                    
                                }
                                /*else if ((((Angreifer_links[j-1] == "D"+String(attacker)) ||
                                        (Angreifer_links[j-1] == "L"+String(attacker))) &&
                                            ((direction == "TopLeftandDownRight") || (direction == "TopRightandDownLeft"))) ||
                                        (((Angreifer_links[j-1] == "D"+String(attacker)) ||
                                                (Angreifer_links[j-1] == "T"+String(attacker))) &&
                                                    ((direction == "UpandDown") || (direction == "LeftandRight")))

                                ){
                                    print ("\(field) - gesichert/angegriffen durch \(Angreifer_links[j-1])")
                                    
                                    if Angreifer_links.last!.first == "D" || Angreifer_links.last!.first == "L" || Angreifer_links.last!.first == "T" {
                                        print ("\(field) gesichert/angegriffen durch \(Angreifer_links[j-1])")
                                        
                                        under_attack=true
                                        return true
                                    } //nur wenn zwischen Dame, Läufer, Turm und Figur nichts steht -->dann gefährdet
                                    last=Angreifer_links[j-1]
                                    return true
                                }*/
                                j-=1
                            }
                  //      }
                    }
                }
                if spalte>field {
                    //print("\(direction) > Spalte \(spalte) Wert \(chessfield_new[spalte])")
                    if field == 8 {
//                        print ("ACHTUNG")
                    }
                    
                    if (spalte == field+nextfield && chessfield_new[spalte]==("K"+String(attacker))) {
                        under_attack=true
                        print ("Angriff durch König")
                        next="K"+String(attacker)
                        return true
                    }else{
                        next=chessfield_new[spalte]
                        if chessfield_new[spalte] != "LL" {Angreifer_rechts.append(chessfield_new[spalte])}
                    }
                }
                for j in Angreifer_rechts{
                    if !Angreifer_rechts.isEmpty {
                        if j.last! == owncolor {
                            return false
                            break //exit for loop // because safe...
                        }
                        if (j=="T"+String(attacker) && (direction=="LeftandRight" || direction=="UpandDown")) ||
                            (j=="L"+String(attacker) && (direction=="TopLeftandDownRight" || direction=="TopRightandDownLeft")) ||
                            (j=="D"+String(attacker)){
                            next=j
                            return true
                        } else {//es stehen andere Figuren zwischen der Figur und dem Turm, Läufer, Dame
                            //print ("ACHTUNG \(j)")
                            if (j != "T"+String(attacker) && (direction=="LeftandRight" || direction=="UpandDown")) &&
                                (j != "L"+String(attacker) && (direction=="TopLeftandDownRight" || direction=="TopRightandDownLeft")) &&
                                (j != "D"+String(attacker)){
                                return false
                                //break //sicher

                            }
                        }
                    }
                }
            }
            return false
        }
//START FUNCTION........
        if (areLinesUnderAttack(direction: "UpandDown",attacker:attacker)) { return true }
        if (areLinesUnderAttack(direction: "LeftandRight",attacker:attacker)) { return true }
        if (areLinesUnderAttack(direction: "TopLeftandDownRight",attacker:attacker)) { return true }
//        if (areLinesUnderAttack(direction: "TopRightandDownLeft",attacker:attacker)) { return true }
//greifen Springer an?-----------------------------
        spalte = field % 8
        if spalte>1{
            if zeile>0 && chessfield_new[field-10] == "S"+String(attacker){return true}
            if zeile<7 && chessfield_new[field+6] == "S"+String(attacker){return true}
        }
        if spalte>0{
            if zeile>1 && chessfield_new[field-17] == "S"+String(attacker){return true}
            if zeile<6 && chessfield_new[field+15] == "S"+String(attacker){return true}
        }
        if spalte<7{
            if zeile>1 && chessfield_new[field-15] == "S"+String(attacker){return true}
            if zeile<6 && chessfield_new[field+17] == "S"+String(attacker){return true}
        }
        if spalte<6{
            if zeile>0 && chessfield_new[field-6] == "S"+String(attacker){return true}
            if zeile<7 && chessfield_new[field+10] == "S"+String(attacker){return true}
        }
        
//greifen Bauern an?-----------------------------
        if attacker=="W"{
            if zeile<7{
                if spalte>0 && chessfield_new[field+7] == "BW"{return true}
                if spalte<7 && chessfield_new[field+9] == "BW"{return true}
            }
        }else{
            if zeile>0{
                if spalte>0 && chessfield_new[field-9] == "BS"{return true}
                if spalte<7 && chessfield_new[field-7] == "BS"{return true}
            }
        }
        
        if under_attack {return true} else {return false}
    }
    
    func getValidMoves(figure: String, position: Int)-> Array<Int>{//returns the possible moves of figure x on field y and returns an array
        //return [10,12,13]
        switch figure {
        case "BS":
            print("")
        default:
            print ("default")
        }
        return [10,12,13]
//
    }
    
    
//---------------------------------------------
    func newMove(chessinput_new: String) {
        NSSound.beep()
//        let chessinput_new = String(chessinput.stringValue)
        var tmp=""
        var counter=0
        //print ("new move")//chess input changed\n\(chessinput_new)")
        for character in chessinput_new {
            tmp=tmp+String(character)
            if tmp.count==2{
                chessfield_new[counter]=tmp
                counter+=1
                tmp=""
            }
        }
        //print("new move \(chessfield_new)")
        var from=0
        var to=0
        var figure=""
        
        for i in 0...chessfield.count-1{//find out which move was done...
            if chessfield[i]==chessfield_new[i]{
                //print("OK")
            }else{
                if chessfield_new[i]=="LL"{
                    from=i//wo stand figur?
                }else{
                    to=i//wohin wurde sie bewegt?
                    figure=chessfield_new[i]//welche Figur wurde bewegt?
                }
            }
        }
                //print("Feld \(i) wurde verändert von \(chessfield[i]) auf \(chessfield_new[i])")
                print ("\(figure) zieht von \(from) nach \(to)")
                let lastChar = chessfield[to].last!
                switch figure {
                case "BS":
                    if (from+8==to && (chessfield[to]=="LL") && (isLineUp(to_tmp: to,from_tmp: from,x:1)==true)) ||
                        (from+16==to && from>7 && from<16 && (chessfield[to]=="LL") && (chessfield[from+8]=="LL") && (isLineUp(to_tmp: to,from_tmp: from,x:2)==true)) ||
                         (from+7==to && !(chessfield[to]=="LL") && lastChar=="W" && (isLineUp(to_tmp: to,from_tmp: from,x:1)==true)) ||
                          (from+9==to && !(chessfield[to]=="LL") && lastChar=="W" && (isLineUp(to_tmp: to,from_tmp: from,x:1)==true)) {
                        //print("OK")
                        if (nextmovefigure.stringValue == "O")
                        {
                            update_field()
                        }else
                        {
                            revert_update_field()
                        }
                        if ((to+9)/8>=8){//letzte Reihe -->Tausche Bauer gegen Dame
                            print("Tausche Bauer gegen Dame")
                            chessfield_new[to]="DS"
                            if (nextmovefigure.stringValue == "O")
                            {
                                update_field()
                            }else
                            {
                                revert_update_field()
                            }
                        }
                    }else{
                        print("FEHLER")
                        revert_update_field()
                    }
                case "SS":
                    if (((from+15==to) || (from+17==to)) && ((chessfield[to]=="LL") || (lastChar=="W")) && (isLineUp(to_tmp: to,from_tmp: from,x:2)==true)) ||
                        (((from+6==to) || (from+10==to)) && ((chessfield[to]=="LL") || (lastChar=="W")) && (isLineUp(to_tmp: to,from_tmp: from,x:1)==true)) ||
                        (((from-15==to) || (from-17==to)) && ((chessfield[to]=="LL") || (lastChar=="W")) && (isLineUp(to_tmp: to,from_tmp: from,x:-2)==true)) ||
                            (((from-6==to) || (from-10==to)) && ((chessfield[to]=="LL") || (lastChar=="W")) && (isLineUp(to_tmp: to,from_tmp: from,x:-1)==true)){
                        print("OK")
                        if (nextmovefigure.stringValue == "O")
                        {
                            update_field()
                        }else
                        {
                            revert_update_field()
                        }
                    }else{
                        print("FEHLER")
                        revert_update_field()
                    }

                case "TS":
                    var max=0 // wieviele Zeilen wurde die Figur bewegt
                    var fehler=false
                    var tmove=0
                    if ((from/8 == to/8) || (from % 8 == to % 8)){//valide horizontal/vertikalBewegung
                        if (from/8 == to/8){
                            if (from<to){tmove = 1}else{tmove = -1}
                            max=(abs(to-from))
                            //print ("valide horizontalBewegung")
                        }else{
                            if (from<to){tmove = 8}else{tmove = -8}
                            max=(abs(to-from))/8
                            //print ("valide vertikalBewegung")
                        }
                        //print (max)
                        if max>1{ //prüfe ob eine Figur auf dem Weg... (nach rechts >1, nach links 1!)
                            for i in 1...max {
                                if (from+i*tmove != to){//überprüfe nicht mehr das zielfeld, dieses darf besetzt sein
                                    if !(chessfield[from+i*tmove]=="LL"){
                                        fehler=true
                                        break
                                    }
                                }
                            }
                            if (fehler==true){print("Fehler: Figuren auf dem Weg")}
                        }
                        
                        if (from+tmove*max==to) && fehler==false && ((chessfield[to]=="LL") || ((lastChar=="W") && chessfield[to] != "KW")){
                            print("OK")
                            if (nextmovefigure.stringValue == "O")
                            {
                                update_field()
                            }else
                            {
                                revert_update_field()
                            }
                        }else{
                            print("FEHLER")
                            revert_update_field()
                        }

                    }else{//keine valide diagonalBewegung
                        print("FEHLER: Dieser Zug ist nicht möglich")
                        revert_update_field()
                    }
                    
                case "KS":
                    var rochade=false
                    var kmove=0
                    if ((abs(to-from)%7==0) || (abs(to-from)%9==0) || ((from/8 == to/8) || (from % 8 == to % 8))){//valide Bewegung
                    //erlaube nur Zielfelder, die nicht im Schach stehen...
                        if (abs(to-from)%7==0){
                            if (from<to){kmove = 7}else{kmove = -7}
                            //print ("valide diagonalBewegung nach oben rechts oder unten links \(kmove)")
                        }else if (abs(to-from)%9==0){
                            if (from<to){kmove = 9}else{kmove = -9}
                            //print ("valide diagonalBewegung nach unten rechts oder oben links \(kmove)")
                        }else if (from/8 == to/8){
                            if (from<to){kmove = 1}else{kmove = -1}
                            //print ("valide horizontalBewegung \(kmove)")
                            if (((from+2==to) || (from-2==to)) && (from/8==0) && (from==4)) {//prüfe auf Rochade...
                                if ((from+2==to) && (chessfield[from+1]=="LL") && (chessfield[from+2]=="LL") && (chessfield[from+3]=="TS") && !isFieldUnderAttack(field: from, attacker:"W") && !isFieldUnderAttack(field: to, attacker:"W")) && rochadeS == 0 {
                                    rochade=true
                                    chessfield_new[from+1]="TS"
                                    chessfield_new[from+3]="LL"
                                }else if ((from-2==to) && (chessfield[from-1]=="LL") && (chessfield[from-2]=="LL") && (chessfield[from-3]=="LL") && (chessfield[from-4]=="TS") && !isFieldUnderAttack(field: from, attacker:"W") && !isFieldUnderAttack(field: to, attacker:"W")) && rochadeS == 0 {
                                    rochade=true
                                    chessfield_new[from-1]="TS"
                                    chessfield_new[from-4]="LL"
                                }
                            }
                        }else{
                            if (from<to){kmove = 8}else{kmove = -8}
                            //print ("valide vertikalBewegung \(kmove)")
                            
                        }

                        
                        if rochade==true || ((from+kmove==to) && ((chessfield[to]=="LL") || ((lastChar=="W") && chessfield[to] != "KW")) && !isFieldUnderAttack(field: to, attacker:"W")){
                            //print("OK")
                            if (nextmovefigure.stringValue == "O")
                            {
                                update_field()
                                rochadeS += 1
                            }else
                            {
                                revert_update_field()
                            }
                        }else{
                            //print("FEHLER")
                            revert_update_field()
                        }

                    }else{//keine valide diagonalBewegung
                        print("FEHLER: Dieser Zug ist nicht möglich")
                        revert_update_field()
                    }
                    
                case "LS":
                    var max=(abs(to-from))/8 // wieviele Zeilen wurde die Figur bewegt
                    var fehler=false
                    var lmove=0
                    if ((abs(to-from)%7==0) || (abs(to-from)%9==0)){//valide diagonalBewegung
                        if (abs(to-from)%7==0){
                            if (from<to){lmove = 7}else{lmove = -7} // Bewegung nach oben rechts oder unten links
                            //print ("valide diagonalBewegung nach oben rechts oder unten links")
                            max = max+1
                        }else{
                            if (from<to){lmove = 9}else{lmove = -9}  // Bewegung nach unten rechts oder oben links
                            //print ("valide diagonalBewegung nach unten rechts oder oben links")
                        }
                        print (max)
                        if max>1{ //prüfe ob eine Figur auf dem Weg... (nach rechts >1, nach links 1!)
                            for i in 1...max {
                                if (from+i*lmove != to){//überprüfe nicht mehr das zielfeld, dieses darf besetzt sein
                                    if !(chessfield[from+i*lmove]=="LL"){
                                        fehler=true
                                        break
                                    }
                                }
                            }
                            if (fehler==true){print("Fehler: Figuren auf dem Weg")}
                        }
                        
                        if (from+lmove*max==to) && fehler==false && ((chessfield[to]=="LL") || ((lastChar=="W") && chessfield[to] != "KW")){
                            print("OK")
                            if (nextmovefigure.stringValue == "O")
                            {
                                update_field()
                            }else
                            {
                                revert_update_field()
                            }

                        }else{
                            print("FEHLER")
                            revert_update_field()
                        }

                    }else{//keine valide diagonalBewegung
                        print("FEHLER: Dieser Zug ist nicht möglich")
                        revert_update_field()
                    }

                case "DS":
                    var max=0 // wieviele Zeilen wurde die Figur bewegt
                    var fehler=false
                    var dmove=0
                    if ((from/8 == to/8) || (from % 8 == to % 8)){//valide horizontal/vertikalBewegung
                        if (from/8 == to/8){
                            if (from<to){dmove = 1}else{dmove = -1}
                            max=(abs(to-from))
                            //print ("valide horizontalBewegung nach links oder rechts")
                        }else{
                            if (from<to){dmove = 8}else{dmove = -8}
                            max=(abs(to-from))/8
                            //print ("valide vertikalBewegung nach oben oder unten")
                        }
                        print (max)
                        if max>1{ //prüfe ob eine Figur auf dem Weg... (nach rechts >1, nach links 1!)
                            for i in 1...max {
                                if (from+i*dmove != to){//überprüfe nicht mehr das zielfeld, dieses darf besetzt sein
                                    if !(chessfield[from+i*dmove]=="LL"){
                                        fehler=true
                                        break
                                    }
                                }
                            }
                            if (fehler==true){print("Fehler: Figuren auf dem Weg")}
                        }
                        
                        if (from+dmove*max==to) && fehler==false && ((chessfield[to]=="LL") || ((lastChar=="W") && chessfield[to] != "KW")){
                            print("OK")
                            if (nextmovefigure.stringValue == "O")
                            {
                                update_field()
                            }else
                            {
                                revert_update_field()
                            }
                        }else{
                            print("FEHLER")
                            revert_update_field()
                        }

                    }else{//keine valide diagonalBewegung
                        var max=(abs(to-from))/8 // wieviele Zeilen wurde die Figur bewegt
                        var fehler=false
                        var xmove=0
                        if ((abs(to-from)%7==0) || (abs(to-from)%9==0)){//valide diagonalBewegung
                            if (abs(to-from)%7==0){
                                if (from<to){xmove = 7}else{xmove = -7} // Bewegung nach oben rechts oder unten links
                                //print ("valide diagonalBewegung nach oben rechts oder unten links")
                                max = max+1
                            }else{
                                if (from<to){xmove = 9}else{xmove = -9}  // Bewegung nach unten rechts oder oben links
                                //print ("valide diagonalBewegung nach unten rechts oder oben links")
                            }
                            print (max)
                            if max>1{ //prüfe ob eine Figur auf dem Weg... (nach rechts >1, nach links 1!)
                                for i in 1...max {
                                    if (from+i*xmove != to){//überprüfe nicht mehr das zielfeld, dieses darf besetzt sein
                                        if !(chessfield[from+i*xmove]=="LL"){
                                            fehler=true
                                            break
                                        }
                                    }
                                }
                                if (fehler==true){print("FEHLER: Figuren auf dem Weg")}
                            }
                            if (from+xmove*max==to) && fehler==false && ((chessfield[to]=="LL") || ((lastChar=="W") && chessfield[to] != "KW")){
                                    print("OK")
                                if (nextmovefigure.stringValue == "O")
                                {
                                    update_field()
                                }else
                                {
                                    revert_update_field()
                                }
                                }else{
                                    print("FEHLER")
                                    revert_update_field()
                                }

                        }else{//keine valide diagonalBewegung
                            print("FEHLER")
                            revert_update_field()
                        }
                }
                    
                    
                case "BW":
                    if (from-8==to && (chessfield[to]=="LL") && (isLineUp(to_tmp: to,from_tmp: from,x:-1)==true)) ||
                        (from-16==to && from>47 && from<56 && (chessfield[to]=="LL") && (chessfield[from-8]=="LL") && (isLineUp(to_tmp: to,from_tmp: from,x:-2)==true)) ||
                         (from-7==to && !(chessfield[to]=="LL") && lastChar=="S" && (isLineUp(to_tmp: to,from_tmp: from,x:-1)==true)) ||
                          (from-9==to && !(chessfield[to]=="LL") && lastChar=="S" && (isLineUp(to_tmp: to,from_tmp: from,x:-1)==true)){
                        print("OK")
                        if (nextmovefigure.stringValue == "P")
                        {
                            update_field()
                        }else
                        {
                            revert_update_field()
                        }
                        if (to/8==0){//letzte Reihe -->Tausche Bauer gegen Dame
                            print("Tausche Bauer gegen Dame")
                            chessfield_new[to]="DW"
                            if (nextmovefigure.stringValue == "P")
                            {
                                update_field()
                            }else
                            {
                                revert_update_field()
                            }
                        }
                    }else{
                        print("FEHLER")
                        revert_update_field()
                    }
                case "SW":
                    if (((from+15==to) || (from+17==to)) && ((chessfield[to]=="LL") || (lastChar=="S")) && (isLineUp(to_tmp: to,from_tmp: from,x:2)==true)) ||
                        (((from+6==to) || (from+10==to)) && ((chessfield[to]=="LL") || (lastChar=="S")) && (isLineUp(to_tmp: to,from_tmp: from,x:1)==true)) ||
                        (((from-15==to) || (from-17==to)) && ((chessfield[to]=="LL") || (lastChar=="S")) && (isLineUp(to_tmp: to,from_tmp: from,x:-2)==true)) ||
                            (((from-6==to) || (from-10==to)) && ((chessfield[to]=="LL") || (lastChar=="S")) && (isLineUp(to_tmp: to,from_tmp: from,x:-1)==true)){
                        print("OK")
                        if (nextmovefigure.stringValue == "P")
                        {
                            update_field()
                        }else
                        {
                            revert_update_field()
                        }
                    }else{
                        print("FEHLER")
                        revert_update_field()
                    }
                case "LW":
                    var max=(abs(to-from))/8 // wieviele Zeilen wurde die Figur bewegt
                    var fehler=false
                    var lmove=0
                    if ((abs(to-from)%7==0) || (abs(to-from)%9==0)){//valide diagonalBewegung
                        if (abs(to-from)%7==0){
                            if (from<to){lmove = 7}else{lmove = -7} // Bewegung nach oben rechts oder unten links
                            //print ("valide diagonalBewegung nach oben rechts oder unten links")
                            max = max+1
                        }else{
                            if (from<to){lmove = 9}else{lmove = -9}  // Bewegung nach unten rechts oder oben links
                            //print ("valide diagonalBewegung nach unten rechts oder oben links")
                        }
                        print (max)
                        if max>1{ //prüfe ob eine Figur auf dem Weg... (nach rechts >1, nach links 1!)
                            for i in 1...max {
                                if (from+i*lmove != to){//überprüfe nicht mehr das zielfeld, dieses darf besetzt sein
                                    if !(chessfield[from+i*lmove]=="LL"){
                                        fehler=true
                                        break
                                    }
                                }
                            }
                            if (fehler==true){print("FEHLER: Figuren auf dem Weg")}
                        }
                        
                        if (from+lmove*max==to) && fehler==false && ((chessfield[to]=="LL") || ((lastChar=="S") && chessfield[to] != "KS")){
                            print("OK")
                            if (nextmovefigure.stringValue == "P")
                            {
                                update_field()
                            }else
                            {
                                revert_update_field()
                            }
                        }else{
                            print("FEHLER")
                            revert_update_field()
                        }

                    }else{//keine valide diagonalBewegung
                        print("FEHLER")
                        revert_update_field()
                    }
                    
                case "TW":
                    var max=0 // wieviele Zeilen wurde die Figur bewegt
                    var fehler=false
                    var tmove=0
                    if ((from/8 == to/8) || (from % 8 == to % 8)){//valide horizontal/vertikalBewegung
                        if (from/8 == to/8){
                            if (from<to){tmove = 1}else{tmove = -1}
                            max=(abs(to-from))
                            //print ("valide horizontalBewegung nach links oder rechts")
                        }else{
                            if (from<to){tmove = 8}else{tmove = -8}
                            max=(abs(to-from))/8
                            //print ("valide vertikalBewegung nach oben oder unten")
                        }
                        print (max)
                        if max>1{ //prüfe ob eine Figur auf dem Weg... (nach rechts >1, nach links 1!)
                            for i in 1...max {
                                if (from+i*tmove != to){//überprüfe nicht mehr das zielfeld, dieses darf besetzt sein
                                    if !(chessfield[from+i*tmove]=="LL"){
                                        fehler=true
                                        break
                                    }
                                }
                            }
                            if (fehler==true){print("Fehler: Figuren auf dem Weg")}
                        }
                        
                        if (from+tmove*max==to) && fehler==false && ((chessfield[to]=="LL") || ((lastChar=="S") && chessfield[to] != "KS")){
                            print("OK")
                            if (nextmovefigure.stringValue == "P")
                            {
                                update_field()
                            }else
                            {
                                revert_update_field()
                            }
                        }else{
                            print("FEHLER")
                            revert_update_field()
                        }

                    }else{//keine valide diagonalBewegung
                        print("FEHLER: Dieser Zug ist nicht möglich")
                        revert_update_field()
                    }
                case "DW":
                    var max=0 // wieviele Zeilen wurde die Figur bewegt
                    var fehler=false
                    var dmove=0
                    if ((from/8 == to/8) || (from % 8 == to % 8)){//valide horizontal/vertikalBewegung
                        if (from/8 == to/8){
                            if (from<to){dmove = 1}else{dmove = -1}
                            max=(abs(to-from))
                            //print ("valide horizontalBewegung nach links oder rechts")
                        }else{
                            if (from<to){dmove = 8}else{dmove = -8}
                            max=(abs(to-from))/8
                            //print ("valide vertikalBewegung nach oben oder unten")
                        }
                        print (max)
                        if max>1{ //prüfe ob eine Figur auf dem Weg... (nach rechts >1, nach links 1!)
                            for i in 1...max {
                                if (from+i*dmove != to){//überprüfe nicht mehr das zielfeld, dieses darf besetzt sein
                                    if !(chessfield[from+i*dmove]=="LL"){
                                        fehler=true
                                        break
                                    }
                                }
                            }
                            if (fehler==true){print("Fehler: Figuren auf dem Weg")}
                        }
                        
                        if (from+dmove*max==to) && fehler==false && ((chessfield[to]=="LL") || ((lastChar=="S") && chessfield[to] != "KS")){
                            print("OK")
                            if (nextmovefigure.stringValue == "P")
                            {
                                update_field()
                            }else
                            {
                                revert_update_field()
                            }
                        }else{
                            print("FEHLER")
                            revert_update_field()
                        }

                    }else{//keine valide diagonalBewegung
                        var max=(abs(to-from))/8 // wieviele Zeilen wurde die Figur bewegt
                        var fehler=false
                        var xmove=0
                        if ((abs(to-from)%7==0) || (abs(to-from)%9==0)){//valide diagonalBewegung
                            if (abs(to-from)%7==0){
                                if (from<to){xmove = 7}else{xmove = -7} // Bewegung nach oben rechts oder unten links
                                //print ("valide diagonalBewegung nach oben rechts oder unten links")
                                max = max+1
                            }else{
                                if (from<to){xmove = 9}else{xmove = -9}  // Bewegung nach unten rechts oder oben links
                                //print ("valide diagonalBewegung nach unten rechts oder oben links")
                            }
                            print (max)
                            if max>1{ //prüfe ob eine Figur auf dem Weg... (nach rechts >1, nach links 1!)
                                for i in 1...max {
                                    if (from+i*xmove != to){//überprüfe nicht mehr das zielfeld, dieses darf besetzt sein
                                        if !(chessfield[from+i*xmove]=="LL"){
                                            fehler=true
                                            break
                                        }
                                    }
                                }
                                if (fehler==true){print("FEHLER: Figuren auf dem Weg")}
                            }
                            if (from+xmove*max==to) && fehler==false && ((chessfield[to]=="LL") || ((lastChar=="S") && chessfield[to] != "KS")){
                                    print("OK")
                                if (nextmovefigure.stringValue == "P")
                                {
                                    update_field()
                                }else
                                {
                                    revert_update_field()
                                }
                                }else{
                                    print("FEHLER")
                                    revert_update_field()
                                }

                        }else{//keine valide diagonalBewegung
                            print("FEHLER")
                            revert_update_field()
                        }
                }

                    
                case "KW":
                    var rochade=false
                    var kmove=0
                    if ((abs(to-from)%7==0) || (abs(to-from)%9==0) || ((from/8 == to/8) || (from % 8 == to % 8))){//valide Bewegung
                    //erlaube nur Zielfelder, die nicht im Schach stehen...
                        if (abs(to-from)%7==0){
                            if (from<to){kmove = 7}else{kmove = -7}
                            //print ("valide diagonalBewegung nach oben rechts oder unten links \(kmove)")
                        }else if (abs(to-from)%9==0){
                            if (from<to){kmove = 9}else{kmove = -9}
                            //print ("valide diagonalBewegung nach unten rechts oder oben links \(kmove)")
                        }else if (from/8 == to/8){
                            if (from<to){kmove = 1}else{kmove = -1}
                            //print ("valide horizontalBewegung \(kmove)")
                            if (((from+2==to) || (from-2==to)) && (from/8==7) && (from==60)) {//prüfe auf Rochade...
                                if ((from+2==to) && (chessfield[from+1]=="LL") && (chessfield[from+2]=="LL") && (chessfield[from+3]=="TW") && !isFieldUnderAttack(field: from, attacker:"S") && !isFieldUnderAttack(field: to, attacker:"S")) && rochadeW == 0 {
                                    rochade=true
                                    chessfield_new[from+1]="TW"
                                    chessfield_new[from+3]="LL"
                                }else if ((from-2==to) && (chessfield[from-1]=="LL") && (chessfield[from-2]=="LL") && (chessfield[from-3]=="LL") && (chessfield[from-4]=="TW") && !isFieldUnderAttack(field: from, attacker:"S") && !isFieldUnderAttack(field: to, attacker:"S")) && rochadeW == 0 {//nur erlauben, wenn der König noch nicht gesetzt wurde
                                    rochade=true
                                    chessfield_new[from-1]="TW"
                                    chessfield_new[from-4]="LL"
                                }
                            }
                        }else{
                            if (from<to){kmove = 8}else{kmove = -8}
                            //print ("valide vertikalBewegung \(kmove)")
                            
                        }

                        
                        if rochade==true || ((from+kmove==to) && ((chessfield[to]=="LL") || ((lastChar=="S") && chessfield[to] != "KS")) && !isFieldUnderAttack(field: to, attacker:"S")){
                            print("OK")
                            if (nextmovefigure.stringValue == "P")
                            {
                                update_field()
                                rochadeW += 1
                            }else
                            {
                                revert_update_field()
                            }
                        }else{
                            print("FEHLER")
                            revert_update_field()
                        }

                    }else{//keine valide diagonalBewegung
                        print("FEHLER: Dieser Zug ist nicht möglich")
                        revert_update_field()
                    }


                default:
                    print("Figur ist nicht bekannt")
                    revert_update_field()
                }
    }

    func computerMove(color:Character)
    {
        
        func checkMoveBauer(figure: Figure)->Figure
        {
            let from = figure.position
            //chessfield_new[0..63] contains the current chess field
            figure.possibleMoves.removeAll()
            if from+7 < 63 {
                if chessfield_new[from+7].last == "W" && ((from / 8) != ((from+7) / 8)) { //nach links schlagen...
                    figure.canmove += 1
//                    figure.possibleMoves.append(from+7)
                    figure.possibleMoves[from+7]=3 //target and value
                    switch chessfield_new[from+7] {
                        case "SW": figure.possibleMoves[from+7]! += 1
                        case "LW": figure.possibleMoves[from+7]! += 1
                        case "TW": figure.possibleMoves[from+7]! += 2
                        case "DW": figure.possibleMoves[from+7]! += 3
                        case "KW": figure.possibleMoves[from+7]! += 1
                        default:figure.possibleMoves[from+7]! = figure.possibleMoves[from+7]!
                    }
                    
                    chessfield_new[from+7]="BS"
                    chessfield_new[from]="LL"

                    if (isFieldUnderAttack(field: from+7, attacker: "S")) { //ist das Zielfeld abgesichert?
                        figure.possibleMoves[from+7]! += 1 //make move more valuable
                    }
                    revert_update_field()
                    figure.canattack += 1
                    figure.moveValue=3
                    //prüfe ob Damentausch möglich...
                    if (from+7) / 8 >= 8 {
                        figure.moveValue=10
                        figure.possibleMoves[from+7]=10 //target and value
                    }
                }
            }
            if from+9 < 63 {
                if chessfield_new[from+9].last == "W" && ((from / 8) + 1 == ((from+9) / 8)) { //nach rechts schlagen...
                    figure.canmove += 1
//                    figure.possibleMoves.append(from+9)
                    figure.possibleMoves[from+9]=3 //target and value
                    //24.01.21
                    switch chessfield_new[from+9] {
                        case "SW": figure.possibleMoves[from+9]! += 1
                        case "LW": figure.possibleMoves[from+9]! += 1
                        case "TW": figure.possibleMoves[from+9]! += 2
                        case "DW": figure.possibleMoves[from+9]! += 3
                        case "KW": figure.possibleMoves[from+9]! += 1
                        default:figure.possibleMoves[from+9]! = figure.possibleMoves[from+9]!
                    }

                    chessfield_new[from+9]="BS"
                    chessfield_new[from]="LL"

                    if (isFieldUnderAttack(field: from+9, attacker: "S")) { //ist das Zielfeld abgesichert?
                        figure.possibleMoves[from+9]! += 1 //make move more valuable
                    }
                    revert_update_field()

                    figure.canattack += 1
                    if 3>figure.moveValue { figure.moveValue=3 }
                    if (from+9) / 8 >= 8 {
                        figure.possibleMoves[from+9]=10 //target and value
                        if 10>figure.moveValue { figure.moveValue=10 }
                    }
                }
            }
            if (from>7 && from<16) { //2 Felder vor möglich?
                //print ("ACHTUNG: FROM 2 vorwärts = \(from)")
                if chessfield_new[from+8] == "LL" {
                    figure.canmove += 1
//                    figure.possibleMoves.append(from+16)
                    figure.possibleMoves[from+8]=1 //target and value
                    chessfield_new[from+8]="BS"
                    chessfield_new[from]="LL"

                    if (isFieldUnderAttack(field: from+8, attacker: "S")) { //ist das Zielfeld abgesichert?
                        figure.possibleMoves[from+8]! += 1 //make move more valuable
                    }
                    revert_update_field()
                    figure.moveValue = figure.possibleMoves[from+8]!
                    
                    if chessfield_new[from+16] == "LL" {
                        figure.canmove += 1
    //                    figure.possibleMoves.append(from+16)
                        figure.possibleMoves[from+16]=2 //target and value
                        chessfield_new[from+16]="BS"
                        chessfield_new[from]="LL"

                        if (isFieldUnderAttack(field: from+16, attacker: "S")) { //ist das Zielfeld abgesichert?
                            figure.possibleMoves[from+16]! += 1 //make move more valuable
                        }
                        revert_update_field()
                        if figure.possibleMoves[from+16]! > figure.moveValue {
                            figure.moveValue = figure.possibleMoves[from+16]!
                        }
//                        if 2>figure.moveValue { figure.moveValue=2 }
                    }
                }
            }
            return figure
        }
        
        func checkMoveSpringer(figure: Figure)->Figure
        {
            var movevalue = 0
            func checkMoveSpringerValue(x: Int, maxLines: Int, fieldmoves: Int, figure: Figure)
            {
                let from = figure.position
                

                //chessfield_new[0..63] contains the current chess field
                //figure.possibleMoves.removeAll()
                if (from % 8 > x) && from + fieldmoves < 64 { //1 Zeile hoch nach links
                    if chessfield_new[from+fieldmoves].last != "S" && (((from+fieldmoves) / 8) - (from / 8) == maxLines) { //nach links schlagen...
                        figure.canmove += 1
    //                    figure.possibleMoves.append(from+7)
                        figure.possibleMoves[from+fieldmoves]=1 //target and value
                        switch chessfield_new[from+fieldmoves] {
                            case "BW": figure.possibleMoves[from+fieldmoves]! += 1
                            case "SW": figure.possibleMoves[from+fieldmoves]! += 2
                            case "LW": figure.possibleMoves[from+fieldmoves]! += 2
                            case "TW": figure.possibleMoves[from+fieldmoves]! += 3
                            case "DW": figure.possibleMoves[from+fieldmoves]! += 4
                            case "KW": figure.possibleMoves[from+fieldmoves]! += 1
                            default:figure.possibleMoves[from+fieldmoves]! = figure.possibleMoves[from+fieldmoves]!
                        }
                        
                        chessfield_new[from+fieldmoves]="SS"
                        chessfield_new[from]="LL"

                        if (isFieldUnderAttack(field: from, attacker: "W")) { //ist das aktuelle Feld angegriffen?
                            figure.possibleMoves[from+fieldmoves]! += 3 //make move more valuable
                        }

                        if (isFieldUnderAttack(field: from+fieldmoves, attacker: "S")) { //ist das Zielfeld abgesichert?
                            figure.possibleMoves[from+fieldmoves]! += 1 //make move more valuable
                        }
                        if (isFieldUnderAttack(field: from+fieldmoves, attacker: "W")) { //ist das Zielfeld angegriffen?
                            figure.possibleMoves[from+fieldmoves]! -= 2 //make move more valuable
                        }
                        //erhöhe Wert des Zuges wenn Angriff oder Deckung möglich ist
                        if (from+fieldmoves + 15 < 64) && ((from+fieldmoves + 15) / 8 - (from+fieldmoves) / 8 == 2) {
                            if chessfield_new[from+fieldmoves+15].last != "L" {
                                figure.possibleMoves[from+fieldmoves]! += 1 //make move more valueable
                            }
                        }
                        //erhöhe Wert des Zuges wenn Angriff oder Deckung möglich ist
                        if (from+fieldmoves + 17 < 64) && ((from+fieldmoves + 17) / 8 - (from+fieldmoves) / 8 == 2) {
                            if chessfield_new[from+fieldmoves+17].last != "L" {
                                figure.possibleMoves[from+fieldmoves]! += 1 //make move more valueable
                            }
                        }
                        //erhöhe Wert des Zuges wenn Angriff oder Deckung möglich ist
                        if (from+fieldmoves + 6 < 64) && ((from+fieldmoves + 6) / 8 - (from+fieldmoves) / 8 == 1) {
                            if chessfield_new[from+fieldmoves+6].last != "L" {
                                figure.possibleMoves[from+fieldmoves]! += 1 //make move more valueable
                            }
                        }
                        if (from+fieldmoves + 10 < 64) && ((from+fieldmoves + 10) / 8 - (from+fieldmoves) / 8 == 1) {
                            if chessfield_new[from+fieldmoves+10].last != "L" {
                                figure.possibleMoves[from+fieldmoves]! += 1 //make move more valueable
                            }
                        }
                        if (from+fieldmoves - 10 > 0) && ((from+fieldmoves) / 8 - (from+fieldmoves - 10) / 8 == 1) {
                            if chessfield_new[from+fieldmoves-10].last != "L" {
                                figure.possibleMoves[from+fieldmoves]! += 1 //make move more valueable
                            }
                        }
                        if (from+fieldmoves - 6 > 0) && ((from+fieldmoves) / 8 - (from+fieldmoves - 6) / 8 == 1) {
                            if chessfield_new[from+fieldmoves-6].last != "L" {
                                figure.possibleMoves[from+fieldmoves]! += 1 //make move more valueable
                            }
                        }
                        if (from+fieldmoves - 17 > 0) && ((from+fieldmoves) / 8 - (from+fieldmoves - 17) / 8 == 2) {
                            if chessfield_new[from+fieldmoves-17].last != "L" {
                                figure.possibleMoves[from+fieldmoves]! += 1 //make move more valueable
                            }
                        }
                        if (from+fieldmoves - 15 > 0) && ((from+fieldmoves) / 8 - (from+fieldmoves - 15) / 8 == 2) {
                            if chessfield_new[from+fieldmoves-15].last != "L" {
                                figure.possibleMoves[from+fieldmoves]! += 1 //make move more valueable
                            }
                        }

                        
                        
                        revert_update_field()
                        figure.canattack += 1
                        figure.moveValue = figure.possibleMoves[from+fieldmoves]!
                    }
                }

                return
            }
            figure.possibleMoves.removeAll()
            checkMoveSpringerValue(x:1, maxLines:1, fieldmoves:6, figure:figure)
            if figure.moveValue > movevalue {
                movevalue = figure.moveValue
            }
            checkMoveSpringerValue(x:6, maxLines:1, fieldmoves:10, figure:figure)
            if figure.moveValue > movevalue {
                movevalue = figure.moveValue
            }
            checkMoveSpringerValue(x:0, maxLines:2, fieldmoves:15, figure:figure)
            if figure.moveValue > movevalue {
                movevalue = figure.moveValue
            }
            checkMoveSpringerValue(x:-1, maxLines:2, fieldmoves:17, figure:figure)
            if figure.moveValue > movevalue {
                movevalue = figure.moveValue
            }
            figure.moveValue = movevalue
            //---------------------
            return figure
        }
//------------------------------------------------
        
        var checkfigures = [Figure]()
        let date = Date()
        var owncolor:Character
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)

        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let today_string = String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        print ("\(color) starts thinking at \(today_string)")

        var which_figure: Int
        var tmpfigure: Figure

        if (color) == "W" {owncolor = "S"} else {owncolor = "W"}
        
        if (allfigures.count>0){
            for i in 0...allfigures.count-1 {//create a list of available figures of the correct color to move...
                if allfigures[i].name.last == color && allfigures[i].name.first == "B" { //color check if under under attack // consider only "Bauer" as 1st step ->later to be removed
                    tmpfigure = checkMoveBauer(figure: allfigures[i])
                    
                    if tmpfigure.canmove > 0 {// add only moveable figures
                        checkfigures.append(tmpfigure) //append to checkfigures array
//                        print ("Mögliche Züge mit Bewertung: \(tmpfigure.position) -> \(tmpfigure.possibleMoves)")
                    }
                }
                if allfigures[i].name.last == color && allfigures[i].name.first == "S" { //color check if under under attack // consider only "Bauer" as 1st step ->later to be removed
                    tmpfigure = checkMoveSpringer(figure: allfigures[i])
                    
                    if tmpfigure.canmove > 0 {// add only moveable figures
                        checkfigures.append(tmpfigure) //append to checkfigures array
//                        print ("Mögliche Züge mit Bewertung: \(tmpfigure.position) -> \(tmpfigure.possibleMoves)")
                    }
                }
            }
            
            var tmpValue = 0
//            var tmpMove = [Int]()
            var tmpfigures = [Figure]()
            var finalfigures = [Figure]()

            which_figure = Int.random(in: 0...checkfigures.count-1) //select randomly a figure to move if there is no better logic...
            //print ("move \(checkfigures[which_figure].name) at position \(checkfigures[which_figure].position)")

            for i in 0...checkfigures.count-1 { // check if one of the listed figures is under attack
                print ("figuren zur Auswahl: \(checkfigures[i].name) & \(checkfigures[i].moveValue)")

                //print ("check if \(allfigures[i].name) is under attack on \(allfigures[i].position)")
                if checkfigures[i].moveValue >= tmpValue { // bei mehreren gleich guten Zügen wähle zufällig
                    if checkfigures[i].moveValue > tmpValue { // bei mehreren gleich guten
                        tmpfigures.removeAll()
                        tmpValue = checkfigures[i].moveValue
                    }
                    tmpfigures.append(checkfigures[i])
                }
                if (isFieldUnderAttack(field: checkfigures[i].position, attacker: owncolor))
                {
                    //print ("\(checkfigures[i].name) is under attack at  \(checkfigures[i].position)")
                    checkfigures[i].underattack=1 //mark figure as under attack...
                }
            }
            
            tmpValue=0 // finde die höchsten Bewertungen
            for i in 0...tmpfigures.count-1 { //lasse nur die hoch bewerteten Züge übrig...
                for (key,value) in tmpfigures[i].possibleMoves {
                    if value > tmpValue {
                        tmpValue = value
                    }
                }
            }
            
            finalfigures.removeAll()
            
            for i in 0...tmpfigures.count-1 { //und lösche alle niedrig bewerteten Züge...
                for (key,value) in tmpfigures[i].possibleMoves {
                    if value < tmpValue {
                        tmpfigures[i].possibleMoves.removeValue(forKey: key)
                    }
                }
                if !(tmpfigures[i].possibleMoves.isEmpty) {
                        finalfigures.append(tmpfigures[i])
                }
            }

            for i in 0...finalfigures.count-1 { //zeige die übriggebliebenen Züge...
                for (key,value) in finalfigures[i].possibleMoves {
                    print("\(finalfigures[i].position)->\(key) : \(value)")
                }
            }

            which_figure = Int.random(in: 0...finalfigures.count-1) //select randomly a
            //print ("tmpMove.count: \tmpMove.count)  - figure: \(which_figure)")
            
            print ("\(finalfigures[which_figure].name) & \(finalfigures[which_figure].position) & \(Array(finalfigures[which_figure].possibleMoves.keys)[0])")
            
            var fieldChanged=""
            for j in 0...63 {//aktualisere Schachbrett...
                if (j == finalfigures[which_figure].position) {//setze die ausgewählte figur ->leere Ursprungsfeld
                    fieldChanged += "LL"
//                    chessfield_new[j] = "LL" // ACHTUNG
                } else {
                    if (j == (Array(finalfigures[which_figure].possibleMoves.keys)[0])) {
                        if finalfigures[which_figure].name == "BS" && j / 8 >= 8
                        {//prüfe, ob Damentausch...
                            fieldChanged += "DS"
//                            chessfield_new[j] = "DS" // ACHTUNG
                            print ("ACHTUNG: DAMENTAUSCH")
                        } else {
                            fieldChanged += finalfigures[which_figure].name
//                            chessfield_new[j] = checkfigures[which_figure].name // ACHTUNG

                        }
                    } else {
                        fieldChanged += chessfield[j]
//                        chessfield_new[j] = chessfield [j]
                    }
                }
            }
//-------------------
/*
            var tmp=""
            var counter=0
            //print ("new move")//chess input changed\n\(chessinput_new)")
            for character in fieldChanged {
                tmp=tmp+String(character)
                if tmp.count==2{
                    chessfield_new[counter]=tmp
                    counter+=1
                    tmp=""
                }
            }
 */
//            update_field()
            newMove(chessinput_new: fieldChanged)
        }
    }
    
    @IBOutlet weak var F0: NSButton!
    @IBAction func F0(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
                secondclick=0

                print("firstclick: \(firstclick)")
                print("secondclick: \(secondclick)")
                print(firstchar)
                var fieldChanged=""
                for i in 0...63 {
                    if (i == secondclick) {
                        fieldChanged += firstchar
                    }else if (i == firstclick){
                        fieldChanged += "LL"
                    }else
                    {
                        fieldChanged += chessfield_new[i]
                    }
                }
                firstclick=100
                firstchar=""
                
                newMove(chessinput_new: fieldChanged)
                if (BlackcomputerPlayer == true) { computerMove(color: "S") }
            }else
            {
                firstclick=0
                firstchar = chessfield_new[firstclick]
            }
        }
    }
    @IBOutlet weak var F1: NSButton!
    @IBAction func F1(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=1

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=1
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F2: NSButton!
    @IBAction func F2(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=2

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=2
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F3: NSButton!
    @IBAction func F3(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=3

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=3
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F4: NSButton!
    @IBAction func F4(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=4

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=4
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F5: NSButton!
    @IBAction func F5(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=5

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=5
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F6: NSButton!
    @IBAction func F6(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=6

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=6
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F7: NSButton!
    @IBAction func F7(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=7

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=7
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F8: NSButton!
    @IBAction func F8(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=8

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=8
            firstchar = chessfield_new[firstclick]
        }
    }
    }
    @IBOutlet weak var F9: NSButton!
    @IBAction func F9(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=9

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=9
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F10: NSButton!
    @IBAction func F10(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=10

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=10
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    
    @IBOutlet weak var F11: NSButton!
    @IBAction func F11(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=11

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=11
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F12: NSButton!
    @IBAction func F12(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=12

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=12
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F13: NSButton!
    @IBAction func F13(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=13

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=13
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F14: NSButton!
    @IBAction func F14(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=14

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=14
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F15: NSButton!
    @IBAction func F15(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=15

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=15
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F16: NSButton!
    @IBAction func F16(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=16
            print("firstclick: \(firstclick)")
            print("secondclick: \(secondclick)")
            print("firstchar: \(firstchar)")

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            print ("fieldChanged: \(fieldChanged)")
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=16
            firstchar = chessfield_new[firstclick]
        }
    }
    }
    @IBOutlet weak var F17: NSButton!
    @IBAction func F17(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=17

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=17
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F18: NSButton!
    @IBAction func F18(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=18

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=18
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F19: NSButton!
    @IBAction func F19(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=19

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=19
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F20: NSButton!
    @IBAction func F20(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=20

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=20
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F21: NSButton!
    @IBAction func F21(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=21

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=21
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F22: NSButton!
    @IBAction func F22(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=22

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=22
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F23: NSButton!
    @IBAction func F23(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=23

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=23
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F24: NSButton!
    @IBAction func F24(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=24

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=24
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F25: NSButton!
    @IBAction func F25(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=25

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=25
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F26: NSButton!
    @IBAction func F26(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {

        if (firstclick != 100){
            secondclick=26

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=26
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F27: NSButton!
    @IBAction func F27(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=27

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=27
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F28: NSButton!
    @IBAction func F28(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=28

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=28
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F29: NSButton!
    @IBAction func F29(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=29

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=29
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F30: NSButton!
    @IBAction func F30(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=30

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=30
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F31: NSButton!
    @IBAction func F31(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=31

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=31
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F32: NSButton!
    @IBAction func F32(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=32

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=32
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F33: NSButton!
    @IBAction func F33(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=33

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=33
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F34: NSButton!
    @IBAction func F34(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=34

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=34
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F35: NSButton!
    @IBAction func F35(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=35

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=35
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F36: NSButton!
    @IBAction func F36(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=36

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=36
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F37: NSButton!
    @IBAction func F37(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=37

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=37
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F38: NSButton!
    @IBAction func F38(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=38

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=38
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F39: NSButton!
    @IBAction func F39(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=39

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=39
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F40: NSButton!
    @IBAction func F40(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=40

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=40
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F41: NSButton!
    @IBAction func F41(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=41

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=41
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F42: NSButton!
    @IBAction func F42(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=42

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=42
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F43: NSButton!
    @IBAction func F43(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=43

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=43
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F44: NSButton!
    @IBAction func F44(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=44

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=44
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F45: NSButton!
    @IBAction func F45(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=45

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=45
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F46: NSButton!
    @IBAction func F46(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=46

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=46
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F47: NSButton!
    @IBAction func F47(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=47

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=47
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F48: NSButton!
    @IBAction func F48(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=48

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=48
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F49: NSButton!
    @IBAction func F49(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=49

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=49
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F50: NSButton!
    @IBAction func F50(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=50

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=50
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F51: NSButton!
    @IBAction func F51(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=51

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            print ("field changed! \(fieldChanged)")
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=51
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F52: NSButton!
    @IBAction func F52(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=52

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=52
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F53: NSButton!
    @IBAction func F53(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=53

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=53
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F54: NSButton!
    @IBAction func F54(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=54

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=54
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F55: NSButton!
    @IBAction func F55(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=55

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=55
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F56: NSButton!
    @IBAction func F56(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=56

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=56
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F57: NSButton!
    @IBAction func F57(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=57

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=57
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F58: NSButton!
    @IBAction func F58(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=58

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=58
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F59: NSButton!
    @IBAction func F59(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=59

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=59
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F60: NSButton!
    @IBAction func F60(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=60

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=60
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F61: NSButton!
    @IBAction func F61(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=61

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=61
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F62: NSButton!
    @IBAction func F62(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=62

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
        }else
        {
            firstclick=62
            firstchar = chessfield_new[firstclick]
        }
        }
    }
    @IBOutlet weak var F63: NSButton!
    @IBAction func F63(_ sender: NSButton) {
        if (move%2 == 1 && BlackcomputerPlayer == true) { computerMove(color: "S")} else
        {
            if (firstclick != 100){
            secondclick=63

            var fieldChanged=""
            for i in 0...63 {
                if (i == secondclick) {
                    fieldChanged += firstchar
                }else if (i == firstclick){
                    fieldChanged += "LL"
                }else
                {
                    fieldChanged += chessfield_new[i]
                }
            }
            firstclick=100
            firstchar=""
            
            newMove(chessinput_new: fieldChanged)
            if (BlackcomputerPlayer == true) { computerMove(color: "S") }
            }else
            {
            firstclick=63
            firstchar = chessfield_new[firstclick]
            }
        }
    }
    
    @IBOutlet weak var Revers: NSButton!
    @IBAction func Revers(_ sender: NSButton) {
        if move >= 2 {
            move -= 2
            currentMove.stringValue = String(move)
            //print (ChessFieldforEachMove)
            chessfield_new = ChessFieldforEachMove[move]
            ChessFieldforEachMove.removeLast()
            ChessFieldforEachMove.removeLast()
            update_field()
            BlackcomputerPlayer = false
            computerPlayer.stringValue = "0"
        }
    }
    
    @IBOutlet weak var currentMove: NSTextField!
    
    
    @IBOutlet weak var nextmovefigure: NSTextField!
    
    @IBOutlet weak var help: NSTextField!
    
    @IBOutlet weak var computerPlayer: NSButton!
    
    @IBAction func computerPlayer(_ sender: NSButton) {
        if (computerPlayer.stringValue == "1") {
            BlackcomputerPlayer = true
            computerMove(color: "S")
        } else { BlackcomputerPlayer = false }
    }
    
    override func viewDidLoad() {
//definition must be in the same function...


        super.viewDidLoad()
        print ("Start the game")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "Chess"
    }
    
}

