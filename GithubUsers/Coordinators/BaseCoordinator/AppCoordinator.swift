//
//  AppCoordinator.swift
//  TravelAlbum
//
//  Created by PatrickChen on 2021/12/5.
//

import UIKit
import RxSwift
import RxCocoa

class AppCoordinator: Coordinator<Void> {

    // MARK: Life cycle

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        let next = MainTabBarCoordinator(window: window)
        next.start()
        store(coordinator: next)
    }

    // MARK: Private

    private let window: UIWindow
}
