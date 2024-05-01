//
//  ContentView.swift
//  WeSplit
//
//  Created by Vishrut Jha on 4/25/24.
//

import SwiftUI

struct ContentView: View {
    // defaults
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    @State private var customTipPercentage: String = ""
    
    @FocusState private var amountIsFocused: Bool
    @FocusState private var customTipIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var tipValue: Double {
        return checkAmount / 100 * Double(tipPercentage)
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) People")
                        }
                    }
                }
                
                Section("Tip %?") {
                    Picker("% Tip", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                        Text("Custom").tag(-1)
                    }
                    .pickerStyle(.segmented)
                    
                    if tipPercentage == -1 { // Custom tip selected
                        TextField("Enter custom tip %", text: $customTipPercentage)
                            .keyboardType(.numberPad)
                            .focused($customTipIsFocused)
                            .onSubmit {
                                if let customTip = Int(customTipPercentage) {
                                    tipPercentage = customTip
                                }
                            }
                            .onAppear {
                                if customTipPercentage.isEmpty {
                                    customTipPercentage = String(tipPercentage)
                                }
                            }
                    }
                }
                
                Section("Amount per person") {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(tipPercentage == 0 ? .red : .blue)
                }
                
                Section("Total Amount + Tip") {
                    Text("\(checkAmount + tipValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                }
                
                if checkAmount > 0 {
                    Section("Transaction Summary") {
                        Text("Total amount: \(checkAmount + tipValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                        Text("Tip amount: \(tipValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                        if tipPercentage == -1 {
                            Text("Custom tip: \(customTipPercentage)%")
                        }
                        Text("Number of people: \(numberOfPeople + 2)")
                        Text("Per person share: \(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    }
                }

            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                        customTipIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
