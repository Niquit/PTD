//
//  main.swift
//  test-swift
//
//  Created by niquit on 07/10/2017.
//  Copyright © 2017 niquit. All rights reserved.
//

import Foundation

var A: [Float] = []
var a: String? = nil
var Ω: [Float] = []
var ω: String? = nil
var Φ: [Float] = []
var φ: String? = nil
var f: String? = nil
var o: String! = "+"
var P: String? = nil
var p: Double! = 500

func Help() {
    print("\u{001B}[1;97mUSAGE: Sample Tone by niquit, version X")
    print("\u{001B}[1;94m-a     amplituda         {2}{2,3}")
    print("\u{001B}[1;94m-w     omega             {2}{2,3}")
    print("\u{001B}[1;94m-f     częstotliwość     {20}{20,30}")
    print("\u{001B}[1;94m-F     przesunięcie      {2}{2,3}")
    print("\u{001B}[1;94m-o     operacja          {+}{-}{*}")
    print("\u{001B}[1;94m-p     próbkowanie       {100}{500}")
}

while case let option = getopt(CommandLine.argc, CommandLine.unsafeArgv, "a:w:F:f:o:p:h"), option != -1 {
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
p = 1/p
for i in stride(from: 0.00, to: 1.00, by: p) {
    Times.append(Float(i))
}

//Ton prosty
var ax: [Float] = []
var Tones:[Float] = []
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

    ax.append(Float(i))
}

//CSV
let DocumentDirURL: String! = "/Users/niquit/WIZUT/PTD/lab1/"

//Ton prosty
var fileName = "lab1.1"
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
fileName = "lab1.2"
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