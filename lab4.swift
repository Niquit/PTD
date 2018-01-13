#!/usr/bin/swift
//
//  main.swift
//  test-swift
//
//  Created by niquit on 07/10/2017.
//  Copyright © 2017 niquit. All rights reserved.
//

import Foundation

precedencegroup ExponentiationPrecedence {
  associativity: right
  higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence

func ** (_ base: Double, _ exp: Double) -> Double {
  return pow(base, exp)
}

func ** (_ base: Float, _ exp: Float) -> Float {
  return pow(base, exp)
}

var A: [Float] = []
var a: String? = nil
var Ω: [Float] = []
var F: [Float] = []
var ω: String? = nil
var Φ: [Float] = []
var φ: String? = nil
var f: String? = nil
var o: String! = "+"
var P: String? = nil
var p: Double! = 1
var K: String? = nil
var k: Float? = 0.5

func Help() {
    print("\u{001B}[1;97mUSAGE: Sample Tone by niquit, version X")
    print("\u{001B}[1;94m-a     amplituda         {2}{2,3}")
    print("\u{001B}[1;94m-w     omega             {2}{2,3}")
    print("\u{001B}[1;94m-f     częstotliwość     {20}{20,30}")
    print("\u{001B}[1;94m-F     przesunięcie      {2}{2,3}")
    print("\u{001B}[1;94m-o     operacja          {+}{-}{*}")
    print("\u{001B}[1;94m-p     okres             {1}{5}")
}

while case let option = getopt(CommandLine.argc, CommandLine.unsafeArgv, "a:w:F:f:o:p:k:h"), option != -1 {
    switch UnicodeScalar(CUnsignedChar(option)) {
    case "a":
        a = String(cString: optarg)
    case "w":
        ω = String(cString: optarg)
    case "F":
        φ = String(cString: optarg)
    case "f":
        f = String(cString: optarg)
    case "o":
        o = String(cString: optarg)
    case "p":
        P = String(cString: optarg)
        p = Double(P!)
    case "k":
        K = String(cString: optarg)
        k = Float(K!)
    case "h":
        Help()

        exit(0)
    default:
        Help()

        exit(1)
    }
}

if ((a ?? "").isEmpty) || (((ω ?? "").isEmpty) && ((f ?? "").isEmpty)) || ((φ ?? "").isEmpty) {
    Help()

    exit(1)
}

//Amplituda
for i in a!.components(separatedBy:",") {
    A.append(Float(i)!)
}

//Częstotliwość
if (ω ?? "").isEmpty {
    for i in f!.components(separatedBy:",") {
        Ω.append(2*Float.pi*Float(i)!)
        F.append(Float(i)!)
    }
}
else {
    for i in ω!.components(separatedBy:",") {
        Ω.append(Float(i)!)
    }
}

//Przesunięcie
for i in φ!.components(separatedBy:",") {
    Φ.append(Float(i)!)
}

//Okres ( próbkowanie )
var Times:[Float] = []

for i in stride(from: 0.00, to: p, by: 1/1000) {
    Times.append(Float(i))
}

//var amount: Int = (Int((arc4random() % 7)+3))
var amount: Int = 10
var Amount: [Int] = []

for _ in 0..<amount {
    Amount.append(Int((arc4random() % 2)))
}

var random: [Float] = [] //Random

var step: Float = 1.0 / Float(Amount.count)
var start: Float = 0.0;

for i in Amount {
    for _ in stride(from: start, to: start+step, by: 1/1000/Float(p)) {
        if (random.count > Int(1000*p-1)) {
            break
        }

        random.append(Float(i))
    }

    start += step
}

//Ton prosty
var ax: [Float] = []
var Tones: [Float] = [] //sygnał nośny
var ASK: [Float] = [] //ASK
var FSK: [Float] = [] //FSK
var PSK: [Float] = [] //PSK
for i in 0..<(Times.count) {
    if (random[i] == 1) {
        if (A.count) > 1 && (Ω.count) > 1 && (Φ.count) > 1 && o == "+" {
            Tones.append((A[0] * sin(Ω[0] * Times[i] + Φ[0])) + (A[1] * sin(Ω[1] * Times[i] + Φ[1])))

            FSK.append((A[0] * sin(2 * Float.pi * (F[0] * 100 + 1) / 0.1 * Times[i])) + (A[1] * sin(2 * Float.pi * (F[1] * 100 + 2) / 0.1 * Times[i])))
            PSK.append((A[0] * sin(Ω[0] * Times[i])) + (A[1] * sin(Ω[1] * Times[i] + Float.pi)))
        }
        else if (A.count) > 1 && (Ω.count) > 1 && (Φ.count) > 1 && o == "-" {
            Tones.append((A[0] * sin(Ω[0] * Times[i] + Φ[0])) - (A[1] * sin(Ω[1] * Times[i] + Φ[1])))

            FSK.append((A[0] * sin(2 * Float.pi * (F[0] * 100 + 1) / 0.1 - Times[i])) + (A[1] * sin(2 * Float.pi * (F[1] * 100 + 2) / 0.1 * Times[i])))
            PSK.append((A[0] * sin(Ω[0] * Times[i])) - (A[1] * sin(Ω[1] * Times[i] + Float.pi)))
        }
        else if (A.count) > 1 && (Ω.count) > 1 && (Φ.count) > 1 && o == "*" {
            Tones.append((A[0] * sin(Ω[0] * Times[i] + Φ[0])) * (A[1] * sin(Ω[1] * Times[i] + Φ[1])))

            FSK.append((A[0] * sin(2 * Float.pi * (F[0] * 100 + 1) / 0.1 * Times[i])) * (A[1] * sin(2 * Float.pi * (F[1] * 100 + 2) / 0.1 * Times[i])))
            PSK.append((A[0] * sin(Ω[0] * Times[i])) * (A[1] * sin(Ω[1] * Times[i] + Float.pi)))
        }
        else {
            Tones.append(A[0] * sin(Ω[0] * Times[i] + Φ[0]))
            FSK.append(A[0] * sin(2 * Float.pi * (F[0] * 100 + 1) / 0.1 * Times[i]))
            PSK.append(A[0] * sin(Ω[0] * Times[i] + Float.pi))
        }

        ASK.append(Tones[i])
    }
    else {
        if (A.count) > 1 && (Ω.count) > 1 && (Φ.count) > 1 && o == "+" {
            Tones.append((A[0] * sin(Ω[0] * Times[i] + Φ[0])) + (A[1] * sin(Ω[1] * Times[i] + Φ[1])))

            FSK.append((A[0] * sin(2 * Float.pi * (F[0] * 100 + 2) / 0.1 * Times[i])) + (A[1] * sin(2 * Float.pi * (F[1] * 100 + 2) / 0.1 * Times[i])))
            PSK.append((A[0] * sin(Ω[0] * Times[i])) + (A[1] * sin(Ω[1] * Times[i])))
        }
        else if (A.count) > 1 && (Ω.count) > 1 && (Φ.count) > 1 && o == "-" {
            Tones.append((A[0] * sin(Ω[0] * Times[i] + Φ[0])) - (A[1] * sin(Ω[1] * Times[i] + Φ[1])))

            FSK.append((A[0] * sin(2 * Float.pi * (F[0] * 100 + 2) / 0.1 * Times[i])) - (A[1] * sin(2 * Float.pi * (F[1] * 100 + 2) / 0.1 * Times[i])))
            PSK.append((A[0] * sin(Ω[0] * Times[i])) - (A[1] * sin(Ω[1] * Times[i])))
        }
        else if (A.count) > 1 && (Ω.count) > 1 && (Φ.count) > 1 && o == "*" {
            Tones.append((A[0] * sin(Ω[0] * Times[i] + Φ[0])) * (A[1] * sin(Ω[1] * Times[i] + Φ[1])))

            FSK.append((A[0] * sin(2 * Float.pi * (F[0] * 100 + 2) / 0.1 * Times[i])) * (A[1] * sin(2 * Float.pi * (F[1] * 100 + 2) / 0.1 * Times[i])))
            PSK.append((A[0] * sin(Ω[0] * Times[i])) * (A[1] * sin(Ω[1] * Times[i])))
        }
        else {
            Tones.append(A[0] * sin(Ω[0] * Times[i] + Φ[0]))

            FSK.append(A[0] * sin(2 * Float.pi * (F[0] * 100 + 2) / 0.1 * Times[i]))
            PSK.append(A[0] * sin(Ω[0] * Times[i]))
        }

        ASK.append(0)
    }

    ax.append(Float(Times[i]))
}
/*var ASK: [Float] = [] //ASK
for i in 0..<(Times.count) {
    if (random[i] == 0) {
        ASK.append(0)
    }
    else {
        ASK.append(Tones[i])
    }
}

var FSK: [Float] = [] //FSK
for i in 0..<(Times.count) {
    if (random[i] == 0) {
        FSK.append(A[0] * sin(2 * Float.pi * (F[0] * 100 + 2) / 0.1 * Times[i]))
        //FSK.append(sin(2 * Float.pi * ((Float(amount) + 2) / 1.0 / Float(Amount.count)) * Float(i)))
    }
    else {
        FSK.append(A[0] * sin(2 * Float.pi * (F[0] * 100 + 1) / 0.1 * Times[i]))
        //FSK.append(sin(2 * Float.pi * ((Float(amount) + 1) / 1.0 / Float(Amount.count)) * Float(i)))
    }
}

var PSK: [Float] = [] //PSK
for i in 0..<(Times.count) {
    if (random[i] == 0) {
        PSK.append(A[0] * sin(Ω[0] * Times[i]))
        //PSK.append(sin(2 * Float.pi * Ω[0] * Float(i)))
    }
    else {
        PSK.append(A[0] * sin(Ω[0] * Times[i] + Float.pi))
        //PSK.append(sin(2 * Float.pi * Ω[0] * Float(i) + Float.pi))
    }
}*/

var xk: [Float] = []
var real: Float? = 0
var imag: Float? = 0

//DFT ASK
for i in 1...(Times.count) {

    real = 0
    imag = 0

    for n in 0..<(Times.count) {
        real = Float(real!) + ASK[n] * cos(2*Float.pi * Float(n) * Float(i) / Float(Times.count))
        imag = Float(imag!) - ASK[n] * sin(2*Float.pi * Float(n) * Float(i) / Float(Times.count))
    }

    xk.append(sqrt((Float(real!) ** 2) + ((Float(imag!) ** 2)))*2/Float(Times.count))
}

var xf: [Float] = []

//DFT FSK
for i in 1...(Times.count) {

    real = 0
    imag = 0

    for n in 0..<(Times.count) {
        real = Float(real!) + FSK[n] * cos(2*Float.pi * Float(n) * Float(i) / Float(Times.count))
        imag = Float(imag!) - FSK[n] * sin(2*Float.pi * Float(n) * Float(i) / Float(Times.count))
    }

    xf.append(sqrt((Float(real!) ** 2) + ((Float(imag!) ** 2)))*2/Float(Times.count))
}

var xp: [Float] = []

//DFT PSK
for i in 1...(Times.count) {

    real = 0
    imag = 0

    for n in 0..<(Times.count) {
        real = Float(real!) + PSK[n] * cos(2*Float.pi * Float(n) * Float(i) / Float(Times.count))
        imag = Float(imag!) - PSK[n] * sin(2*Float.pi * Float(n) * Float(i) / Float(Times.count))
    }

    xp.append(sqrt((Float(real!) ** 2) + ((Float(imag!) ** 2)))*2/Float(Times.count))
}

//Demodulacja ASK
var DASK: [Float] = []

for i in ASK {
    if (i == 0) {
        DASK.append(0)
    }
    else {
        DASK.append(1)
    }
}

//Demodulacja PSK
var DPSK: [Float] = []

for i in DPSK {
    if (i == 0) {
        DPSK.append(0)
    }
    else {
        DPSK.append(1)
    }
}

//CSV
let DocumentDirURL: String! = "/Users/niquit/WIZUT/PTD/lab4/"

//Ton prosty ( sygnał nośny )
var fileName = "lab4.1"
var fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
var fileText: String = ""

for index in 1...(Times.count) {
    fileText+="\(Tones[index-1])"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}
        
var writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}

//OŚ X
fileName = "lab4.2"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(ax[index-1])"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}
        
writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}

//Random
fileName = "lab4.3"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(random[index-1])"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}
        
writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}

//ASK
fileName = "lab4.4"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(ASK[index-1])"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}

writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}

//Widmo amplitudowe ASK
fileName = "lab4.5"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(xk[index-1])"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}
        
writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}


//OŚ X
fileName = "lab4.6"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(index)"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}
        
writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}

//FSK
fileName = "lab4.7"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(FSK[index-1])"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}

writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}

//Widmo amplitudowe FSK
fileName = "lab4.8"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(xf[index-1])"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}
        
writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}

//PSK
fileName = "lab4.9"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(PSK[index-1])"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}

writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}

//Widmo amplitudowe PSK
fileName = "lab4.10"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(xp[index-1])"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}
        
writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}

//Demodulacja ASK
fileName = "lab4.11"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(DASK[index-1])"
        if (( index < (Times.count) )) {
            fileText+=","
        }
}
        
writeString = fileText
do {
    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} 
catch let error as NSError {
    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription) 
}