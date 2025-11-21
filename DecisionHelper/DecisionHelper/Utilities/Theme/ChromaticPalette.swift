import UIKit

struct ChromaticPalette {
    static let primaryAzure = UIColor(red: 0.11, green: 0.42, blue: 0.99, alpha: 1.0)
    static let secondaryViolet = UIColor(red: 0.58, green: 0.29, blue: 0.96, alpha: 1.0)
    static let tertiaryEmerald = UIColor(red: 0.13, green: 0.82, blue: 0.58, alpha: 1.0)
    static let accentCrimson = UIColor(red: 0.96, green: 0.26, blue: 0.38, alpha: 1.0)
    static let warningAmber = UIColor(red: 1.0, green: 0.71, blue: 0.20, alpha: 1.0)

    static let backgroundObsidian = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1.0)
    static let backgroundCharcoal = UIColor(red: 0.12, green: 0.12, blue: 0.18, alpha: 1.0)
    static let backgroundSlate = UIColor(red: 0.16, green: 0.16, blue: 0.24, alpha: 1.0)

    static let foregroundIvory = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
    static let foregroundPearl = UIColor(red: 0.88, green: 0.88, blue: 0.92, alpha: 1.0)
    static let foregroundAsh = UIColor(red: 0.62, green: 0.62, blue: 0.68, alpha: 1.0)

    static let separatorGraphite = UIColor(red: 0.24, green: 0.24, blue: 0.32, alpha: 1.0)
    static let overlayMidnight = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.65)

    static func generateGradientLuminance(startingChroma: UIColor, terminatingChroma: UIColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startingChroma.cgColor, terminatingChroma.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradientLayer
    }
}
