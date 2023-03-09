import SwiftUI

public final class NavigationCoordinator: ObservableObject {
    private let router: NavigationRouter
    
    public init(router: NavigationRouter) {
        self.router = router
    }
    
    public func isCollapsed() -> Bool {
        router.isCollapsed()
    }
    
    public func setNavigationBarHidden(_ hidden: Bool, animated: Bool = true) {
        router.setNavigationBarHidden(hidden, animated: animated)
    }
    
    public func start<Content: View>(content: Content) {
        router.start(content: content.environmentObject(self))
    }

    public func show<Destination: View>(
        _ view: Destination,
        isDetail: Bool = false,
        animated: Bool = true,
        transition: NavigationTranisitionStyle = .push
    ) {
        let viewWithCoordinator = view.environmentObject(self)
        router.show(viewWithCoordinator, isDetail: isDetail, animated: animated, transition: transition)
    }

    public func pop(animated: Bool = true, offset: Int = 1) {
        router.pop(animated: animated, offset: offset)
    }

    public func popToRoot(animated: Bool = true) {
        router.popToRoot(animated: animated)
    }

    public func dismiss(animated: Bool = true) {
        router.dismiss(animated: animated)
    }
}
