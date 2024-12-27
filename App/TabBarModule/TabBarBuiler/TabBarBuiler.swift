//
//  TabBarBuiler.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 09.11.2024.
//

import UIKit
import SnapKit

class TabBarBuilder: UITabBarController {
    
    private var model: BaseData?
    private var recentActivity: IncompleteData?
    weak var selectorDelegate: SelectorDelegate?

    private var topView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "tabBarColor")
        return view
    }()
    private var imageButton: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    private var selectorButton: UIButton = {
       let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.addSubview(topView)
        tabBar.addSubview(imageButton)
        tabBar.addSubview(selectorButton)
        self.modalPresentationStyle = .fullScreen
        self.tabBar.tintColor = .white
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "tabBarColor")
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        viewControllers = [createHomeController(),
                           flexItem(),
                           createAlbumsController()]
        tabBar.items?.enumerated().forEach { index, item in
            if index == 1 {
                item.isEnabled = false
            } else {
                item.isEnabled = true
            }
        }
        topView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(10)
            make.bottom.equalTo(tabBar.snp.top)
        }
        imageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(-20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(90)
        }
        selectorButton.snp.makeConstraints { make in
            make.edges.equalTo(imageButton)
        }
        imageButton.image = UIImage(named: "imageAdd")
        selectorButton.addTarget(self,
                                 action: #selector(selectorButtonTapped),
                                 for: .touchUpInside)
    }
    @objc func selectorButtonTapped() {
        let controller = createSelectorViewController()
        if let sheetController = controller.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheetController.detents = [
                    .custom { context in
                        return 400
                    }
                ]
            } else {
                sheetController.detents = [.medium()]
            }
        }
        present(controller,
                animated: true)
    }
    func createHomeController() -> UIViewController {
        let controller = ExampViewController()
        let navigation = UINavigationController(rootViewController: controller)
        let coreData: CoreManagerProtocol = CoreManager()
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let alerts: AlertManagerProtocol = AlertManager()
        let network: NetworkServiceProtocol = NetworkManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let coordinator: HomeCoordinatorProtocol = HomeCoordinator(navigationController: navigation)
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        viewModel.network = network
        viewModel.subscription = subscription
        controller.viewModel = viewModel
        controller.alerts = alerts
        controller.tabBarDelegate = self
        controller.tabBarItem = UITabBarItem(title: Constants.TabBarText.itemsHome.localized(LanguageConstant.appLaunguage),
                                       image: UIImage(named: "homeItems"),
                                       tag: 0)
        return navigation
    }
    func createSelectorViewController() -> UIViewController {
        let controller = SelectorViewController()
        let navigation = UINavigationController(rootViewController: controller)
        var viewModel: HomeViewModelProtocol = HomeViewModel()
        let coreData: CoreManagerProtocol = CoreManager()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let network: NetworkServiceProtocol = NetworkManager()
        let coordinator: HomeCoordinatorProtocol = HomeCoordinator(navigationController: navigation)
        viewModel.network = network
        viewModel.subscription = subscription
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        controller.viewModel = viewModel
        controller.delegate = selectorDelegate
        return navigation
    }
    func flexItem() -> UIViewController {
        let controller = UIViewController()
        controller.tabBarItem = UITabBarItem(title: "",
                                             image: UIImage(),
                                             tag: 1)
        return controller
    }
    func createAlbumsController() -> UIViewController {
        let controller = AlbumsController()
        let navigation = UINavigationController(rootViewController: controller)
        let coreData: CoreManagerProtocol = CoreManager()
        var viewModel: AlbumViewModelProtocol = AlbumViewModel()
        let subscription: SubscriptionManagerProtocol = SubscriptionManager()
        let coordinator: AlbumCoordinatorProtocol = AlbumCoordinator(navigationController: navigation)
        let network: NetworkServiceProtocol = NetworkManager()
        viewModel.coordinator = coordinator
        viewModel.coreData = coreData
        viewModel.network = network
        viewModel.subscription = subscription
        controller.viewModel = viewModel
        controller.tabBarDelegate = self
        controller.tabBarItem = UITabBarItem(title: Constants.TabBarText.itemsAlbums.localized(LanguageConstant.appLaunguage),
                                             image: UIImage(named: "albumsItems"),
                                             tag: 2)
        return navigation
    }
}
extension TabBarBuilder: TabBarDelegate {
    func setSelectorDelegate(_ delegate: SelectorDelegate?) {
        selectorDelegate = delegate
    }
}
