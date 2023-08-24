import SwiftUI

struct LoanView: View {
    @SceneStorage("LoanView.selectedType") private var selectedType = 0
    
    @SceneStorage("LoanView.loanAmountString") private var loanAmountString : String = ""
    @SceneStorage("LoanView.interestRateString") private var interestRateString : String = ""
    @SceneStorage("LoanView.monthlyPaymentString") private var monthlyPaymentString : String = ""
    @SceneStorage("LoanView.noOfMonthsString") private var noOfMonthsString : String = ""
    
    @AppStorage("currencyType") var currencyType: String = "LKR"
    
    private let calculationTypes = [
        "Loan Amount",
        "Interest Rate",
        "Payment Period",
        "Monthly Payment"
    ]
    
    func calculate() -> String {
        let loanAmount = Double(loanAmountString) ?? 0.0
        let monthlyPayment = Double(monthlyPaymentString) ?? 0.0
        let interestRate = Double(interestRateString) ?? 0.0
        let noOfMonths = Double(noOfMonthsString) ?? 0.0
        
        let monthlyInterestRate = interestRate / (12 * 100)
        
        var result = 0.0
        var resultSymbol = ""
        var resultFormat = "%.2f"
        
        switch (selectedType) {
        case 0:
            // Calculate initial loan amount
            result = (monthlyPayment * (pow(1 + monthlyInterestRate, noOfMonths) - 1)) / (monthlyInterestRate * pow(1 + monthlyInterestRate, noOfMonths))
            resultSymbol = currencyType
        case 1:
            // Calculate interest rate
            func F(_ x: Double) -> Double {
                let F = loanAmount * x * pow(1 + x, noOfMonths) / (pow(1 + x, noOfMonths) - 1) - monthlyPayment
                return F
            }
            
            func F_Prime(_ x: Double) -> Double {
                let F_Prime = loanAmount * pow(x + 1, noOfMonths - 1) * (x * pow(x + 1, noOfMonths) + pow(x + 1, noOfMonths) - (noOfMonths * x) - x - 1) / pow(pow(x + 1, noOfMonths) - 1, 2)
                return F_Prime
            }
            
            var x = 1 + (((monthlyPayment * noOfMonths / loanAmount) - 1) / 12)
            
            while abs(F(x)) > Double(0.000001) {
                x = x - F(x) / F_Prime(x)
            }
            
            result = Double(12 * x * 100)
            resultSymbol = "%"
        case 2:
            // Calculate payment period in months
            result = log(monthlyPayment / (monthlyPayment - loanAmount * monthlyInterestRate)) / log(1 + monthlyInterestRate)
            resultSymbol = "months"
            resultFormat = "%.0f"
        case 3:
            // Calculate monthly payment
            result = (loanAmount * monthlyInterestRate * pow(1 + monthlyInterestRate, noOfMonths)) / (pow(1 + monthlyInterestRate, noOfMonths) - 1)
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
        loanAmountString = ""
        interestRateString = ""
        monthlyPaymentString = ""
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
                            TextField("0.00", text: $loanAmountString)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text(currencyType)
                        }
                    } label: {
                        Text("Loan Amount")
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
                        Text("Loan Tenure")
                    }
                }
                if (selectedType != 3) {
                    LabeledContent {
                        HStack {
                            TextField("0.00", text: $monthlyPaymentString)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text(currencyType)
                        }
                    } label: {
                        Text("Monthly Payment")
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
        .navigationTitle("Loan")
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

struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        LoanView()
    }
}
