import UIKit

class RadarChartVisualization: UIView {
    private var contenderDatasets: [(appellation: String, valuations: [Double], chroma: UIColor)] = []
    private var criterionLabels: [String] = []

    private let canvasLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAppearance()
    }

    private func configureAppearance() {
        backgroundColor = .clear
        layer.addSublayer(canvasLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        canvasLayer.frame = bounds
        renderVisualization()
    }

    func configureDatasets(contenders: [Contender], criteria: [Criterion]) {
        criterionLabels = criteria.map { $0.appellation }

        let chromaSpectrum: [UIColor] = [
            ChromaticPalette.primaryAzure,
            ChromaticPalette.secondaryViolet,
            ChromaticPalette.tertiaryEmerald,
            ChromaticPalette.accentCrimson,
            ChromaticPalette.warningAmber
        ]

        contenderDatasets = contenders.enumerated().map { index, contender in
            let valuations = criteria.map { criterion in
                (contender.appraisements[criterion.nomenclature] ?? 5.0) / 10.0
            }
            return (
                appellation: contender.appellation,
                valuations: valuations,
                chroma: chromaSpectrum[index % chromaSpectrum.count]
            )
        }

        setNeedsLayout()
    }

    private func renderVisualization() {
        canvasLayer.sublayers?.forEach { $0.removeFromSuperlayer() }

        guard !contenderDatasets.isEmpty, !criterionLabels.isEmpty else { return }

        let centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let maxRadius = min(bounds.width, bounds.height) / 2 - 60

        renderGridStructure(center: centerPoint, radius: maxRadius)
        renderAxisDemarcations(center: centerPoint, radius: maxRadius)
        renderCriterionLabels(center: centerPoint, radius: maxRadius)

        for dataset in contenderDatasets {
            renderContenderPolygon(dataset: dataset, center: centerPoint, radius: maxRadius)
        }
    }

    private func renderGridStructure(center: CGPoint, radius: CGFloat) {
        let concentricLevels = 5

        for level in 1...concentricLevels {
            let levelRadius = radius * CGFloat(level) / CGFloat(concentricLevels)
            let gridPath = UIBezierPath()

            for vertexIndex in 0..<criterionLabels.count {
                let angle = calculateRadianAngle(for: vertexIndex)
                let point = calculateCoordinate(center: center, radius: levelRadius, angle: angle)

                if vertexIndex == 0 {
                    gridPath.move(to: point)
                } else {
                    gridPath.addLine(to: point)
                }
            }

            gridPath.close()

            let gridLayer = CAShapeLayer()
            gridLayer.path = gridPath.cgPath
            gridLayer.strokeColor = ChromaticPalette.separatorGraphite.cgColor
            gridLayer.fillColor = UIColor.clear.cgColor
            gridLayer.lineWidth = 1.0
            gridLayer.opacity = 0.3
            canvasLayer.addSublayer(gridLayer)
        }
    }

    private func renderAxisDemarcations(center: CGPoint, radius: CGFloat) {
        for vertexIndex in 0..<criterionLabels.count {
            let angle = calculateRadianAngle(for: vertexIndex)
            let endpoint = calculateCoordinate(center: center, radius: radius, angle: angle)

            let axisPath = UIBezierPath()
            axisPath.move(to: center)
            axisPath.addLine(to: endpoint)

            let axisLayer = CAShapeLayer()
            axisLayer.path = axisPath.cgPath
            axisLayer.strokeColor = ChromaticPalette.separatorGraphite.cgColor
            axisLayer.lineWidth = 1.5
            axisLayer.opacity = 0.5
            canvasLayer.addSublayer(axisLayer)
        }
    }

    private func renderCriterionLabels(center: CGPoint, radius: CGFloat) {
        let labelDistance = radius + 30

        for (vertexIndex, labelText) in criterionLabels.enumerated() {
            let angle = calculateRadianAngle(for: vertexIndex)
            let labelCenter = calculateCoordinate(center: center, radius: labelDistance, angle: angle)

            let textLayer = CATextLayer()
            textLayer.string = labelText
            textLayer.fontSize = DimensionalAdaptation.calibratedTypography(12)
            textLayer.foregroundColor = ChromaticPalette.foregroundPearl.cgColor
            textLayer.alignmentMode = .center
            textLayer.contentsScale = UIScreen.main.scale

            let labelSize = (labelText as NSString).size(withAttributes: [
                .font: UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(12))
            ])

            textLayer.frame = CGRect(
                x: labelCenter.x - labelSize.width / 2,
                y: labelCenter.y - labelSize.height / 2,
                width: labelSize.width,
                height: labelSize.height
            )

            canvasLayer.addSublayer(textLayer)
        }
    }

    private func renderContenderPolygon(dataset: (appellation: String, valuations: [Double], chroma: UIColor), center: CGPoint, radius: CGFloat) {
        let polygonPath = UIBezierPath()

        for (vertexIndex, valuation) in dataset.valuations.enumerated() {
            let angle = calculateRadianAngle(for: vertexIndex)
            let vertexRadius = radius * CGFloat(valuation)
            let point = calculateCoordinate(center: center, radius: vertexRadius, angle: angle)

            if vertexIndex == 0 {
                polygonPath.move(to: point)
            } else {
                polygonPath.addLine(to: point)
            }
        }

        polygonPath.close()

        let fillLayer = CAShapeLayer()
        fillLayer.path = polygonPath.cgPath
        fillLayer.fillColor = dataset.chroma.withAlphaComponent(0.15).cgColor
        fillLayer.strokeColor = dataset.chroma.cgColor
        fillLayer.lineWidth = 2.5
        canvasLayer.addSublayer(fillLayer)

        for (vertexIndex, valuation) in dataset.valuations.enumerated() {
            let angle = calculateRadianAngle(for: vertexIndex)
            let vertexRadius = radius * CGFloat(valuation)
            let point = calculateCoordinate(center: center, radius: vertexRadius, angle: angle)

            let dotLayer = CAShapeLayer()
            dotLayer.path = UIBezierPath(
                arcCenter: point,
                radius: 4,
                startAngle: 0,
                endAngle: .pi * 2,
                clockwise: true
            ).cgPath
            dotLayer.fillColor = dataset.chroma.cgColor
            canvasLayer.addSublayer(dotLayer)
        }
    }

    private func calculateRadianAngle(for vertexIndex: Int) -> CGFloat {
        let totalVertices = criterionLabels.count
        return CGFloat(vertexIndex) * (2 * .pi / CGFloat(totalVertices)) - .pi / 2
    }

    private func calculateCoordinate(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
        )
    }
}
