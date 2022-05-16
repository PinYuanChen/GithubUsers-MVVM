//
//  UserTableViewCell.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/9.
//

import UIKit
import SnapKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: Public properties
    let avatarImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: Private properties
    private let avatarSize = CGSize(width: 50, height: 50)
}

private extension UserTableViewCell {
    
    func setupUI() {
        configureAvatarImageView()
        configureTitleLabel()
        configureSubtitleLabel()
    }
    
    func configureAvatarImageView() {
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(avatarSize)
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        avatarImageView.layer.cornerRadius = avatarSize.height / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(5)
            $0.top.equalToSuperview().offset(10)
        }
    }
    
    func configureSubtitleLabel() {
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .lightGray
    }
}
