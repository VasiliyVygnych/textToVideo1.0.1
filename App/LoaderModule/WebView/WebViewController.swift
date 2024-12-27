//
//  WebViewController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import UIKit
import SnapKit
import WebKit

class WebViewController: UIViewController {
    
    var viewModel: MainViewModelProtocol?
    private var webView = WKWebView()
    var navTitle = String()
    var mode = SettingsWebView.none
    
    private var viewTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 20,
                                 weight: .semibold)
        view.textAlignment = .center
        return view
    }()
    private var backToView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Constants.ColorPaywall.viewBackgroundColor
        viewTitle.text = navTitle
        setupeWebView()
        addSubview()
        setuprData()
        setupeConstraint()
        backToView.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        setupeWebView(mode)
    }
    private func setuprData() {
        backToView.setBackgroundImage(Constants.ImagePaywall.arrowLeft,
                                      for: .normal)
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    func setupeWebView(_ mode: SettingsWebView) {
        switch mode {
        case .privacyPolicy:
            if let url = URL(string: "https://telegra.ph/Privacy-Policy-12-17-59") {
                webView.load(URLRequest(url: url))
            }
        case .termsOfUse:
            if let url = URL(string: "https://telegra.ph/Terms--Conditions-12-17-3") {
                webView.load(URLRequest(url: url))
            }
        case .none:
            break
        }
    }
    private func setupeWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
    }
    private func addSubview() {
        view.addSubview(backToView)
        view.addSubview(viewTitle)
    }
    private func setupeConstraint() {
        viewTitle.snp.makeConstraints { make in
            make.top.equalTo(80)
            make.height.equalTo(22)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        backToView.snp.makeConstraints { make in
            make.centerY.equalTo(viewTitle.snp.centerY)
            make.width.height.equalTo(33)
            make.left.equalTo(20)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(120)
            make.width.equalToSuperview()
            make.bottomMargin.equalToSuperview().inset(30)
        }
    }
}
