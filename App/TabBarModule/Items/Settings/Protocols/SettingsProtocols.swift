//
//  SettingsProtocols.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

protocol SettingsViewModelProtocol {
    
    var coordinator: SettingsCoordinatorProtocol? { get set }
    var coreData: CoreManagerProtocol? { get set }
    var subscription: SubscriptionManagerProtocol? { get set }
    
    
//MARK: - Subscription
    
    func restoreSubscription()
    
//MARK: - Coordinator
    
    func openPaywallController(isAdd: Bool)
    func presentView(view: UIViewController)
    func openWebViewController(title: String,
                               mode: SettingsWebView)
    func showInfoCreditsView()
    
//MARK: - Core Data
    
    func getAppData() -> [AppData]? 
    
//MARK: - View
    
    func viewAnimate(view: UIView,
                     duration: Double,
                     scale: Double)
}

protocol SettingsBuilderProtocol {
    func createPaywallController(navigation: UINavigationController,
                                 isAdd: Bool) -> UIViewController
    func createWebViewController(navigation: UINavigationController,
                                 title: String,
                                 mode: SettingsWebView) -> UIViewController
    func createInfoCreditsView(coordinator: SettingsCoordinatorProtocol) -> UIViewController
}

protocol SettingsCoordinatorProtocol {
    func createPaywallController(isAdd: Bool) 
    func presentView(view: UIViewController)
    func createWebViewController(title: String,
                                 mode: SettingsWebView)
    func createInfoCreditsView()
}
