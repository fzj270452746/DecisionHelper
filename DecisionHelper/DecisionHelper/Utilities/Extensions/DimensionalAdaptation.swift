import UIKit

struct DimensionalAdaptation {
    static var isCompactDevice: Bool {
        return UIScreen.main.bounds.width <= 375
    }

    static var isExpandedDevice: Bool {
        return UIScreen.main.bounds.width > 414
    }

    static var isIpadCompatibilityMode: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    static func calibratedMagnitude(_ baseMagnitude: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = screenWidth / 375.0
        return baseMagnitude * scaleFactor
    }

    static func calibratedTypography(_ baseTypography: CGFloat) -> CGFloat {
        if isIpadCompatibilityMode {
            return baseTypography * 1.2
        } else if isCompactDevice {
            return baseTypography * 0.9
        }
        return baseTypography
    }

    static var horizontalMargin: CGFloat {
        if isIpadCompatibilityMode {
            return 32
        } else if isExpandedDevice {
            return 24
        }
        return 20
    }

    static var verticalSpacing: CGFloat {
        if isIpadCompatibilityMode {
            return 20
        } else if isCompactDevice {
            return 12
        }
        return 16
    }

    static var cornerRadiusStandard: CGFloat {
        return isIpadCompatibilityMode ? 16 : 12
    }

    static var cornerRadiusAmplified: CGFloat {
        return isIpadCompatibilityMode ? 24 : 20
    }
}
