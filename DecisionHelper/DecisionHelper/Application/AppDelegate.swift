import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, OpenInstallDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize OpenInstall SDK (preserve original functionality)
        OpenInstallSDK.initWith(self)

        // Configure IQKeyboardManager
        IQKeyboardManager.shared.resignOnTouchOutside = true

        // Configure global appearance
        configureAppearance()

        return true
    }

    // MARK: - Private Methods
    private func configureAppearance() {
        // Configure navigation bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = ChromaticPalette.backgroundObsidian
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: ChromaticPalette.foregroundIvory]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: ChromaticPalette.foregroundIvory]

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance

        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = ChromaticPalette.backgroundCharcoal

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when scene sessions are discarded
    }

    // MARK: - OpenInstall (preserve original functionality)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        OpenInstallSDK.continue(userActivity)
        return true
    }
}
