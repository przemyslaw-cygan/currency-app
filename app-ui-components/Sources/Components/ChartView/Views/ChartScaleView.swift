import SnapKit
import UIKit

public extension ChartView {
    class ScaleView: CustomView {
        public let strokeLayer = CAShapeLayer()

        public var position: ChartPosition {
            didSet { self.updateData() }
        }

        public var data: [Double] = [] {
            didSet { self.updateData() }
        }

        public init(
            position: ChartPosition,
            data: [Double] = []
        ) {
            self.position = position
            self.data = data

            super.init()
            self.layer.addSublayer(self.strokeLayer)
            self.updateData()
        }

        public override func layoutSubviews() {
            super.layoutSubviews()
            let scale = (
                sx: self.bounds.width / self.strokeLayer.bounds.width,
                sy: self.bounds.height / self.strokeLayer.bounds.height
            )

            self.strokeLayer.frame = self.bounds
            self.strokeLayer.path = Self.scalePath(scale.sx, scale.sy)(self.strokeLayer.path)
        }

        func updateData() {
            if self.strokeLayer.bounds.size == .zero {
                self.strokeLayer.bounds.size = CGSize(value: 100)
            }

            let size = self.strokeLayer.bounds.size
            let points = self.data
                .sorted(by: <)
                .flatMap(Self.makePoints(self.position, size))

            self.strokeLayer.path = Self.makePath(points)
        }

        static let makePoints: (ChartPosition, CGSize) -> (Double) -> [CGPoint] = { position, size in { value in
            switch position {
            case .top:
                [
                    CGPoint(x: value * size.width, y: size.height),
                    CGPoint(x: value * size.width, y: 0),
                    CGPoint(x: value * size.width, y: size.height),
                ]
            case .bottom:
                [
                    CGPoint(x: value * size.width, y: 0),
                    CGPoint(x: value * size.width, y: size.height),
                    CGPoint(x: value * size.width, y: 0),
                ]
            case .left:
                [
                    CGPoint(x: size.width, y: (1 - value) * size.height),
                    CGPoint(x: 0, y: (1 - value) * size.height),
                    CGPoint(x: size.width, y: (1 - value) * size.height),
                ]
            case .right:
                [
                    CGPoint(x: 0, y: (1 - value) * size.height),
                    CGPoint(x: size.width, y: (1 - value) * size.height),
                    CGPoint(x: 0, y: (1 - value) * size.height),
                ]
            }
        } }

        static let makePath: ([CGPoint]) -> CGPath? = { points in
            guard points.count > 1 else { return nil }
            let path = UIBezierPath()
            path.move(to: points.first!)
            points.dropFirst().forEach(path.addLine(to:))
            return path.cgPath
        }

        static let scalePath: (CGFloat, CGFloat) -> (CGPath?) -> CGPath? = { sx, sy in { path in
            var affineTransform = CGAffineTransformMakeScale(sx, sy)
            return path?.copy(using: &affineTransform)
        } }
    }
}

#if targetEnvironment(simulator)
import SwiftUI
import Overture

@available(iOS 17, *)
#Preview {
    with(
        ChartView.ScaleView(position: .right),
        concat(
            set(\.strokeLayer.lineWidth, 10),
            set(\.strokeLayer.strokeColor, Optional(UIColor.red.cgColor)),
            set(\.data, [0.1, 0.01, 0.5, 1])
        )
    )
}
#endif
