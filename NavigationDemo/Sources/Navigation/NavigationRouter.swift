import SwiftUI

public protocol NavigationRouter: AnyObject {
    init(window: UIWindow)

    func isCollapsed() -> Bool

    func setNavigationBarHidden(_ hidden: Bool, animated: Bool)

    func start<Content: View>(content: Content)

    func show<Destination: View>(
        _ view: Destination,
        isDetail: Bool,
        animated: Bool,
        transition: NavigationTranisitionStyle
    )

    func pop(animated: Bool, offset: Int)

    func popToRoot(animated: Bool)

    func dismiss(animated: Bool)
}

extension NavigationRouter {
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool = true) {
        setNavigationBarHidden(hidden, animated: animated)
    }
    
    func show<Destination: View>(
        _ view: Destination,
        isDetail: Bool = false,
        animated: Bool = true,
        transition: NavigationTranisitionStyle = .push
    ) {
        show(view, isDetail: isDetail, animated: animated, transition: transition)
    }

    func pop(animated: Bool = true, offset: Int = 1) {
        pop(animated: animated, offset: offset)
    }

    func popToRoot(animated: Bool = true) {
        popToRoot(animated: animated)
    }

    func dismiss(animated: Bool = true) {
        dismiss(animated: animated)
    }
}
