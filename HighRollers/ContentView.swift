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
    
    let savePath = URL.documentsDirectory.appending(path: "SavedDice")
    
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
                
                if !resultArray.isEmpty {
                    Section("Previous Results") {
                        ForEach(resultArray) { item in
                            VStack(alignment: .leading) {
                                Text("\(item.numbers) x D\(item.type)")
                                    .font(.headline.bold())
                                Text(item.rolls.compactMap(String.init).joined(separator: ", "))
                            }
                        }
                    }
                }
            }
            .navigationTitle("High Rollers")
            .toolbar {
                EditButton()
            }
            .onReceive(timer) { time in
                updateDice()
            }
            .onAppear(perform: load)
        }
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    
    func save() {
        if let data = try? JSONEncoder().encode(resultArray) {
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
    
    func load() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([DiceResult].self, from: data) {
                resultArray = decoded
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        resultArray.remove(atOffsets: offsets)
    }
    
    func rollDice() {
        currentResult = DiceResult(type: selectedDiceType, numbers: selectedDiceNumbers)
        
        stoppedDice = -20
    }
    
    func updateDice() {
        guard stoppedDice < currentResult.rolls.count else { return }
        
        for i in stoppedDice ..< selectedDiceNumbers {
            if i < 0 { continue }
            currentResult.rolls[i] = Int.random(in: 1...selectedDiceType)
        }
        
        stoppedDice += 1
        
        if stoppedDice == selectedDiceNumbers {
            resultArray.insert(currentResult, at: 0)
            save()
        }
    }
}
