// 
//  UserListViewController.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/8.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

class UserListViewController: UIViewController {

    // MARK: Property

    var viewModel: UserListViewModelPrototype?

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        let vm = UserListViewModel(userListAPI: UserListAPI())
        viewModel = vm
        
        guard let viewModel = viewModel else { return }
        bind(viewModel)
    }

    // MARK: Private property
    
    private lazy var searchController = UISearchController(searchResultsController: UserSearchResultViewController())
    private var userList = [UserModel]()
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension UserListViewController {

    func setupUI() {
        configureNavigationController()
        configureTableView()
    }
    
    func configureNavigationController() {
        let label = UILabel()
        label.text = "GitHub"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        navigationItem.leftBarButtonItem = .init(customView: label)
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserTableViewCell.self)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Table view
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UserTableViewCell.use(table: tableView, for: indexPath)
        let model = userList[indexPath.row]
        
        if let imgURL = model.avatarURL {
            cell.avatarImageView.kf.setImage(with: URL(string: imgURL))
        }
        
        cell.titleLabel.text = model.login
        cell.subtitleLabel.text = model.type
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
}

// MARK: - Search Controller Delegate
extension UserListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel?.input.filterUser(text)
    }
}

// MARK: - Binding

private extension UserListViewController {

    func bind(_ viewModel: UserListViewModelPrototype) {
        viewModel
            .output
            .models
            .withUnretained(self)
            .subscribe(onNext: { owner, models in
                owner.userList = models
                owner.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .searchResult
            .withUnretained(self)
            .subscribe(onNext: { owner, searchResult in
                guard let searchResultVC = owner.searchController.searchResultsController as? UserSearchResultViewController else {
                    return
                }
                searchResultVC.searchList.accept(searchResult)
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .asDriver()
            .drive(onNext: {
                [weak self] indexPath in
                guard let self = self,
                      let username = self.userList[indexPath.row].login else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let vc = UserDetailViewController()
                let vm = UserDetailViewModel(username: username, userDetailAPI: UserDetailAPI())
                vc.viewModel = vm
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
