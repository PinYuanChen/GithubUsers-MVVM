//
//  CoordinatorPrototype.swift
//  TravelAlbum
//
//  Created by PatrickChen on 2021/12/5.
//

import UIKit

protocol CoordinatorPrototype: AnyObject {

    // MARK: - Properties
    
    var navigationController: UINavigationController? { get set }
    var rootViewController: UIViewController? { get }
    var identifier: UUID { get }
    var childCoordinators: [UUID: CoordinatorPrototype] { get set }

    // MARK: Functions
    
    func start()
    func stop()
    func store(coordinator: CoordinatorPrototype)
    func release(coordinator: CoordinatorPrototype)
}

