//
//  ContentView.swift
//  HighRollers
//
//  Created by Damien Chailloleau on 05/08/2024.
//

import Combine
import SwiftUI

struct ContentView: View {
    
    @State private var result: Int = 0
    @State private var resultArray = [Int]()
    
    @State private var currentResult = DiceResult(type: 0, numbers: 0)
    
    @State private var intermiateResult: Int = 0
    @State private var timerCancellables = Set<AnyCancellable>()
    
    @AppStorage("selectedDiceType") var selectedDiceType: Int = 4
    @AppStorage("selectedDiceNumbers") var selectedDiceNumbers: Int = 1
    
    let diceTypes: [Int] = [4, 6, 8, 10, 12, 20, 100]
    
//    var testDice: DiceResult
    
    var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Type of Dice", selection: $selectedDiceType) {
                        ForEach(diceTypes, id: \.self) { num in
                            Text("D\(num)")
                        }
                    }
                    
                    Picker("Numbers of Dice", selection: $selectedDiceNumbers) {
                        ForEach(1 ..< 21, id: \.self) { num in
                            Text("\(num)")
                        }
                    }
                }
                
                Section {
                    Button("Roll Dice") {
                        rollDice(type: selectedDiceType, number: selectedDiceNumbers)
                    }
                }
                
                Text("Result: \(result)")
                
                List {
                    ForEach(0 ..< resultArray.count, id: \.self) { item in
                        switch item + 1 {
                        case 1, 21, 31, 41, 51, 61, 71, 81, 91:
                            Text("\(item + 1)st Draw : \(resultArray[item])")
                        case 2, 22, 32, 42, 52, 62, 72, 82, 92:
                            Text("\(item + 1)nd Draw : \(resultArray[item])")
                        case 3, 23, 33, 43, 53, 63, 73, 83, 93:
                            Text("\(item + 1)rd Draw : \(resultArray[item])")
                        default:
                            Text("\(item + 1)th Draw : \(resultArray[item])")
                        }
                    }
                }
            }
            .navigationTitle("High Rollers")
        }
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    
    func rollDice(type: Int, number: Int) {
        timerCancellables.forEach { $0.cancel() }
        timerCancellables.removeAll()
        
        let finalResult = Int.random(in: number...type * number)
        var updateCount = 0
        let maxUpdates = type / 5
        
        timer
            .sink { _ in
                if updateCount < maxUpdates {
                    updateCount += 1
                    result = Int.random(in: number...type * number)
                } else {
                    result = finalResult
                    resultArray.append(result)
                    timerCancellables.forEach { $0.cancel() }
                    timerCancellables.removeAll()
                }
            }
            .store(in: &timerCancellables)
        
//        let typeOf = Int.random(in: 1...type)
//        let numberOf = number
//        let total = typeOf * numberOf
//        resultArray.append(total)
//        
//        return total
    }
}
