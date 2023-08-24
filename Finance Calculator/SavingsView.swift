import SwiftUI

struct SavingsView: View {
    @SceneStorage("SavingsView.selectedType") private var selectedType = 0
    
    @SceneStorage("SavingsView.initialInvestmentString") private var initialInvestmentString : String = ""
    @SceneStorage("SavingsView.interestRateString") private var interestRateString : String = ""
    @SceneStorage("SavingsView.futureValueString") private var futureValueString : String = ""
    @SceneStorage("SavingsView.noOfMonthsString") private var noOfMonthsString : String = ""
    
    @AppStorage("currencyType") var currencyType: String = "LKR"
    
    private let calculationTypes = [
        "Initial Investment",
        "Interest Rate",
        "Investment Period",
        "Future Value"
    ]
    
    func calculate() -> String {
        let initialInvestment = Double(initialInvestmentString) ?? 0.0
        let futureValue = Double(futureValueString) ?? 0.0
        let interestRate = Double(interestRateString) ?? 0.0
        let noOfMonths = Double(noOfMonthsString) ?? 0.0
        
        let monthlyInterestRate = interestRate / (12 * 100)
        
        var result = 0.0
        var resultSymbol = ""
        var resultFormat = "%.2f"
        
        switch (selectedType) {
        case 0:
            // Calculate initial investment
            result = futureValue / pow(1 + monthlyInterestRate, noOfMonths)
            resultSymbol = currencyType
        case 1:
            // Calculate interest rate
            result = (12 * 100) * log(futureValue / initialInvestment) / noOfMonths
            resultSymbol = "%"
        case 2:
            // Calculate investment period (Number of months)
            result = log(futureValue / initialInvestment) / log(1 + monthlyInterestRate)
            resultSymbol = "months"
            resultFormat = "%.0f"
        case 3:
            // Calculate future value
            result = initialInvestment * pow(1 + monthlyInterestRate, noOfMonths)
            resultSymbol = currencyType
        default:
            return "Error: Something went wrong."
        }
        if (result.isNaN || result.isInfinite) {
            result = 0.0;
        }
        return String(format: resultFormat, result) + " " + resultSymbol
    }
    
    func clearForm() {
        initialInvestmentString = ""
        interestRateString = ""
        futureValueString = ""
        noOfMonthsString = ""
    }
    
    var body: some View {
        Form{
            Section(header: Text("Calculation Type")) {
                Picker(selection: $selectedType, label: Text("Find")) {
                    ForEach(0 ..< calculationTypes.count) { index in
                        Text(self.calculationTypes[index]).tag(index)
                    }
                }
            }
            Section(header: Text("Available Data")) {
                if (selectedType != 0) {
                    LabeledContent {
                        HStack {
                            TextField("0.00", text: $initialInvestmentString)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text(currencyType)
                        }
                    } label: {
                        Text("Initial Investment")
                    }
                }
                if (selectedType != 1) {
                    LabeledContent {
                        HStack {
                            TextField("0.0", text: $interestRateString)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text("%")
                        }
                    } label: {
                        Text("Interest Rate")
                    }
                    
                }
                if (selectedType != 2) {
                    LabeledContent {
                        HStack {
                            TextField("0", text: $noOfMonthsString)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("months")
                        }
                    } label: {
                        Text("Investment Period")
                    }
                }
                if (selectedType != 3) {
                    LabeledContent {
                        HStack {
                            TextField("0.00", text: $futureValueString)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text(currencyType)
                        }
                    } label: {
                        Text("Future value")
                    }
                }
            }
            Section(header: Text(calculationTypes[selectedType])) {
                HStack {
                    Text(calculate())
                }
            }
            Section {
                Button("Clear", action: clearForm).accentColor(.red)
            }
        }
        .navigationTitle("Savings")
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button ("Done") {
                        hideKeyboard()
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
    }
}

struct SavingsView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsView()
    }
}
