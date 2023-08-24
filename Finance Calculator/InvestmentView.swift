import SwiftUI

struct InvestmentView: View {
    @SceneStorage("InvestmentView.selectedType") private var selectedType = 0
    
    @SceneStorage("InvestmentView.initialInvestmentString") private var initialInvestmentString : String = ""
    @SceneStorage("InvestmentView.monthlyContributionString") private var monthlyContributionString : String = ""
    @SceneStorage("InvestmentView.interestRateString") private var interestRateString : String = ""
    @SceneStorage("InvestmentView.futureValueString") private var futureValueString : String = ""
    @SceneStorage("InvestmentView.noOfMonthsString") private var noOfMonthsString : String = ""
    
    @AppStorage("currencyType") var currencyType: String = "LKR"
    
    private let calculationTypes = [
        "Initial Investment",
        "Monthly Contribution",
        "Interest Rate",
        "Investment Period",
        "Future Value"
    ]
    
    func calculate() -> String {
        let initialInvestment = Double(initialInvestmentString) ?? 0.0
        let monthlyContribution = Double(monthlyContributionString) ?? 0.0
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
            result = (futureValue - monthlyContribution * ((pow(1 + monthlyInterestRate, noOfMonths) - 1) / monthlyInterestRate)) / pow(1 + monthlyInterestRate, noOfMonths)
            resultSymbol = currencyType
        case 1:
            // Calculate monthly contribution
            result = (futureValue - initialInvestment * pow(1 + monthlyInterestRate, noOfMonths)) / ((pow(1 + monthlyInterestRate, noOfMonths) - 1) / monthlyInterestRate)
            resultSymbol = currencyType
        case 2:
            // Calculate interest rate
            result = pow((futureValue * monthlyInterestRate + monthlyContribution) / (initialInvestment * monthlyInterestRate + monthlyContribution), 1 / noOfMonths) - 1
            resultSymbol = "%"
        case 3:
            // Calculate investment period (Number of months)
            result = log((futureValue * monthlyInterestRate + monthlyContribution) / (initialInvestment * monthlyInterestRate + monthlyContribution)) / log(1 + monthlyInterestRate)
            resultSymbol = "months"
            resultFormat = "%.0f"
        case 4:
            // Calculate future value
            result = initialInvestment * pow(1 + monthlyInterestRate, noOfMonths) + monthlyContribution * ((pow(1 + monthlyInterestRate, noOfMonths) - 1) / monthlyInterestRate)
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
                            TextField("0.00", text: $monthlyContributionString)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text(currencyType)
                        }
                    } label: {
                        Text("Monthly Contribution")
                    }
                }
                if (selectedType != 2) {
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
                if (selectedType != 3) {
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
                if (selectedType != 4) {
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
        .navigationTitle("Investment")
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

struct InvestmentView_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentView()
    }
}
