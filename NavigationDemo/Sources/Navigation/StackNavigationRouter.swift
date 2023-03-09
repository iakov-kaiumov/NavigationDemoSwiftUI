import SwiftUI

public final class StackNavigationRouter: NavigationRouter {
    // MARK: - Private variables
    private lazy var navigationController: UINavigationController = .init()
    
    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    // MARK: - Public methods
    public func isCollapsed() -> Bool {
        return false
    }
    
    public func setNavigationBarHidden(_ hidden: Bool, animated: Bool = true) {
        navigationController.setNavigationBarHidden(hidden, animated: animated)
    }
    
    public func start<Content: View>(content: Content) {
        let viewController = UIMasterHostingController(rootView: content)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    public func show<Destination: View>(
        _ view: Destination,
        isDetail: Bool = false,
        animated: Bool = true,
        transition: NavigationTranisitionStyle = .push
    ) {
        let viewController = UIHostingController(rootView: view)
        switch transition {
        case .push:
            navigationController.pushViewController(viewController, animated: animated)
        case .presentSheet:
            viewController.modalPresentationStyle = .formSheet
            navigationController.present(viewController, animated: animated)
        case .presentHalfSheet:
            viewController.modalPresentationStyle = .formSheet
            if #available(iOS 15.0, *) {
                if let presentationController = viewController.sheetPresentationController {
                    presentationController.detents = [.medium(), .large()]
                    presentationController.preferredCornerRadius = 16
                }
            }
            
            navigationController.present(viewController, animated: animated)
        case .presentFullscreen:
            viewController.modalPresentationStyle = .fullScreen
            navigationController.present(viewController, animated: animated)
        }
    }
    
    public func pop(animated: Bool = true, offset: Int = 1) {
        if offset == 1 {
            navigationController.popViewController(animated: animated)
        } else if offset > 1 {
            let index = navigationController.viewControllers.count - offset - 1
            if index < navigationController.viewControllers.count {
                let controller = navigationController.viewControllers[index]
                navigationController.popToViewController(controller, animated: animated)
            } else {
                navigationController.popToRootViewController(animated: animated)
            }
        }
    }
    
    public func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }
    
    public func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: animated)
    }
}
