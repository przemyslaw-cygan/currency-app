import UIKit

public extension UILabel {
    var fontName: String {
        get { self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.fontSize) }
    }

    var fontSize: CGFloat {
        get { self.font.pointSize }
        set { self.font = UIFont(name: self.fontName, size: newValue) }
    }
}

public extension UITextField {
    var fontName: String {
        get { self.font!.fontName }
        set { self.font = UIFont(name: newValue, size: self.fontSize) }
    }

    var fontSize: CGFloat {
        get { self.font!.pointSize }
        set { self.font = UIFont(name: self.fontName, size: newValue) }
    }
}
