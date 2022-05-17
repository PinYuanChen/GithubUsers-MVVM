// 
//  UserDetailViewController.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/9.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class UserDetailViewController: UIViewController {

    // MARK: Property

    var viewModel: UserDetailViewModelPrototype?

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        guard let viewModel = viewModel else { return }

        bind(viewModel)
        bind()
    }

    // MARK: Private properties
    
    private let closeButton = UIButton()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let divider = UIView()
    private let infoStack = UIStackView()
    private let nameInfo = IconInfoView()
    private let locationInfo = IconInfoView()
    private let webInfo = IconInfoView()
    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension UserDetailViewController {

    func setupUI() {
        view.backgroundColor = .white
        configureCloseButton()
        configureAvatarImageView()
        configureNameLabel()
        configureDivider()
        configureInfoStack()
    }
    
    func configureCloseButton() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        closeButton.setImage(UIImage(named: "close"), for: .normal)
    }
    
    func configureAvatarImageView() {
        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(150)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
        
        avatarImageView.layer.cornerRadius = 75
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
    }
    
    func configureNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(avatarImageView.snp.bottom).offset(10)
        }
        
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textColor = .darkGray
    }
    
    func configureDivider() {
        view.addSubview(divider)
        divider.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.width.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(40)
        }
        
        divider.backgroundColor = .lightGray
    }
    
    func configureInfoStack() {
        view.addSubview(infoStack)
        infoStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(divider.snp.bottom).offset(40)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(180)
        }
        
        infoStack.axis = .vertical
        infoStack.distribution = .fillEqually
        
        [nameInfo, locationInfo, webInfo].forEach {
            $0.label.textColor = .lightGray
            $0.label.adjustsFontSizeToFitWidth = true
            infoStack.addArrangedSubview($0)
        }
        
        nameInfo.iconImageView.image = UIImage(named: "user")
        locationInfo.iconImageView.image = UIImage(named: "place")
        webInfo.iconImageView.image = UIImage(named: "link")
    }
}

// MARK: - Binding

private extension UserDetailViewController {

    func bind(_ viewModel: UserDetailViewModelPrototype) {
        
        viewModel
            .output
            .userModel
            .subscribe(onNext: { [weak self] model in
                guard let self = self,
                      let imgUrl = model.avatarURL else { return }
                self.avatarImageView.kf.setImage(with: URL(string: imgUrl))
                self.nameLabel.text = model.name
                self.nameInfo.label.text = model.login
                self.locationInfo.label.text = model.location
                self.webInfo.label.text = model.url
            })
            .disposed(by: disposeBag)
        
    }
    
    func bind() {
        
        closeButton
            .rx
            .tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
    }
}
