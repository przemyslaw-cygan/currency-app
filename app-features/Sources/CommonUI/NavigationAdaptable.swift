import UIKit

public protocol NavigationAdaptable {
    var titleItem: UIView? { get }
    var actionItems: [UIView] { get }
}
