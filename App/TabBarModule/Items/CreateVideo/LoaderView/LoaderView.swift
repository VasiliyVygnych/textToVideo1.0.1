//
//  LoaderView.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 18.10.2024.
//

import UIKit
import SnapKit

class LoaderView: UIView {
    
    var viewModel: HomeViewModelProtocol?
    var currentIndex = 0
    var cycles = Int()
    var model: BaseData?
    var textToVideoData: TextToVideoData?
    var videoToVideoData: VideoToVideoData?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var timer: Timer?
    private var dotCount = 0
    var selector = SelectorEnums.none
    var loading = false
    
    private var headerTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    private var loaderTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 30,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    var progressTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 110,
                                weight: .semibold)
        view.textAlignment = .center
        return view
    }()
    private var infoTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .medium)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    init() {
        super.init(frame: .zero)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(rememberRequest),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        backgroundColor = HomeConstants.HomeColor.backgroundColor
        addSubview()
        setupeText()
        setupeColor()
        setupeConstraints()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func rememberRequest() {
        if loading == true {
            print("ПРИЛОЖЕНИЕ ЗАКРЫТО")
            switch selector {
            case .textImageToVideo:
                viewModel?.setIncompleteTextToVideo(selector: .textImageToVideo,
                                                    model: textToVideoData)
            case .videoToVideo:
                viewModel?.setIncompleteVideoToVideo(selector: .videoToVideo,
                                                     model: videoToVideoData)
            case .base:
                viewModel?.setIncompleteBase(selector: .base,
                                             model: model)
            case .none:
                break
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func addSubview() {
        addSubview(headerTitle)
        addSubview(loaderTitle)
        addSubview(progressTitle)
        addSubview(infoTitle)
        addSubview(activityIndicator)
        activityIndicator.isHidden = true
        loaderTitle.isHidden = true
    }
    func startAnimating() {
        loading = true
//        activityIndicator.startAnimating()
//        timer = Timer.scheduledTimer(timeInterval: 0.5,
//                                     target: self,
//                                     selector: #selector(updateLabel),
//                                     userInfo: nil,
//                                     repeats: true)
        if selector == .base {
            setupeProgressTitle()
        }
    }
    private func setupeProgressTitle() {
        let totalDuration: Double = 300.0 // 5 минут в секундах
        let iterations: Int = 50
        let delay = totalDuration / Double(iterations)
        for x in 0..<iterations {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x) * delay) { [weak self] in
                guard let self else { return }
                let uploader: Float = Float(x) / 100
                progressTitle.text = String(format: "%.0f%%",
                                            uploader * 100)
                if progressTitle.text == "98%" {
                    progressTitle.text = "98%"
                }
            }
        }
    }
    func stopAnimating() {
        progressTitle.text = "0%"
        loading = false
//        activityIndicator.stopAnimating()
//        timer?.invalidate()
    }
    @objc private func updateLabel() {
        dotCount = (dotCount + 1) % 4 
        let dots = String(repeating: ".", count: dotCount)
        loaderTitle.text = "\(HomeConstants.HomeText.loaderTitle.localized(LanguageConstant.appLaunguage))\(dots)"
    }
    private func setupeText() {
        progressTitle.text = "0%"
        headerTitle.isHidden = true
        headerTitle.text = HomeConstants.HomeText.loaderHeaderTitle.localized(LanguageConstant.appLaunguage)
        infoTitle.text = HomeConstants.HomeText.loaderinfoTitle.localized(LanguageConstant.appLaunguage)
        loaderTitle.text = HomeConstants.HomeText.loaderTitle.localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        infoTitle.textColor = HomeConstants.HomeColor.colorWhite46
        progressTitle.textColor = HomeConstants.HomeColor.customBlueColor
    }
    private func setupeConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalToSuperview()
        }
        loaderTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(60)
        }
        progressTitle.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        infoTitle.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(40)
            make.left.equalTo(40)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
            make.bottomMargin.equalToSuperview().inset(20)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}
