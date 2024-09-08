import UIKit

public class GradientView: CustomView {
    public let gradientLayer = CAGradientLayer()

    public override init() {
        super.init()
        self.layer.insertSublayer(self.gradientLayer, at: 0)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }
}
