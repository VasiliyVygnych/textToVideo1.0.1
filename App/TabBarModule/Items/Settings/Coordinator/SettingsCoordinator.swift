//
//  SettingsCoordinator.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

class SettingsCoordinator: SettingsCoordinatorProtocol {
    
    var navigationController: UINavigationController?
    var assembler: SettingsBuilderProtocol
    
    init(navigationController: UINavigationController?,
         assembler: SettingsBuilderProtocol = SettingsBuilder()) {
        self.navigationController = navigationController
        self.assembler = assembler
    }
    
    func createPaywallController(isAdd: Bool)  {
        if let navigationController = navigationController {
            let controller = assembler.createPaywallController(navigation: navigationController,
                                                               isAdd: isAdd)
            controller.modalPresentationStyle = .fullScreen
            navigationController.present(controller,
                                         animated: true)
        }
    }
    func presentView(view: UIViewController) {
        if let navigationController = navigationController {
            navigationController.present(view,
                                         animated: true)
        }
    }
    func createWebViewController(title: String,
                                 mode: SettingsWebView) {
        if let navigationController = navigationController {
            let controller = assembler.createWebViewController(navigation: navigationController,
                                                               title: title,
                                                               mode: mode)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    func createInfoCreditsView() {
        if let navigationController = navigationController {
            let controller = assembler.createInfoCreditsView(coordinator: self)
            if let sheetController = controller.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    sheetController.detents = [
                        .custom { context in
                            return 380
                        }
                    ]
                } else {
                    sheetController.detents = [.medium()]
                }
            }
            navigationController.present(controller,
                                         animated: true)
        }
    }
}
