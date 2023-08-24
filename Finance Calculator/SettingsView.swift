import SwiftUI

struct SettingsView: View {
    @AppStorage("currencyType") var currencyType: String = "LKR"
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    private let currencyOptions = [
        "LKR",
        "USD",
        "EUR",
        "GBP",
        "JPY",
        "AUD",
        "CAD",
        "CNY"
    ]
    
    var body: some View {
        Form {
            Section(header: Text("App Settings")) {
                Picker(selection: $currencyType, label: Text("Currency")) {
                    ForEach(0 ..< currencyOptions.count) { index in
                        Text(currencyOptions[index]).tag(currencyOptions[index])
                    }
                }
                Toggle("Dark Mode", isOn: $isDarkMode)
            }
            Section(header: Text("About")) {
                LabeledContent("Developed By", value: "Binara Sachin")
                Link("Developer Profile", destination: URL(string: "https://github.com/Binara-Sachin")!)
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
