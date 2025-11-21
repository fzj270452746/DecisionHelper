import UIKit

extension UIView {
    func applyGradientEmbellishment(startingChroma: UIColor, terminatingChroma: UIColor) {
        let gradientLayer = ChromaticPalette.generateGradientLuminance(
            startingChroma: startingChroma,
            terminatingChroma: terminatingChroma
        )
        gradientLayer.frame = bounds

        if let existingGradient = layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            existingGradient.removeFromSuperlayer()
        }

        layer.insertSublayer(gradientLayer, at: 0)
    }

    func applyShadowEmbellishment(opacity: Float = 0.3, radius: CGFloat = 8, offset: CGSize = CGSize(width: 0, height: 4)) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }

    func applyPulsatingAnimation(duration: TimeInterval = 1.5) {
        let pulsation = CABasicAnimation(keyPath: "transform.scale")
        pulsation.duration = duration
        pulsation.fromValue = 1.0
        pulsation.toValue = 1.05
        pulsation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulsation.autoreverses = true
        pulsation.repeatCount = .infinity
        layer.add(pulsation, forKey: "pulsating")
    }

    func removePulsatingAnimation() {
        layer.removeAnimation(forKey: "pulsating")
    }

    func applyEaseInTransformation(delay: TimeInterval = 0, duration: TimeInterval = 0.3) {
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseOut], animations: {
            self.alpha = 1.0
            self.transform = .identity
        })
    }
}
