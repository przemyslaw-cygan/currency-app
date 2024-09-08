import UIKit

public class NavigationViewController: ViewController<NavigationView>, UINavigationControllerDelegate {
    public let controller: UINavigationController

    public init(_ rootViewController: UIViewController? = nil) {
        if let rootViewController {
            self.controller = UINavigationController(rootViewController: rootViewController)
        } else {
            self.controller = UINavigationController()
        }

        super.init()
    }

    public override func buildView() -> CustomView {
        self.addChild(self.controller)
        self.controller.delegate = self
        return NavigationView(with: self.controller)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.customView.backItemView.isHidden = self.controller.viewControllers.count < 2

        self.customView.backItemView.on(.touchUpInside) { [weak self] _ in
            self?.controller.popViewController(animated: true)
        }

        self.customView.closeItemView.on(.touchUpInside) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.customView.backItemView.isHidden = navigationController.viewControllers.count < 2
        self.customView.closeItemView.isHidden = self.presentingViewController == nil ||  navigationController.viewControllers.count > 1

        let navigationAdaptable = viewController as? NavigationAdaptable
        self.customView.titleItem = navigationAdaptable?.titleItem
        self.customView.actionItems = navigationAdaptable?.actionItems ?? []
    }
}
