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
    print("\u{001B}[1;94m-k     współczynnik      {0.5}{2}")
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

//Ton prosty
var ax: [Float] = []
var Tones: [Float] = [] //sygnał nośny
var Information: [Float] = [] //sygnał informacyjny
var pm: [Float] = [] //PM

for i in Times {
    if (A.count) > 1 && (Ω.count) > 1 && (Φ.count) > 1 && o == "+" {
        Tones.append((A[0] * sin(Ω[0] * i + Φ[0])) + (A[1] * sin(Ω[1] * i + Φ[1])))
    }
    else if (A.count) > 1 && (Ω.count) > 1 && (Φ.count) > 1 && o == "-" {
        Tones.append((A[0] * sin(Ω[0] * i + Φ[0])) - (A[1] * sin(Ω[1] * i + Φ[1])))
    }
    else if (A.count) > 1 && (Ω.count) > 1 && (Φ.count) > 1 && o == "*" {
        Tones.append((A[0] * sin(Ω[0] * i + Φ[0])) * (A[1] * sin(Ω[1] * i + Φ[1])))
    }
    else {
        Tones.append(A[0] * sin(Ω[0] * i + Φ[0]))
    }
    Information.append(sin(2*Float.pi*i*5) + sin(2*Float.pi*i*5*2))
    pm.append(2*Float.pi*i*F[0])
    //( 2 * PI * częstotliwość + współczynnik.g.m * sygnał informacyjny)
    ax.append(Float(i))
}

var Modulated: [Float] = [] //AM
var Modulated2: [Float] = [] //PM
for i in 0..<(Times.count) {
    Modulated.append(Tones[i]*(k!*Information[i]+1))
    Modulated2.append(A[0]*sin(pm[i]+k!*Information[i]))
    //amplituda * sin ( 2 * PI * częstotliwość + współczynnik.g.m * sygnał informacyjny)
}

var xk: [Float] = []
var xk2: [Float] = []
var real: Float? = 0
var imag: Float? = 0

//DFT AM
for i in 1...(Times.count) {

    real = 0
    imag = 0

    for n in 0..<(Times.count) {
        real = Float(real!) + Modulated[n] * cos(2*Float.pi * Float(n) * Float(i) / Float(Times.count))
        imag = Float(imag!) - Modulated[n] * sin(2*Float.pi * Float(n) * Float(i) / Float(Times.count))
    }

    xk.append(sqrt((Float(real!) ** 2) + ((Float(imag!) ** 2)))*2/Float(Times.count))
}

//DFT PM
for i in 1...(Times.count) {

    real = 0
    imag = 0

    for n in 0..<(Times.count) {
        real = Float(real!) + Modulated2[n] * cos(2*Float.pi * Float(n) * Float(i) / Float(Times.count))
        imag = Float(imag!) - Modulated2[n] * sin(2*Float.pi * Float(n) * Float(i) / Float(Times.count))
    }

    xk2.append(sqrt((Float(real!) ** 2) + ((Float(imag!) ** 2)))*2/Float(Times.count))
}

//CSV
let DocumentDirURL: String! = "/Users/niquit/WIZUT/PTD/lab3/"

//Ton prosty ( sygnał nośny )
var fileName = "lab3.1"
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
fileName = "lab3.2"
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

//Sygnał informacyjny
fileName = "lab3.3"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(Information[index-1])"
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

//AM
fileName = "lab3.4"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(Modulated[index-1])"
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

//Widmo amplitudowe AM
fileName = "lab3.5"
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
fileName = "lab3.6"
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

//PM
fileName = "lab3.7"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(Modulated2[index-1])"
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

//Widmo amplitudowe PM
fileName = "lab3.8"
fileURL = URL(fileURLWithPath: DocumentDirURL).appendingPathComponent(fileName).appendingPathExtension("csv")
fileText = ""

for index in 1...(Times.count) {
    fileText+="\(xk2[index-1])"
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