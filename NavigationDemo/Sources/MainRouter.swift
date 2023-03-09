import SwiftUI

public enum MainRouter: NavigationRouter {
    
    case content
    case detail(named: String)
    
    public var transition: NavigationTranisitionStyle {
        return .push
    }
    
    @ViewBuilder
    public func view() -> some View {
        switch self {
        case .content:
            ContentView()
        case .detail(let named):
            SimpleDetailView(id: named)
        }
    }
}
