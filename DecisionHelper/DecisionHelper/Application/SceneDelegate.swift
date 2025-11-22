import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Handle OpenInstall user activities (preserve original functionality)
        for userActivity in connectionOptions.userActivities {
            OpenInstallSDK.continue(userActivity)
        }

        // Create window
        let window = UIWindow(windowScene: windowScene)

        // Set dark mode (based on original code)
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .dark
        }

        // Use original TabBar coordinator to preserve all functionality
        let tabBarCoordinator = PrincipalTabBarCoordinator()
        window.rootViewController = tabBarCoordinator
        window.makeKeyAndVisible()
        self.window = window
    }

    // MARK: - OpenInstall (preserve original functionality)
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        OpenInstallSDK.continue(userActivity)
    }

    // MARK: - Scene Lifecycle
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when scene is disconnected
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when scene becomes active
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when scene will become inactive
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called when scene will enter foreground
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called when scene enters background
    }
}
