import UIKit

extension CALayer {
    func copyLayer<T: CALayer>() -> T {
        NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}
