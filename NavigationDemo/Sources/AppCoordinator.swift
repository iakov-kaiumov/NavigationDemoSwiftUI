import UIKit

class AppCoordinator {
    // MARK: - Private variables
    private let window: UIWindow
    private let navigationRouter: NavigationRouter
    private let navigationCoordinator: NavigationCoordinator
    
    // MARK: - Init
    init(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        
        /// Here you can customize your navigation by changing navigationRouter implementation
        /// Currently `ColumnNavigationRouter` and `StackNavigationRouter` are available
        navigationRouter = ColumnNavigationRouter(window: window)
        navigationCoordinator = NavigationCoordinator(router: navigationRouter)
        
        let view = ContentView()
        navigationCoordinator.start(content: view)
    }
}
