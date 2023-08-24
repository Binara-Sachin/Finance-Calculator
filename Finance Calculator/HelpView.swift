import SwiftUI

struct HelpView: View {
    var body: some View {
        ScrollView (.vertical) {
            VStack {
                Image("01")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                Text("Select the calculator type you want from the Home Screen")
                Divider()
                Image("02")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                Text("You will be redirected to the respective calculator page \nSelect the variable you want to solve to in the CALCULATION TYPE section (Unknown Variable)")
                Divider()
                Image("03")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                Text("Enter the known values in the AVAILABLE DATA section \nThe unknown varible will be automatically calculated and displayed")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .navigationTitle("Help")
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
