//
// Created on 2022/5/17.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class UserSearchResultViewController: UIViewController {

    let searchList = BehaviorRelay<[UserModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bind()
    }
    
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()

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

extension UserSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserTableViewCell.use(table: tableView, for: indexPath)
        let model = searchList.value[indexPath.row]
        
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

extension UserSearchResultViewController {
    func bind() {
        searchList
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .asDriver()
            .drive(onNext: {
                [weak self] indexPath in
                guard let self = self,
                      let username = self.searchList.value[indexPath.row].login else { return }
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
