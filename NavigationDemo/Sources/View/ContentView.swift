import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    @ObservedObject private var appState: AppState = AppState()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My custom header")
                    .font(.title)
                
                Spacer()
            }
            .padding()
            .background(Color.blue.opacity(0.5).edgesIgnoringSafeArea(.all))
            
            List {
                ForEach(0..<10, id: \.self) { index in
                    Button(action: {
                        onCellTapped(index)
                    }) {
                        Text("Cell \(index)")
                            .foregroundColor(Color(UIColor.label))
                    }
                }
            }
        }
    }
    
    private func onCellTapped(_ index: Int) {
        let view = DetailsView(index: index).environmentObject(appState)
        coordinator.show(view, isDetail: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
        ContentView()
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
