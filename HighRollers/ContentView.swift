//
//  ContentView.swift
//  HighRollers
//
//  Created by Damien Chailloleau on 05/08/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var stoppedDice: Int = 0
    @State private var currentResult = DiceResult(type: 0, numbers: 0)
    @State private var resultArray = [DiceResult]()
    
    @AppStorage("selectedDiceType") var selectedDiceType: Int = 4
    @AppStorage("selectedDiceNumbers") var selectedDiceNumbers: Int = 1
    
    let diceTypes: [Int] = [4, 6, 8, 10, 12, 20, 100]
    
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    let columns: [GridItem] = [
        .init(.adaptive(minimum: 60))
    ]
    
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
                    
                    Button("Roll Dice") {
                        rollDice()
                    }
                } footer: {
                    LazyVGrid(columns: columns) {
                        ForEach(0 ..< currentResult.rolls.count, id: \.self) { rollNumber in
                            Text(String(currentResult.rolls[rollNumber]))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundStyle(.black)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 10))
                                .shadow(radius: 3)
                                .font(.title)
                                .padding(5)
                                
                                
                                
                        }
                    }
                }
                .disabled(stoppedDice < currentResult.rolls.count)
                
                List {
//                    ForEach(0 ..< resultArray.count, id: \.self) { item in
//                        switch item + 1 {
//                        case 1, 21, 31, 41, 51, 61, 71, 81, 91:
//                            Text("\(item + 1)st Draw : \(resultArray[item])")
//                        case 2, 22, 32, 42, 52, 62, 72, 82, 92:
//                            Text("\(item + 1)nd Draw : \(resultArray[item])")
//                        case 3, 23, 33, 43, 53, 63, 73, 83, 93:
//                            Text("\(item + 1)rd Draw : \(resultArray[item])")
//                        default:
//                            Text("\(item + 1)th Draw : \(resultArray[item])")
//                        }
//                    }
                }
            }
            .navigationTitle("High Rollers")
            .onReceive(timer) { time in
                updateDice()
            }
        }
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    
    func rollDice() {
        currentResult = DiceResult(type: selectedDiceType, numbers: selectedDiceNumbers)
        
        stoppedDice = -20
//        timerCancellables.forEach { $0.cancel() }
//        timerCancellables.removeAll()
//        
//        let finalResult = Int.random(in: number...type * number)
//        var updateCount = 0
//        let maxUpdates = type / 5
        
//        timer
//            .sink { _ in
//                if updateCount < maxUpdates {
//                    updateCount += 1
//                    result = Int.random(in: number...type * number)
//                } else {
//                    result = finalResult
//                    resultArray.append(result)
//                    timerCancellables.forEach { $0.cancel() }
//                    timerCancellables.removeAll()
//                }
//            }
//            .store(in: &timerCancellables)
        
//        let typeOf = Int.random(in: 1...type)
//        let numberOf = number
//        let total = typeOf * numberOf
//        resultArray.append(total)
//        
//        return total
    }
    
    func updateDice() { 
        /**
         Check if we’ve already stopped all our dice, because if so we need no further action until the user rolls again.
         Count from the value of stoppedDice up to the number of dice we’re rolling, giving each one a fresh random number.
         Add 1 to stoppedDice so that another dice gets stopped, meaning that the current value it shows is its final value.
         */
        guard stoppedDice < currentResult.rolls.count else { return }
        
        for i in stoppedDice ..< selectedDiceNumbers {
            if i < 0 { continue }
            currentResult.rolls[i] = Int.random(in: 1...selectedDiceType)
        }
        
        stoppedDice += 1
    }
}
