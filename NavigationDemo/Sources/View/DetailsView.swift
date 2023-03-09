import SwiftUI

struct DetailsView: View {
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var index: Int
    
    var body: some View {
        VStack(spacing: 24) {
            Text("This is details view \(index)")
            
            Button(action: {
                let view = DetailsView(index: index + 1)
                coordinator.show(view)
            }) {
                Text("Push nested details")
            }
            
            Button(action: {
                let view = DetailsView(index: index + 1)
                coordinator.show(view, transition: .presentSheet)
            }) {
                Text("Present sheet")
            }
            
            Button(action: {
                let view = DetailsView(index: index + 1)
                coordinator.show(view, transition: .presentHalfSheet)
            }) {
                Text("Present half sheet")
            }
        }
        .navigationBarTitle("Details View", displayMode: .inline)
        .navigationBarItems(trailing: navigationTrailingButton)
    }
    
    private var navigationTrailingButton: some View {
        Button(action: {
            
        }) {
            Text("Button")
        }
    }
}
