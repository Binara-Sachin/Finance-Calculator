import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List{
                Section {
                    Text("Finance Caculator")
                        .font(
                            .largeTitle
                            .weight(.bold)
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(Color.clear)
                Section {
                    NavigationLink(destination: SavingsView()) {
                        Label("Savings", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    NavigationLink(destination: InvestmentView()) {
                        Label("Savings Advanced", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    NavigationLink(destination: LoanView()) {
                        Label("Loan", systemImage: "chart.line.downtrend.xyaxis")
                    }
                    NavigationLink(destination: MortgageView()) {
                        Label("Mortgage", systemImage: "house")
                    }
                } header: {
                    Text("Finance Calcualtors")
                }
                
                Section {
                    NavigationLink(destination: HelpView()) {
                        Label("Help", systemImage: "questionmark.circle")
                    }
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gearshape")
                    }
                } header: {
                    Text("Utility")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Home")
            .navigationBarHidden(true)
        }
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
