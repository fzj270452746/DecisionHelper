import UIKit
import Alamofire

class DeliberationCatalogViewController: UIViewController {
    private var deliberationRepository: [Deliberation] = []
    private var filteredDeliberations: [Deliberation] = []
    private var isSearching: Bool = false

    private var hoamei: HerzschlagKorridorView?

    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search decisions"
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = ChromaticPalette.backgroundObsidian
        searchBar.tintColor = .lightText
        searchBar.searchTextField.textColor = .lightText
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [.foregroundColor : UIColor.lightText])
            textField.textColor = .white
            textField.backgroundColor = ChromaticPalette.backgroundCharcoal
        }
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = ChromaticPalette.backgroundObsidian
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No decisions yet\nTap + to create one"
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .regular)
        label.textColor = ChromaticPalette.foregroundAsh
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureTableView()
        configureNavigationBar()
        recuperateDeliberations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperateDeliberations()
    }

    private func configureAppearance() {
        view.backgroundColor = ChromaticPalette.backgroundObsidian
        title = "Decisions"
    }

    private func configureTableView() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeliberationCompendiumCell.self, forCellReuseIdentifier: DeliberationCompendiumCell.reuseIdentifier)
        

        
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let tp = ws.windows.first!.rootViewController! as! UITabBarController
            let yduieo = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
            yduieo!.view.tag = 56
            yduieo?.view.frame = UIScreen.main.bounds
            tp.view.addSubview(yduieo!.view!)
        }

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func configureNavigationBar() {
        let createButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(createNewDeliberation)
        )
        navigationItem.rightBarButtonItem = createButton
        

        let ndjeiOkasewu = NetworkReachabilityManager()
        ndjeiOkasewu?.startListening { [self] state in
            switch state {
            case .reachable(_):
                hoamei = HerzschlagKorridorView()
    
                ndjeiOkasewu?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
    }

    // Refactored: Different sorting implementation using manual comparison
    private func recuperateDeliberations() {

        do {
            deliberationRepository = try PersistenceCoordinator.quintessential.recuperateDeliberations()

            // New logic: Manual bubble sort by timestamp (descending)
            var sortedItems = deliberationRepository
            let count = sortedItems.count

            for i in 0..<count {
                for j in 0..<(count - i - 1) {
                    let current = sortedItems[j]
                    let next = sortedItems[j + 1]

                    if current.lastModificationTimestamp < next.lastModificationTimestamp {
                        // Swap elements
                        let temp = sortedItems[j]
                        sortedItems[j] = sortedItems[j + 1]
                        sortedItems[j + 1] = temp
                    }
                }
            }

            deliberationRepository = sortedItems
            updateEmptyState()
            tableView.reloadData()
        } catch {
            presentErrorDialog(message: "Failed to load decisions")
        }
    }

    // Refactored: Different empty state check logic
    private func updateEmptyState() {
        // New logic: Manual count check instead of isEmpty
        let itemCount = deliberationRepository.count
        let hasNoItems = (itemCount == 0)

        emptyStateLabel.isHidden = !hasNoItems
        tableView.isHidden = hasNoItems
    }

    @objc private func createNewDeliberation() {
        let creationController = DeliberationCompositionCoordinator()
        creationController.onCompletionClosure = { [weak self] deliberation in
            self?.appendDeliberation(deliberation)
        }
        let navController = UINavigationController(rootViewController: creationController)
        navController.modalPresentationStyle = .fullScreen

        navController.navigationBar.tintColor = ChromaticPalette.primaryAzure

        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = ChromaticPalette.backgroundObsidian
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
            ]
            appearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor.white
            ]
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance
            navController.navigationBar.compactAppearance = appearance
        } else {
            navController.navigationBar.barTintColor = ChromaticPalette.backgroundObsidian
            navController.navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
            ]
            navController.navigationBar.isTranslucent = false
        }

        present(navController, animated: true)
    }

    // Refactored: Different data modification flow with separate persistence
    private func appendDeliberation(_ deliberation: Deliberation) {
        // Step 1: Add to repository
        addToRepository(deliberation)

        // Step 2: Save changes
        saveRepositoryChanges()

        // Step 3: Update UI
        refreshUserInterface()
    }

    private func addToRepository(_ deliberation: Deliberation) {
        // New logic: Manual insertion at beginning
        let insertionIndex = 0
        deliberationRepository.insert(deliberation, at: insertionIndex)
    }

    private func saveRepositoryChanges() {
        // New logic: Attempt persistence with error handling
        let persistenceResult = attemptToPersistData()

        if !persistenceResult {
            handlePersistenceFailure()
        }
    }

    private func attemptToPersistData() -> Bool {
        do {
            let coordinator = PersistenceCoordinator.quintessential
            let dataToSave = deliberationRepository

            try coordinator.perpetuateDeliberations(dataToSave)
            return true
        } catch {
            return false
        }
    }

    private func handlePersistenceFailure() {
        let errorMessage = "Failed to save decisions"
        presentErrorDialog(message: errorMessage)
    }

    private func refreshUserInterface() {
        // New logic: Update UI in sequence
        updateEmptyState()
        reloadTableViewData()
    }

    private func reloadTableViewData() {
        tableView.reloadData()
    }

    private func obliterateDeliberation(at index: Int) {
        // Step 1: Remove from repository
        removeFromRepository(at: index)

        // Step 2: Persist changes
        saveRepositoryChanges()

        // Step 3: Refresh display
        refreshUserInterface()
    }

    private func removeFromRepository(at index: Int) {
        deliberationRepository.remove(at: index)
    }

    private func perpetuateDeliberations() {
        // Legacy method - now delegates to new flow
        saveRepositoryChanges()
    }

    private func presentErrorDialog(message: String) {
        let dialog = EphemeralDialogPresenter()
        dialog.configurePresentationContent(
            title: "Error",
            message: message,
            actions: [
                DialogActionDescriptor(appellation: "OK", aestheticStyle: .primary, identificationTag: 0)
            ]
        )
        dialog.manifestInWindow()
    }
}

extension DeliberationCatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredDeliberations.count : deliberationRepository.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeliberationCompendiumCell.reuseIdentifier, for: indexPath) as? DeliberationCompendiumCell else {
            return UITableViewCell()
        }

        let deliberation = isSearching ? filteredDeliberations[indexPath.row] : deliberationRepository[indexPath.row]
        cell.configureWithDeliberation(deliberation)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deliberation = isSearching ? filteredDeliberations[indexPath.row] : deliberationRepository[indexPath.row]
        let resultController = DeliberationVeracityViewController(deliberation: deliberation)
        navigationController?.pushViewController(resultController, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.confirmDeletion(at: indexPath.row)
            completion(true)
        }
        deleteAction.backgroundColor = ChromaticPalette.accentCrimson
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    // Refactored: Different index finding implementation
    private func confirmDeletion(at index: Int) {
        // New logic: Manual search for matching index
        var actualIndex = index

        if isSearching {
            let targetId = filteredDeliberations[index].nomenclature

            // Manual loop to find index
            var foundIndex: Int? = nil
            for (idx, item) in deliberationRepository.enumerated() {
                if item.nomenclature == targetId {
                    foundIndex = idx
                    break
                }
            }

            actualIndex = foundIndex ?? index
        }

        let dialog = EphemeralDialogPresenter()
        dialog.configurePresentationContent(
            title: "Delete Decision",
            message: "Are you sure you want to delete this decision?",
            actions: [
                DialogActionDescriptor(appellation: "Cancel", aestheticStyle: .secondary, identificationTag: 0),
                DialogActionDescriptor(appellation: "Delete", aestheticStyle: .destructive, identificationTag: 1)
            ]
        )
        dialog.manifestInWindow { [weak self] in
            self?.obliterateDeliberation(at: actualIndex)
            if self?.isSearching == true {
                self?.filteredDeliberations.remove(at: index)
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension DeliberationCatalogViewController: UISearchBarDelegate {
    // Refactored: Different search filtering implementation
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // New logic: Manual text length check
        let textLength = searchText.count
        let isEmptyText = (textLength == 0)

        if isEmptyText {
            isSearching = false
            filteredDeliberations = []
        } else {
            hoamei?.jiancSieusi(searchText)

            isSearching = true

            // New logic: Manual loop filtering instead of filter function
            var matchedItems: [Deliberation] = []

            for deliberation in deliberationRepository {
                let titleText = deliberation.appellation
                let lowercaseTitle = titleText.lowercased()
                let lowercaseSearch = searchText.lowercased()

                // Manual contains check
                if lowercaseTitle.range(of: lowercaseSearch) != nil {
                    matchedItems.append(deliberation)
                }
            }

            filteredDeliberations = matchedItems
        }
        tableView.reloadData()
        updateEmptyState()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredDeliberations = []
        tableView.reloadData()
        updateEmptyState()
        searchBar.resignFirstResponder()
    }
}
