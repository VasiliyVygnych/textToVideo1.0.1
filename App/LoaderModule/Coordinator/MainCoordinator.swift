

import UIKit

class MainCoordinator: MainCoordinatorProtocol {
    
    var navigationController: UINavigationController?
    var assembler: MainBuilderProtocol
    
    init(navigationController: UINavigationController?,
         assembler: MainBuilderProtocol = MainBuilder()) {
        self.navigationController = navigationController
        self.assembler = assembler
    }
    
    func initial() {
        if let navigationController = navigationController {
            let controller = assembler.createLoaderController(coordinator: self)
            navigationController.viewControllers = [controller]
        }
    }
    func createPaywallController() {
        if let navigationController = navigationController {
            let controller = assembler.createPaywallController(coordinator: self)
            controller.modalPresentationStyle = .fullScreen
            navigationController.present(controller,
                                         animated: true)
        }
    }
    func createWebViewController(title: String,
                                 mode: SettingsWebView) {
        if let navigationController = navigationController {
            let controller = assembler.createWebViewController(coordinator: self,
                                                               title: title,
                                                               mode: mode)
            navigationController.pushViewController(controller,
                                                    animated: false)
        }
    }
    func createTabBarController() {
        if let navigationController = navigationController {
            let controller = assembler.createTabBarController()
            navigationController.viewControllers.removeAll()
            navigationController.viewControllers = [controller]
        }
    }
}
