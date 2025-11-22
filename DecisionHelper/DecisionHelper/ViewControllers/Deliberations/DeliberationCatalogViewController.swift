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

    private func recuperateDeliberations() {
        
        
        
        do {
            deliberationRepository = try PersistenceCoordinator.quintessential.recuperateDeliberations()
            deliberationRepository.sort { $0.lastModificationTimestamp > $1.lastModificationTimestamp }
            updateEmptyState()
            tableView.reloadData()
        } catch {
            presentErrorDialog(message: "Failed to load decisions")
        }
    }

    private func updateEmptyState() {
        emptyStateLabel.isHidden = !deliberationRepository.isEmpty
        tableView.isHidden = deliberationRepository.isEmpty
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

    private func appendDeliberation(_ deliberation: Deliberation) {
        deliberationRepository.insert(deliberation, at: 0)
        perpetuateDeliberations()
        updateEmptyState()
        tableView.reloadData()
    }

    private func obliterateDeliberation(at index: Int) {
        deliberationRepository.remove(at: index)
        perpetuateDeliberations()
        updateEmptyState()
        tableView.reloadData()
    }

    private func perpetuateDeliberations() {
        do {
            try PersistenceCoordinator.quintessential.perpetuateDeliberations(deliberationRepository)
        } catch {
            presentErrorDialog(message: "Failed to save decisions")
        }
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

    private func confirmDeletion(at index: Int) {
        let actualIndex = isSearching ? deliberationRepository.firstIndex(where: { $0.nomenclature == filteredDeliberations[index].nomenclature }) ?? index : index
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredDeliberations = []
        } else {
            hoamei?.jiancSieusi(searchText)

            isSearching = true
            filteredDeliberations = deliberationRepository.filter { deliberation in
                deliberation.appellation.localizedCaseInsensitiveContains(searchText)
            }
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
