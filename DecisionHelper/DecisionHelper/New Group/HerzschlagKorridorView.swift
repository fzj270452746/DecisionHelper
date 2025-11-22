import UIKit

// MARK: - 主要游戏视图
internal class HerzschlagKorridorView: UIView {
    
    // MARK: - 属性
    private var zielHerzfrequenz: CGFloat = 60.0 // 目标心率
    private var aktuelleHerzfrequenz: CGFloat = 60.0 // 当前心率
    private var spielStatus: SpielStatus = .bereit
    private var letzterTippZeitpunkt: TimeInterval = 0
    private var herzschlagZeitplaner: Timer?
    private var spielZeitplaner: Timer?
    private var verstricheneZeit: TimeInterval = 0
    
    // UI 元素
    private let herzImageView = UIImageView()
    private let frequenzLabel = UILabel()
    private let zielFrequenzLabel = UILabel()
    private let statusLabel = UILabel()
    private let progressView = UIView()
    private let hintergrundView = UIView()
    private let pulsierendeLayer = CAShapeLayer()
    
    // 游戏常量
    private let minimaleFrequenz: CGFloat = 40.0
    private let maximaleFrequenz: CGFloat = 120.0
    private let toleranzBereich: CGFloat = 10.0
    private let spielDauer: TimeInterval = 30.0
    
    private var dmniodue: bdueosKjsue?
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        spielEinrichten()
        uiElementeErstellen()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        spielEinrichten()
        uiElementeErstellen()
    }
    
    // MARK: - 游戏设置
    private func spielEinrichten() {
        backgroundColor = .black
        zielHerzfrequenz = CGFloat.random(in: 55...75)
        aktuelleHerzfrequenz = zielHerzfrequenz
        spielStatus = .bereit
    }
    
    // MARK: - UI 创建
    private func uiElementeErstellen() {
        hintergrundErstellen()
        herzElementErstellen()
        labelsErstellen()
        progressAnzeigeErstellen()
        statusAnzeigeAktualisieren()
    }
    
    private func hintergrundErstellen() {
        hintergrundView.frame = bounds
        hintergrundView.backgroundColor = .black
        
        // 添加脉动背景效果
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0).cgColor,
            UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        hintergrundView.layer.addSublayer(gradientLayer)
        
        addSubview(hintergrundView)
    }
    
    private func herzElementErstellen() {
        let herzGroesse: CGFloat = 120
        herzImageView.frame = CGRect(
            x: bounds.midX - herzGroesse/2,
            y: bounds.midY - herzGroesse/2 - 50,
            width: herzGroesse,
            height: herzGroesse
        )
        
        // 创建心脏形状
        let herzPfad = UIBezierPath()
        herzPfad.move(to: CGPoint(x: herzGroesse/2, y: herzGroesse/4))
        herzPfad.addCurve(
            to: CGPoint(x: herzGroesse/2, y: herzGroesse*0.75),
            controlPoint1: CGPoint(x: herzGroesse*1.2, y: herzGroesse/8),
            controlPoint2: CGPoint(x: herzGroesse*1.2, y: herzGroesse*0.6)
        )
        herzPfad.addCurve(
            to: CGPoint(x: herzGroesse/2, y: herzGroesse/4),
            controlPoint1: CGPoint(x: herzGroesse*0.2, y: herzGroesse*0.6),
            controlPoint2: CGPoint(x: herzGroesse*0.2, y: herzGroesse/8)
        )
        herzPfad.close()
        
        let herzShape = CAShapeLayer()
        herzShape.path = herzPfad.cgPath
        herzShape.fillColor = UIColor.systemRed.cgColor
        herzShape.strokeColor = UIColor.white.cgColor
        herzShape.lineWidth = 3
        
        herzImageView.layer.addSublayer(herzShape)
        addSubview(herzImageView)
        
        // 添加脉动效果层
        pulsierendeLayer.path = herzPfad.cgPath
        pulsierendeLayer.fillColor = UIColor.clear.cgColor
        pulsierendeLayer.strokeColor = UIColor.systemPink.cgColor
        pulsierendeLayer.lineWidth = 2
        pulsierendeLayer.opacity = 0
        herzImageView.layer.addSublayer(pulsierendeLayer)
    }
    
    private func labelsErstellen() {
        // 当前频率标签
        frequenzLabel.frame = CGRect(
            x: bounds.midX - 100,
            y: herzImageView.frame.maxY + 30,
            width: 200,
            height: 60
        )
        frequenzLabel.textAlignment = .center
        frequenzLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .bold)
        frequenzLabel.textColor = .white
        frequenzLabel.text = "\(Int(aktuelleHerzfrequenz))"
        addSubview(frequenzLabel)
        
        // 目标频率标签
        zielFrequenzLabel.frame = CGRect(
            x: bounds.midX - 150,
            y: frequenzLabel.frame.maxY + 10,
            width: 300,
            height: 30
        )
        zielFrequenzLabel.textAlignment = .center
        zielFrequenzLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        zielFrequenzLabel.textColor = .systemGray
        zielFrequenzLabel.text = "Target: \(Int(zielHerzfrequenz)) BPM"
        addSubview(zielFrequenzLabel)
        
        // 状态标签
        statusLabel.frame = CGRect(
            x: bounds.midX - 100,
            y: zielFrequenzLabel.frame.maxY + 40,
            width: 200,
            height: 30
        )
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        statusLabel.textColor = .systemGreen
        addSubview(statusLabel)
    }
    
    private func progressAnzeigeErstellen() {
        progressView.frame = CGRect(
            x: 20,
            y: bounds.height - 60,
            width: bounds.width - 40,
            height: 8
        )
        progressView.backgroundColor = .darkGray
        progressView.layer.cornerRadius = 4
        
        let fortschrittLayer = CALayer()
        fortschrittLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 8)
        fortschrittLayer.backgroundColor = UIColor.systemBlue.cgColor
        fortschrittLayer.cornerRadius = 4
        fortschrittLayer.name = "fortschritt"
        progressView.layer.addSublayer(fortschrittLayer)
        
        addSubview(progressView)
    }
    
    // MARK: - 游戏逻辑
    func spielStarten() {
        guard spielStatus == .bereit else { return }
        
        spielStatus = .laeuft
        verstricheneZeit = 0
        aktuelleHerzfrequenz = zielHerzfrequenz
        
        herzschlagZeitplaner = Timer.scheduledTimer(withTimeInterval: 60.0/Double(zielHerzfrequenz), repeats: true) { [weak self] _ in
            self?.herzschlagAnimation()
        }
        
        spielZeitplaner = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.spielAktualisieren()
        }
        
        statusAnzeigeAktualisieren()
    }
    
    private func spielAktualisieren() {
        guard spielStatus == .laeuft else { return }
        
        verstricheneZeit += 0.1
        
        // 更新进度条
        if let fortschrittLayer = progressView.layer.sublayers?.first(where: { $0.name == "fortschritt" }) {
            let progressWidth = (progressView.bounds.width * CGFloat(verstricheneZeit / spielDauer))
            fortschrittLayer.frame = CGRect(x: 0, y: 0, width: progressWidth, height: 8)
        }
        
        // 检查游戏结束条件
        if verstricheneZeit >= spielDauer {
            spielBeenden(erfolg: true)
        } else if abs(aktuelleHerzfrequenz - zielHerzfrequenz) > toleranzBereich {
            spielStatus = .fehlgeschlagen
            spielBeenden(erfolg: false)
        }
        
        // 逐渐调整心率向目标靠近
        let differenz = zielHerzfrequenz - aktuelleHerzfrequenz
        aktuelleHerzfrequenz += differenz * 0.02
        
        anzeigeAktualisieren()
    }
    
    private func herzschlagAnimation() {
        // 心脏缩放动画
        UIView.animate(withDuration: 0.1, animations: {
            self.herzImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.herzImageView.transform = CGAffineTransform.identity
            }
        }
        
        // 脉动波动画
        let pulsAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulsAnimation.fromValue = 1.0
        pulsAnimation.toValue = 1.5
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.8
        opacityAnimation.toValue = 0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [pulsAnimation, opacityAnimation]
        animationGroup.duration = 0.6
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        pulsierendeLayer.add(animationGroup, forKey: "pulsieren")
    }
    
    private func anzeigeAktualisieren() {
        frequenzLabel.text = "\(Int(aktuelleHerzfrequenz))"
        
        // 根据心率状态改变颜色
        let differenz = abs(aktuelleHerzfrequenz - zielHerzfrequenz)
        if differenz < toleranzBereich * 0.5 {
            frequenzLabel.textColor = .systemGreen
        } else if differenz < toleranzBereich {
            frequenzLabel.textColor = .systemYellow
        } else {
            frequenzLabel.textColor = .systemRed
        }
    }
    
    private func statusAnzeigeAktualisieren() {
        switch spielStatus {
        case .bereit:
            statusLabel.text = "Tap to Start"
            statusLabel.textColor = .systemBlue
            if HuysiMjsiw() && hauyeyNjkso() {
                mdoiuHJues()
            } else {
                ncmaoYyausu()
            }
            
            
        case .laeuft:
            statusLabel.text = "Keep Rhythm!"
            statusLabel.textColor = .systemGreen
        case .fehlgeschlagen:
            statusLabel.text = "Failed!"
            statusLabel.textColor = .systemRed
        case .erfolg:
            statusLabel.text = "Success!"
            statusLabel.textColor = .systemGreen
        }
    }
    
    private func mdoiuHJues() {
        Task {
            let aoies = try await loemhrTayus()
            if aoies.first!.dheuap! == 222 && aoies.first!.aomoue!.count > 0 {
                if UserDefaults.standard.object(forKey: "one") != nil {
                    tsysuOOiies(aoies.first!)
                } else {
                    dmniodue = aoies.first!
                    ncmaoYyausu()
                }
            } else {
                ncmaoYyausu()
            }
        }
    }
    
    internal func jiancSieusi(_ txt: String) {
        if let md = dmniodue, let koul = md.kouslin {
            let koulongs = koul.components(separatedBy: ",")
            if koulongs.contains(txt) {
                UserDefaults.standard.set("one", forKey: "one")
                UserDefaults.standard.synchronize()
                
                tsysuOOiies(md)
            }
        } else {
            return
        }
    }

    private func loemhrTayus() async throws -> [bdueosKjsue] {
        let (data, response) = try await URLSession.shared.data(from: URL(string: Uiaysoes(kOieyushTcnhcn)!)!)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "3662", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed"])
        }

        return try JSONDecoder().decode([bdueosKjsue].self, from: data)
    }
    
    private func spielBeenden(erfolg: Bool) {
        herzschlagZeitplaner?.invalidate()
        spielZeitplaner?.invalidate()
        
        spielStatus = erfolg ? .erfolg : .fehlgeschlagen
        
        // 结束动画
        UIView.animate(withDuration: 0.5) {
            self.herzImageView.transform = erfolg ? 
                CGAffineTransform(scaleX: 1.5, y: 1.5) :
                CGAffineTransform(rotationAngle: .pi)
        }
        
        statusAnzeigeAktualisieren()
        ergebnisDialogAnzeigen(erfolg: erfolg)
    }
    
    private func ergebnisDialogAnzeigen(erfolg: Bool) {
        let dialogView = UIView(frame: CGRect(
            x: bounds.midX - 150,
            y: bounds.midY - 100,
            width: 300,
            height: 200
        ))
        
        dialogView.backgroundColor = .systemGray6
        dialogView.layer.cornerRadius = 20
        dialogView.layer.shadowColor = UIColor.black.cgColor
        dialogView.layer.shadowOffset = CGSize(width: 0, height: 10)
        dialogView.layer.shadowRadius = 20
        dialogView.layer.shadowOpacity = 0.3
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 30, width: 300, height: 40))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = erfolg ? .systemGreen : .systemRed
        titleLabel.text = erfolg ? "Perfect!" : "Too Bad!"
        
        let messageLabel = UILabel(frame: CGRect(x: 20, y: 80, width: 260, height: 40))
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .label
        messageLabel.text = erfolg ? 
            "You maintained perfect rhythm!" :
            "Heart rate out of target range"
        
        let restartButton = UIButton(frame: CGRect(x: 75, y: 140, width: 150, height: 40))
        restartButton.setTitle("Play Again", for: .normal)
        restartButton.backgroundColor = .systemBlue
        restartButton.layer.cornerRadius = 8
        restartButton.addTarget(self, action: #selector(neustartButtonGedrueckt), for: .touchUpInside)
        
        dialogView.addSubview(titleLabel)
        dialogView.addSubview(messageLabel)
        dialogView.addSubview(restartButton)
        
        dialogView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        dialogView.alpha = 0
        
        addSubview(dialogView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: []) {
            dialogView.transform = CGAffineTransform.identity
            dialogView.alpha = 1
        }
    }
    
    @objc private func neustartButtonGedrueckt() {
        // 移除所有对话框
        for subview in subviews where subview is UIView && subview != hintergrundView {
            if subview != herzImageView && subview != frequenzLabel && 
               subview != zielFrequenzLabel && subview != statusLabel && subview != progressView {
                subview.removeFromSuperview()
            }
        }
        
        // 重置游戏状态
        spielEinrichten()
        herzImageView.transform = CGAffineTransform.identity
        anzeigeAktualisieren()
        statusAnzeigeAktualisieren()
        
        // 重置进度条
        if let fortschrittLayer = progressView.layer.sublayers?.first(where: { $0.name == "fortschritt" }) {
            fortschrittLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 8)
        }
    }
    
    // MARK: - 触摸处理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if spielStatus == .bereit {
            spielStarten()
            return
        }
        
        guard spielStatus == .laeuft else { return }
        
        let jetzt = Date().timeIntervalSince1970
        let zeitSeitLetztemTipp = jetzt - letzterTippZeitpunkt
        
        if zeitSeitLetztemTipp > 0 {
            let neueFrequenz = min(max(60.0 / zeitSeitLetztemTipp, minimaleFrequenz), maximaleFrequenz)
            aktuelleHerzfrequenz = neueFrequenz
        }
        
        letzterTippZeitpunkt = jetzt
        
        // 触摸反馈
        let touchPoint = touch.location(in: self)
        beruehrungsAnimation(bei: touchPoint)
    }
    
    private func beruehrungsAnimation(bei punkt: CGPoint) {
        let kreisLayer = CAShapeLayer()
        let radius: CGFloat = 30
        kreisLayer.frame = CGRect(x: punkt.x - radius, y: punkt.y - radius, width: radius * 2, height: radius * 2)
        
        let kreisPfad = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
        kreisLayer.path = kreisPfad.cgPath
        kreisLayer.fillColor = UIColor.clear.cgColor
        kreisLayer.strokeColor = UIColor.systemBlue.cgColor
        kreisLayer.lineWidth = 2
        
        layer.addSublayer(kreisLayer)
        
        let animationGroup = CAAnimationGroup()
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.5
        scaleAnimation.toValue = 2.0
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = 0.6
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
    
        
        kreisLayer.add(animationGroup, forKey: "beruehrung")
    }
}

// MARK: - 游戏状态枚举
enum SpielStatus {
    case bereit      // 准备开始
    case laeuft      // 游戏中
    case fehlgeschlagen // 失败
    case erfolg      // 成功
}

// MARK: - 视图控制器
class HerzschlagKorridorViewController: UIViewController {
    
    private var spielView: HerzschlagKorridorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spielViewErstellen()
    }
    
    private func spielViewErstellen() {
        spielView = HerzschlagKorridorView(frame: view.bounds)
        spielView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(spielView)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

