import UIKit
import Overture
import SnapKit

public enum Styler {
    public enum Color {
        public static let backgroundPrimary: UIColor? = .systemBackground
        public static let backgroundSecondary: UIColor? = .secondarySystemBackground

        public static let labelPrimary: UIColor? = .label
        public static let labelSecondary: UIColor? = .secondaryLabel

        public static let accentBackground: UIColor? = .systemBlue
        public static let accentForeground: UIColor? = .white

        public static let indicatingPositive: UIColor? = .systemGreen
        public static let indicatingNeutral: UIColor? = .systemGray
        public static let indicatingNegative: UIColor? = .systemRed

        public static let shadow: UIColor? = .systemGray.withAlphaComponent(0.5)
    }

    public enum FontName {
        public static let label: String = "Helvetica Neue Medium"
        public static let button: String = "Helvetica Neue Medium"
        public static let field: String = "Helvetica Neue"
        public static let body: String = "Helvetica Neue Light"
        public static let header: String = "Helvetica Neue"
    }

    public enum Size {
        public static let S: CGFloat = 10.0
        public static let M: CGFloat = 12.0
        public static let L: CGFloat = 14.0

        public static let spacing: CGFloat = 8
    }

    public static func elevated<T, V: UIView>(
        _ keyPath: KeyPath<T, V>,
        _ level: Int
    ) -> (T) -> T {
        let radius = 2.0 * max(min(CGFloat(level), 5.0), 1.0)
        let offset = CGSize(
            width: 0.1 * radius,
            height: 0.2 * radius
        )

        return concat(
            set(keyPath.appending(path: \.layer.shadowColor), Color.shadow?.cgColor),
            set(keyPath.appending(path: \.layer.shadowOffset), offset),
            set(keyPath.appending(path: \.layer.shadowOpacity), 1.0),
            set(keyPath.appending(path: \.layer.shadowRadius), radius)
        )
    }

    public static func rounded<T, V: UIView>(
        _ keyPath: KeyPath<T, V>,
        _ radius: CGFloat
    ) -> (T) -> T {
        concat(
            set(keyPath.appending(path: \.layer.cornerRadius), radius),
            set(keyPath.appending(path: \.layer.cornerCurve), .continuous)
        )
    }

    public static func circular<T, V: CircularView>(
        _ keyPath: KeyPath<T, V>,
        _ isCircular: Bool = true
    ) -> (T) -> T {
        set(keyPath.appending(path: \.isCircular), isCircular)
    }
}

extension Styler {
    public static func elevated<T: UIView>(
        _ level: Int
    ) -> (T) -> T {
        elevated(\T.self, level)
    }

    public static func rounded<T: UIView>(
        _ radius: CGFloat
    ) -> (T) -> T {
        rounded(\T.self, radius)
    }

    public static func circular<T: CircularView>(
        _ isCircular: Bool = true
    ) -> (T) -> T {
        circular(\T.self)
    }
}

public protocol CircularView: AnyObject {
    var isCircular: Bool { get set }
}

extension CustomView: CircularView {}
extension CustomControl: CircularView {}
