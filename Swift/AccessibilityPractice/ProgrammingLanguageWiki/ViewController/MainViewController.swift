//
// © 2021. yagom academy all rights reserved
// This tutorial is produced by Yagom Academy and is prohibited from redistributing or reproducing.
//

import UIKit

protocol LikeButtonDelegate {
    func reloadCurrentList()
}

class MainViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var listSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentList = ProgrammingLanguageInfoManager.shared.infoList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        configureSegmentAccessibility()
        configureSearchBarAccessibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listSegmentedControl.selectedSegmentIndex  == 1 {
            mainTableView.reloadData()
        }
    }

    private func setUpDelegate() {
        mainTableView.dataSource = self
        mainTableView.delegate = self
        searchBar.delegate = self
    }
    
    private func updateCurrentListAccordingToSegment() {
        let segmentValue = listSegmentedControl.selectedSegmentIndex == 1
        currentList = ProgrammingLanguageInfoManager.shared.filteredList(isLikeSegment: segmentValue)
    }

    @IBAction func listSegment(_ sender: UISegmentedControl) {
        updateCurrentListAccordingToSegment()
        filterListOutWithSearchBar()
        mainTableView.reloadData()
    }
    
    @IBAction func toggleLikeButton(_ sender: IsLikeButton) {
        sender.updateIsLike()
        sender.updateButtonStatus()
    }
}

// MARK: - UITableView DataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        let item = currentList[indexPath.row]
        let languageIndex = ProgrammingLanguageInfoManager.shared.infoList.firstIndex(of: item)
        
        cell.logoImageView.image = item.logoImage
        cell.nameLabel.text = item.name
        cell.isLikeButton.languageIndex = languageIndex
        cell.isLikeButton.updateButtonStatus()
        configureTableViewCellAccessibility(cell: cell, language: item)
        
        return cell
    }
    private func configureSearchBarAccessibility() {
           searchBar.searchTextField.accessibilityLabel = "검색 입력 칸"
           searchBar.searchTextField.accessibilityIdentifier = "MainViewController.searchBar"
           searchBar.searchTextField.accessibilityHint = "검색하실 언어를 입력해주세요."
       }
}

// MARK: - UITableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        guard let language = ProgrammingLanguageInfoManager.shared.infoList.filter({ language in
            language.name == currentList[indexPath.row].name
        }).first else { return }

        nextViewController.languageIndex = ProgrammingLanguageInfoManager.shared.infoList.firstIndex(of: language)
        nextViewController.likeButtonDelegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
        self.view.endEditing(true)
    }
}

// MARK: - UISearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterListOutWithSearchBar()
        mainTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func filterListOutWithSearchBar() {
        guard let input = searchBar.text, searchBar.text != "" else {
            updateCurrentListAccordingToSegment()
            mainTableView.reloadData()
            return
        }
        
        currentList = currentList.filter {
            $0.name.lowercased().contains(input.lowercased())
        }
    }
}

// MARK: - Keyboard Control
extension MainViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - LikeButton Delegate
extension MainViewController: LikeButtonDelegate {
    func reloadCurrentList() {
        updateCurrentListAccordingToSegment()
        filterListOutWithSearchBar()
    }
}

// MARK: - Accessibility
extension MainViewController {
    private func configureSegmentAccessibility() {
        listSegmentedControl.subviews[1].accessibilityLabel = "모든 항목 보기"
        listSegmentedControl.subviews[1].accessibilityIdentifier = "MainViewController.listSegmentControl.subview[1]"

        listSegmentedControl.subviews[0].accessibilityLabel = "즐겨찾기 항목 보기"
        listSegmentedControl.subviews[0].accessibilityIdentifier = "MainViewController.listSegmentControl.subview[0]"
    }
    
    private func configureTableViewCellAccessibility(cell: UITableViewCell, language: ProgrammingLanguageInfo) {
           cell.isAccessibilityElement = true
           cell.accessibilityLabel = "\(language.name) 언어 보기"
           cell.accessibilityTraits = .button
           cell.accessibilityIdentifier = "MainViewController.\(language.name)collectionViewCell"
           cell.accessibilityHint = "상세 페이지로 이동합니다."
       }
}

