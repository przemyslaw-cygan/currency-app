import ComposableArchitecture
import IQKeyboardManagerSwift
import MainFeature
import MainUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, URLSessionTaskDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = MainViewController(store: Store(initialState: MainFeature.State()) { MainFeature() })
        self.window?.makeKeyAndVisible()

        return true
    }
}
