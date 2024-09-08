import CurrencyAPIData
import FlagKit
import UIKit

public extension Currency.ID {
    static let defaultBaseCurrencyID = Locale.current.currencySymbol ?? "USD"
    static let defaultCurrencyID = Locale.current.currencySymbol != "USD" ? "USD" : "CHF"
}

public extension Currency {
    var color: UIColor? {
        switch self.type {
        case .crypto:
            UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
        case .fiat:
            UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
        case .metal:
            switch self.id {
            case "XAG":
                UIColor(red: 255.0 / 255.0, green: 215.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
            case "XAU":
                UIColor(red: 192.0 / 255.0, green: 192.0 / 255.0, blue: 192.0 / 255.0, alpha: 1.0)
            case "XPT":
                UIColor(red: 229.0 / 255.0, green: 228.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
            case "XPD":
                UIColor(red: 117.0 / 255.0, green: 117.0 / 255.0, blue: 117.0 / 255.0, alpha: 1.0)
            default:
                UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
            }
        }
    }

    var country: String? {
        self.countries
            .first(where: { self.code.contains($0) })
            ?? self.countries.first
    }

    var extendedDecimalDigits: Int {
        switch self.type {
        case .fiat:
            2
        case .crypto:
            0
        case .metal:
            0
        }
    }

    var image: UIImage? {
        switch self.type {
        case .crypto:
            UIImage(systemName: "aqi.medium")
        case .fiat:
            switch self.country {
            case .some(let country):
                Flag(countryCode: country)?.image(style: .circle)
            case .none:
                nil
            }
        case .metal:
            UIImage(systemName: "diamond.fill")
        }
    }

    var order: String {
        let typeOrder = switch self.type {
        case .crypto:
            "2"
        case .fiat:
            "0"
        case .metal:
            "1"
        }

        return typeOrder + self.code
    }

    func format(_ locale: Locale, _ value: Double, extended flag: Bool = false) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.minimumFractionDigits = self.decimalDigits + (flag ? self.extendedDecimalDigits : 0)
        formatter.maximumFractionDigits = self.decimalDigits + (flag ? self.extendedDecimalDigits : 0)
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value))
    }

    func match(_ string: String?) -> Bool {
        guard let string, !string.isEmpty else { return true }

        let searchString = string
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let strings: [String] = [
            self.symbol,
            self.code,
            self.name,
            self.namePlural,
            self.symbolNative,
        ] + self.countries

        return strings
            .map { $0.lowercased().contains(searchString) }
            .contains(true)
    }
}
