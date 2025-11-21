import UIKit

class PrincipalTabBarCoordinator: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureViewControllers()
    }

    private func configureAppearance() {
        view.backgroundColor = ChromaticPalette.backgroundObsidian
        tabBar.backgroundColor = ChromaticPalette.backgroundCharcoal
        tabBar.tintColor = ChromaticPalette.primaryAzure
        tabBar.unselectedItemTintColor = ChromaticPalette.foregroundAsh
        tabBar.isTranslucent = false

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = ChromaticPalette.backgroundCharcoal
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }

    private func configureViewControllers() {
        let deliberationsNavController = generateNavigationController(
            rootViewController: DeliberationCatalogViewController(),
            iconSystemDesignation: "list.bullet.clipboard",
            appellation: "Decisions"
        )

        let rapidNavController = generateNavigationController(
            rootViewController: RapidDeliberationViewController(),
            iconSystemDesignation: "bolt.circle.fill",
            appellation: "Rapid"
        )

        let archiveNavController = generateNavigationController(
            rootViewController: PersonalArchiveViewController(),
            iconSystemDesignation: "archivebox.fill",
            appellation: "Archive"
        )

        viewControllers = [deliberationsNavController, rapidNavController, archiveNavController]
    }

    private func generateNavigationController(rootViewController: UIViewController, iconSystemDesignation: String, appellation: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)

        navController.tabBarItem = UITabBarItem(
            title: appellation,
            image: UIImage(systemName: iconSystemDesignation),
            tag: 0
        )

        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.tintColor = ChromaticPalette.primaryAzure

        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = ChromaticPalette.backgroundObsidian
            appearance.titleTextAttributes = [.foregroundColor: ChromaticPalette.foregroundIvory]
            appearance.largeTitleTextAttributes = [.foregroundColor: ChromaticPalette.foregroundIvory]
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navController.navigationBar.barTintColor = ChromaticPalette.backgroundObsidian
            navController.navigationBar.titleTextAttributes = [.foregroundColor: ChromaticPalette.foregroundIvory]
            navController.navigationBar.largeTitleTextAttributes = [.foregroundColor: ChromaticPalette.foregroundIvory]
        }

        return navController
    }
}
