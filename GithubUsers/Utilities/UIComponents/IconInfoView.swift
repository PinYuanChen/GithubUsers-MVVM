//
//  IconInfoView.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/9.
//

import UIKit
import SnapKit

class IconInfoView: UIView {
    
    let iconImageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
}

private extension IconInfoView {
    
    func setupUI() {
        setupIconImageView()
        setupLabel()
    }
    
    func setupIconImageView() {
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.leading.centerY.equalToSuperview()
        }
    }
    
    func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(20)
            $0.height.trailing.equalToSuperview()
        }
    }
}
