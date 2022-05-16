// 
//  PersonalInfoViewController.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/8.
//

import UIKit
import RxSwift
import RxCocoa

class PersonalInfoViewController: UIViewController {

    // MARK: Property

    var viewModel: PersonalInfoViewModelPrototype?

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        guard let viewModel = viewModel else { return }

        bind(viewModel)
    }

    // MARK: Private properties
    
    private let bannerImageView = UIImageView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let subLabel = UILabel()
    private let followImageView = UIImageView()
    private let emailImageView = UIImageView()
    private let followLabel = UILabel()
    private let emailLabel = UILabel()
    private let swipeGesture = UISwipeGestureRecognizer()
    private let emailDefault = "champion790713@gmail.com"
    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension PersonalInfoViewController {

    func setupUI() {
        view.backgroundColor = .white
        configureNavigationController()
        configureBannerImageView()
        configureProfileImageView()
        configureNameLabel()
        configureSubLabel()
        configureFollowInfo()
        configureEmailInfo()
        configureSwipeGesture()
    }
    
    func configureNavigationController() {
        let label = UILabel()
        label.text = "GitHub"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        navigationItem.leftBarButtonItem = .init(customView: label)
    }
    
    func configureBannerImageView() {
        view.addSubview(bannerImageView)
        bannerImageView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
        
        bannerImageView.backgroundColor = UIColor(red: 15.0/255.0,
                                                  green: 36.0/255.0,
                                                  blue: 73.0/255.0,
                                                  alpha: 1.0)
        bannerImageView.contentMode = .scaleAspectFill
    }
    
    func configureProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints{
            $0.size.equalTo(100)
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalTo(bannerImageView.snp.bottom)
        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
    }
    
    func configureNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView)
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        nameLabel.font = .boldSystemFont(ofSize: 20)
    }
    
    func configureSubLabel() {
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        subLabel.font = .systemFont(ofSize: 14)
        subLabel.textColor = .lightGray
    }

    func configureFollowInfo() {
        view.addSubview(followImageView)
        followImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.equalTo(subLabel)
            $0.top.equalTo(subLabel.snp.bottom).offset(10)
        }
        followImageView.image = UIImage(named: "people")
        
        view.addSubview(followLabel)
        followLabel.snp.makeConstraints {
            $0.centerY.equalTo(followImageView)
            $0.leading.equalTo(followImageView.snp.trailing).offset(10)
        }
        followLabel.textColor = .lightGray
    }
    
    func configureEmailInfo() {
        view.addSubview(emailImageView)
        emailImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.equalTo(followImageView)
            $0.top.equalTo(followImageView.snp.bottom).offset(10)
        }
        emailImageView.image = UIImage(named: "email")
        
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.centerY.equalTo(emailImageView)
            $0.leading.equalTo(emailImageView.snp.trailing).offset(10)
        }
        emailLabel.textColor = .lightGray
    }
    
    func configureSwipeGesture() {
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
}

// MARK: - Binding

private extension PersonalInfoViewController {

    func bind(_ viewModel: PersonalInfoViewModelPrototype) {
        
        viewModel
            .output
            .model
            .subscribe(onNext: { [weak self] model in
                
                guard let self = self,
                      let imgURL = model.avatarURL else { return }
                
                self.profileImageView.kf.setImage(with: URL(string: imgURL))
                self.nameLabel.text = model.name
                self.subLabel.text = model.login
                self.followLabel.text = "\(model.followers ?? 0) followers, \(model.following ?? 0) following"
                self.emailLabel.text = model.email ?? self.emailDefault
                
            })
            .disposed(by: disposeBag)
        
        swipeGesture
            .rx
            .event
            .subscribe(onNext: { _ in
                viewModel.input.changeSelectedTab()
            })
            .disposed(by: disposeBag)
        
    }
}
