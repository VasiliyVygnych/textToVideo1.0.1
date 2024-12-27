//
//  LoaderViewController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 14.10.2024.
//

import UIKit
import SnapKit

class LoaderViewController: UIViewController {
    
    var viewModel: MainViewModelProtocol?
    let modelLanguage = ["en", "ru", "de", "es", "fr", "it"]

    private var logoAppImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let progressLoader: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progress = 0.1
        view.tintColor = UIColor(named: "customBlueColor")
        view.trackTintColor = UIColor(named: "colorWhite24")
        view.layer.cornerRadius = 3
        view.progressViewStyle = .default
        view.clipsToBounds = true
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Constants.ColorPaywall.viewBackgroundColor
        if let currentLanguage = Locale.preferredLanguages.first {
            LanguageConstant.appLaunguage = currentLettersLanguage(currentLanguage)
        }
        viewModel?.removeExampData()
        setupeSubview()
        addConstraints()
        setupeData()
        setupeProgress()
        viewModel?.loadProducts()
        viewModel?.requestExampVideo()
        genModel.reverse()
//        viewModel?.removeAll()
    }
    func currentLettersLanguage(_ from: String) -> String {
        let uppercaseLetters = CharacterSet.uppercaseLetters
        let nonAlphanumeric = CharacterSet.alphanumerics.inverted
        let filteredString = from.unicodeScalars.filter {
            !uppercaseLetters.contains($0) && !nonAlphanumeric.contains($0)
        }
        var result = String()
        if modelLanguage.contains(String(filteredString)) {
            result = String(filteredString)
        } else {
            result = "en"
        }
        return result
    }
    private func setupeProgress() {
        for x in 0...100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)*0.06 ) { [weak self] in
                guard let self else { return }
                let uploader: Float = Float(x) / 100
                progressLoader.setProgress(uploader,
                                           animated: true)
                if progressLoader.progress >= 1 {
                    progressLoader.isHidden = true
                    viewModel?.openTabBarController()
                }
            }
        }
    }
    private func setupeData() {
        logoAppImage.image = Constants.ImagePaywall.logoApp
    }
    private func setupeSubview() {
        view.addSubview(logoAppImage)
        view.addSubview(progressLoader)
    }
    private func addConstraints() {
        logoAppImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(116)
        }
        progressLoader.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(6)
            make.bottomMargin.equalToSuperview().inset(100)
        }
    }
}
