import SwiftUI

class AppState: ObservableObject {
    @Published var somePublishedVariable: String = ""
}
