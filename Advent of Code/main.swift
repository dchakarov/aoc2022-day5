//
//  main.swift
//  No rights reserved.
//

import Foundation
import RegexHelper

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
    
    var crateLines = [String]()
    var instructions = [String]()
    var parsingCrates = true
    var crateCount = 0
    
    for line in lines {
        if parsingCrates {
            if line.isEmpty {
                parsingCrates = false
                continue
            }
            if line.hasPrefix(" 1") {
                crateCount = Int(Array(line).map(String.init).last!)!
                continue
            }
            crateLines.append(line)
        } else {
            if !line.isEmpty {
                instructions.append(line)
            }
        }
    }
    
    var crates = [Int: [Character]]()
    
    for line in crateLines {
        let lineArr = Array(line)
        for i in 1...crateCount {
            let index = (i - 1) * 4 + 1
            if index < lineArr.count {
                let char = lineArr[index]
                if char != " " {
                    if crates[i] == nil {
                        crates[i] = [char]
                    } else {
                        crates[i]!.append(char)
                    }
                }
            }
        }
    }
                    
    print(crates)
//    print(instructions)

    for instruction in instructions {
        let parsedInstructions = parseLine(instruction)
        print(parsedInstructions.from, crates[parsedInstructions.from]!)
        print(parsedInstructions.to, crates[parsedInstructions.to]!)
        print("executing: ", parsedInstructions)
        for _ in 0..<parsedInstructions.count {
            let crate = crates[parsedInstructions.from]!.removeFirst()
            crates[parsedInstructions.to]!.insert(crate, at: 0)
        }
    }
    
    print(crates)

    var result = [Character]()
    for i in 1...crateCount {
        if !crates[i]!.isEmpty {
            result.append(crates[i]!.first!)
        }
    }
    print(String(result))
}

func parseLine(_ line: String) -> (count: Int, from: Int, to: Int) {
    let helper = RegexHelper(pattern: #"\D*(\d+)\D*(\d+)\D*(\d+)"#)
    let result = helper.parse(line)
    return (count: Int(result[0])!, from: Int(result[1])!, to: Int(result[2])!)
}

main()
