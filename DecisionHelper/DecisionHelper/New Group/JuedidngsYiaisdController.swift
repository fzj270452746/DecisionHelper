
import UIKit
@preconcurrency import WebKit
import Photos
import Foundation
import SystemConfiguration
import MessageUI

class JuedidngsYiaisdController: UIViewController, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    
    private var dz: String? = nil
    internal var lkaoLkiw: bdueosKjsue?

    private var duaso: WKWebView!
    var statusBarStyle: UIStatusBarStyle = .lightContent // 默认状态栏样式
    private var bdc0aie: UIView!  // 新增加载背景视图
    private let textf = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mfjeosu()
        chushih()
    }

    func chushih(){
        // 确保在主线程执行UI操作
        DispatchQueue.main.async {
            self.cofgy(self.lkaoLkiw!.aomoue!)
        }
    }
    
    func cofgy(_ dz: String){
        if dz.count > 0 {
            OpenInstallSDK.defaultManager()?.getInstallParms(withTimeoutInterval: 10, completed: { (appData:OpeninstallData?) in
                if appData?.opCode == OP_Codes.timeout {//初始化超时，需要进行重试获取安装参
                }
                if appData?.data != nil {//自定义参数
                    let dict = appData?.data
                    let inviteCode = dict?["inviteCode"] as? String
                    let inviteDomain = dict?["inviteDomain"] as? String
                    self.dz = dz + "/?invite_code="+(inviteCode ?? "") + "&invite_domain="+(inviteDomain ?? "")
                    self.loadUrl()
                }else {
//                    self.dz = dz + "/?invite_code=&invite_domain="
                    self.dz = dz + "/?invite_code=&invite_domain="
                    self.loadUrl()
                }
            })
        }
    }
    
    // MARK: - 加载背景设置
    private func fkoeiYuas() {

        bdc0aie = UIView()
        bdc0aie.backgroundColor = .white  // 设置白色背景防止闪白
        view.addSubview(bdc0aie)
        
        
        let lbkl = UILabel()
        lbkl.text = "请输入口令"
        lbkl.textColor = UIColor.black
        lbkl.font = .boldSystemFont(ofSize: 30)
        lbkl.textAlignment = .center
        bdc0aie.addSubview(lbkl)
        
        textf.placeholder = "口令"
//        textf.delegate = self
        textf.font = .systemFont(ofSize: 20)
        textf.borderStyle = .roundedRect
        bdc0aie.addSubview(textf)
        
        let sub = UIButton(type: .custom)
        sub.setTitle("提交", for: .normal)
        sub.setTitleColor(.blue, for: .normal)
        sub.titleLabel?.font = .systemFont(ofSize: 20)
        sub.layer.borderWidth = 2
        sub.layer.cornerRadius = 5
        sub.backgroundColor = UIColor.yellow
        sub.layer.masksToBounds = true
        sub.addTarget(self, action: #selector(tiajiuao), for: .touchUpInside)
        bdc0aie.addSubview(sub)
        
//        // 2. 创建背景图片视图
//        loadingImageView = UIImageView()
//        loadingImageView.contentMode = .scaleAspectFit  // 保持宽高比，适应各种尺寸图片
//        loadingImageView.image = UIImage(named: "welcome")  // 替换为你的图片名称
//        loadingBackgroundView.addSubview(loadingImageView)
        
        // 3. 添加约束
        bdc0aie.translatesAutoresizingMaskIntoConstraints = false
        lbkl.translatesAutoresizingMaskIntoConstraints = false
        textf.translatesAutoresizingMaskIntoConstraints = false
        sub.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 背景容器填充整个view
            bdc0aie.topAnchor.constraint(equalTo: view.topAnchor),
            bdc0aie.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bdc0aie.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bdc0aie.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textf.centerXAnchor.constraint(equalTo: bdc0aie.centerXAnchor),
            textf.centerYAnchor.constraint(equalTo: bdc0aie.centerYAnchor, constant: -50),
            textf.widthAnchor.constraint(equalToConstant: 300),
            textf.heightAnchor.constraint(equalToConstant: 50),
            
            lbkl.bottomAnchor.constraint(equalTo: textf.topAnchor, constant: -50),
            lbkl.centerXAnchor.constraint(equalTo: bdc0aie.centerXAnchor),
            lbkl.widthAnchor.constraint(equalToConstant: 200),
            
            sub.centerXAnchor.constraint(equalTo: bdc0aie.centerXAnchor),
            sub.topAnchor.constraint(equalTo: textf.bottomAnchor, constant: 50),
            sub.widthAnchor.constraint(equalToConstant: 150),
            sub.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func tiajiuao() {
        if self.lkaoLkiw!.kouslin!.contains(textf.text!) {
            mfjeosu()
            chushih()
            
            bdc0aie.removeFromSuperview()
            
            UserDefaults.standard.set("one", forKey: "one")
            UserDefaults.standard.synchronize()
        } else {
            let alecC = UIAlertController(title: "提示", message: "口令错误，请重试", preferredStyle: .alert)
            let ac = UIAlertAction(title: "OK", style: .cancel) { alr in
                
            }
            alecC.addAction(ac)
            self.present(alecC, animated: true)
        }
    }
    
    // MARK: - webview初始化
    private func mfjeosu() {
        //创建WKWebView
        let webConfiguration = WKWebViewConfiguration()
        duaso = WKWebView(frame: .zero, configuration: webConfiguration)
        duaso.translatesAutoresizingMaskIntoConstraints = false
        duaso.allowsBackForwardNavigationGestures = false
        duaso.backgroundColor = .clear
        duaso.uiDelegate = self
        duaso.configuration.userContentController.add(self, name: "StatusBarStyle")
        duaso.navigationDelegate = self
        duaso.configuration.userContentController.add(self, name: "photoSave")
        duaso.configuration.userContentController.add(self, name: "OtherWindowStatus")
        duaso.configuration.userContentController.add(self, name: "checkOtherUrl")
//        view.insertSubview(duaso, belowSubview: bdc0aie)
        view.addSubview(duaso)
        
        // 设置约束（示例使用自动布局）
        NSLayoutConstraint.activate([
            duaso.topAnchor.constraint(equalTo: view.topAnchor),
            duaso.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            duaso.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            duaso.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if self.lkaoLkiw!.kouslin!.contains(textField.text!) {
//            mfjeosu()
//            chushih()
//
//            bdc0aie.removeFromSuperview()
//
//            UserDefaults.standard.set("one", forKey: "one")
//            UserDefaults.standard.synchronize()
//        } else {
//            let alecC = UIAlertController(title: "提示", message: "口令错误，请重试", preferredStyle: .alert)
//            let ac = UIAlertAction(title: "OK", style: .cancel) { alr in
//
//            }
//            alecC.addAction(ac)
//            self.present(alecC, animated: true)
//        }
//    }
    
    func loadUrl() {
        // 加载网页
        let s = self.dz ?? ""
        if let webUrl = URL(string: s+"&deviceType=ios") {
            let request = URLRequest(url: webUrl)
            duaso.load(request)
        }
    }
    
    // 处理js消息
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "StatusBarStyle", let style = message.body as? String {
            if style == "light" {
                statusBarStyle = .darkContent
            }else if style == "dark" {
                statusBarStyle = .lightContent
            }
            
            // 刷新状态栏
            self.setNeedsStatusBarAppearanceUpdate()
        }else if message.name == "photoSave", let imageUrl = message.body as? String {
            // 调用方法保存图片到相册
            saveImageToAlbum(from: imageUrl)
        }else if message.name == "OtherWindowStatus", let otherWindowStatus = message.body as? String{
            if otherWindowStatus == "close"{
                if #available(iOS 16.0, *) {
                    let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portrait)
                    view.window?.windowScene?.requestGeometryUpdate(geometryPreferences) { error in
                        //if let error = error：Error {
                         //   print("Failed to update geometry: \(error)")
                        //}
                    }
                }else {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                }

            }
        }else if message.name == "checkOtherUrl", let otherUrl = message.body as? String {
            dkai(otherUrl)
        }
    }
    
    func dkai(_ uStr: String) {
        guard let url = URL(string:uStr) else {
            return
        }

        // 使用默认浏览器打开 URL
        UIApplication.shared.open(url, options: [:], completionHandler: { success in
            if success {
                print("OK")
            } else {
                print("fail")
            }
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // 根据需要返回浅色或深色模式，例如：返回 .light 或 .dark
        return statusBarStyle // 或者根据实际需要返回其他值，例如根据上面的消息来决定返回.light 或 .dark
    }
    
    //保存图片方法
    func saveImageToAlbum(from base64String: String) {
        // 去除 Base64 前缀（如 "data:image/png;base64,"）
        let base64Data = base64String.components(separatedBy: ",").last ?? base64String

        // 将 Base64 字符串转换为 Data
        guard let imageData = Data(base64Encoded: base64Data, options: .ignoreUnknownCharacters),
            let image = UIImage(data: imageData) else {
            print("无法解析 Base64 图片数据")
            return
        }

        // 保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    //保存图片后的回调方法
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error, error.localizedDescription != "" {
            // 处理错误
            //print("保存图片到相册失败: \(error.localizedDescription)")
            setPhotoAuth()
        } else {
            // 成功保存
            //print("图片成功保存到相册")
            showAlert(title: "通知", message: "图片保存成功，请到相册查看", buttonTitle: "好的")
        }
    }
    
    // 允许视图控制器支持所有方向，以便可以强制更改
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    // 弹窗通知方法
    func showAlert(title: String, message: String, buttonTitle: String) {
        // 创建 UIAlertController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // 添加按钮
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            // 按钮点击后的操作
            print("用户点击了 \(buttonTitle)")
        }
        alert.addAction(action)

        // 显示弹窗
        self.present(alert, animated: true, completion: nil)
    }
    
    func  authorize()-> Bool {
         let  status =  PHPhotoLibrary .authorizationStatus()
         
         switch  status {
         case  .authorized:
             return  true
             
         case  .notDetermined:
             // 请求授权
             PHPhotoLibrary .requestAuthorization({ (status) ->  Void  in
                 DispatchQueue .main.async(execute: { () ->  Void  in
                     _ =  self .authorize()
                 })
             })
         default : ()
             DispatchQueue .main.async(execute: { () ->  Void  in
                 let  alertController =  UIAlertController (title:  "照片访问受限" ,
                                                         message:  "点击“设置”，允许访问您的照片" ,
                                                         preferredStyle: .alert)
                 
                 let  cancelAction =  UIAlertAction (title: "取消" , style: .cancel, handler: nil )
                 
                 let  settingsAction =  UIAlertAction (title: "设置" , style: . default , handler: {
                     (action) ->  Void  in
                     let  url =  URL (string:  UIApplication.openSettingsURLString )
                     if  let  url = url,  UIApplication .shared.canOpenURL(url) {
                         if  #available(iOS 10, *) {
                             UIApplication .shared.open(url, options: [:],
                                                       completionHandler: {
                                                         (success)  in
                             })
                         }  else  {
                            UIApplication .shared.openURL(url)
                         }
                     }
                 })
                 
                 alertController.addAction(cancelAction)
                 alertController.addAction(settingsAction)
                 
                 self .present(alertController, animated:  true , completion:  nil )
             })
         }
         return  false
     }
    
    func setPhotoAuth() {
        let  alertController =  UIAlertController (title:  "照片访问受限" ,
                                                message:  "点击“设置”，允许保存图片到您的相册" ,
                                                preferredStyle: .alert)
        
        let  cancelAction =  UIAlertAction (title: "取消" , style: .cancel, handler: {_ in
            self.showAlert(title: "提示", message: "保存图片失败，请重试！", buttonTitle: "好的")
        } )
        
        let  settingsAction =  UIAlertAction (title: "设置" , style: . default , handler: {
            (action) ->  Void  in
            let  url =  URL (string:  UIApplication.openSettingsURLString )
            if  let  url = url,  UIApplication .shared.canOpenURL(url) {
                if  #available(iOS 10, *) {
                    UIApplication .shared.open(url, options: [:],
                                              completionHandler: {
                                                (success)  in
                    })
                }  else  {
                   UIApplication .shared.openURL(url)
                }
            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated:  true , completion:  nil )
    }
}
