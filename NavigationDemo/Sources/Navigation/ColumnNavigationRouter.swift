import SwiftUI

public final class ColumnNavigationRouter: NavigationRouter {
    // MARK: - Private variables
    private var splitViewController: UISplitViewController = {
        if #available(iOS 14, *) {
            let splitViewController = UISplitViewController(style: .doubleColumn)
            splitViewController.preferredDisplayMode = .oneBesideSecondary
            splitViewController.preferredSplitBehavior = .tile
            splitViewController.minimumPrimaryColumnWidth = 350
            splitViewController.preferredPrimaryColumnWidth = 420
            splitViewController.maximumPrimaryColumnWidth = 500
            splitViewController.presentsWithGesture = false
            return splitViewController
        } else {
            let splitViewController = UISplitViewController()
            splitViewController.preferredDisplayMode = .oneBesideSecondary
            splitViewController.minimumPrimaryColumnWidth = 350
            splitViewController.maximumPrimaryColumnWidth = 500
            splitViewController.presentsWithGesture = false
            return splitViewController
        }
    }()
    
    private let masterNavigationController: UINavigationController = .init()
    private let detailNavigationController: UINavigationController = .init()
    
    private lazy var emptyViewController: UIViewController = UIHostingController(rootView: EmptyView())
    
    private let window: UIWindow
    private var homeViewController: UIViewController? = nil
    
    public init(window: UIWindow) {
        self.window = window
        
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        splitViewController.delegate = self
        
        window.rootViewController = splitViewController
        window.makeKeyAndVisible()
    }
    
    // MARK: - Public methods
    public func isCollapsed() -> Bool {
        return splitViewController.isCollapsed
    }
    
    public func setNavigationBarHidden(_ hidden: Bool, animated: Bool = true) {
        detailNavigationController.setNavigationBarHidden(hidden, animated: animated)
    }
    
    public func start<Content: View>(content: Content) {
        let viewController = UIMasterHostingController(rootView: content)
        homeViewController = viewController
        masterNavigationController.setViewControllers([viewController], animated: false)
        detailNavigationController.setViewControllers([emptyViewController], animated: false)
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
            if isDetail {
                detailNavigationController.viewControllers = []
                splitViewController.showDetailViewController(viewController, sender: nil)
            } else {
                detailNavigationController.pushViewController(viewController, animated: animated)
            }
        case .presentSheet:
            viewController.modalPresentationStyle = .formSheet
            splitViewController.present(viewController, animated: animated)
        case .presentHalfSheet:
            viewController.modalPresentationStyle = .formSheet
            if #available(iOS 15.0, *) {
                if let presentationController = viewController.sheetPresentationController {
                    if splitViewController.isCollapsed {
                        presentationController.detents = [.medium(), .large()]
                    } else {
                        presentationController.detents = [.large()]
                    }
                    presentationController.preferredCornerRadius = 16
                }
            }
            
            splitViewController.present(viewController, animated: animated)
        case .presentFullscreen:
            viewController.modalPresentationStyle = .fullScreen
            splitViewController.present(viewController, animated: animated)
        }
    }
    
    public func pop(animated: Bool = true, offset: Int = 1) {
        if offset == 1 {
            if splitViewController.isCollapsed {
                detailNavigationController.navigationController?.popViewController(animated: animated)
            } else {
                if detailNavigationController.viewControllers.count > 1 {
                    detailNavigationController.popViewController(animated: animated)
                } else {
                    detailNavigationController.viewControllers = []
                    splitViewController.showDetailViewController(emptyViewController, sender: nil)
                }
            }
        } else if offset > 1 {
            let index = detailNavigationController.viewControllers.count - offset - 1
            if index < detailNavigationController.viewControllers.count {
                let controller = detailNavigationController.viewControllers[index]
                detailNavigationController.popToViewController(controller, animated: animated)
            } else {
                detailNavigationController.viewControllers = []
                splitViewController.showDetailViewController(emptyViewController, sender: nil)
            }
        }
    }
    
    public func popToRoot(animated: Bool = true) {
        if splitViewController.isCollapsed {
            detailNavigationController.navigationController?.popToRootViewController(animated: animated)
        } else {
            detailNavigationController.viewControllers = []
            splitViewController.showDetailViewController(emptyViewController, sender: nil)
        }
    }
    
    public func dismiss(animated: Bool = true) {
        splitViewController.dismiss(animated: animated)
    }
}

extension ColumnNavigationRouter: UISplitViewControllerDelegate {
    @available(iOS 14, *)
    public func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        if detailNavigationController.viewControllers.count > 1 {
            return .secondary
        }
        return .primary
    }
}
