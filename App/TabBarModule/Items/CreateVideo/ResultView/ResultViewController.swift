//
//  ResultViewController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 18.10.2024.
//

import UIKit
import SnapKit
import AVFoundation
import AVKit

class ResultViewController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    private var loaderView = LoaderView()
    private var rateView = RateView()
    var baseModel: BaseData?
    var tToVmodel: TextToVideoData?
    var vToVmodel: VideoToVideoData?
    var data: ResponseData?
    var fileURL: URL?
    private var saveURL: String?
    private var player: AVPlayer?
    private let playerController = AVPlayerViewController()
    private var activityIndicator = UIActivityIndicatorView()
    private var duration: String?
    private var previewImage: UIImage?
    var selector = SelectorEnums.none
    
    
    private var headerTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    private var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var repeatButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var resultView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private var titleView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var titleTextView: UITextView = {
        let view = UITextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.isScrollEnabled = false
        view.scrollsToTop = false
        view.backgroundColor = .clear
        view.keyboardType = .default
        return view
    }()
    private var titlePlaceholder: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .medium)
        view.textAlignment = .left
        return view
    }()
    
    private var editButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        view.setTitleColor(.white,
                           for: .normal)
        return view
    }()
    
    
    private var skipButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        view.setTitleColor(.white,
                           for: .normal)
        return view
    }()
    private var saveButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        view.setTitleColor(.white,
                           for: .normal)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        rateView.delegate = self
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        addConstraints()
        setupeButton()
        if let url = fileURL {
            setupPlayer(url)
            saveURL = fileURL?.absoluteString
        }
        setupeDataVideo(strUrl: fileURL)
    }
    func setupPlayer(_ url: URL) {
        player = AVPlayer(url: url)
        playerController.player = player
        self.addChild(playerController)
        resultView.addSubview(playerController.view)
        playerController.view.frame = resultView.bounds
        playerController.didMove(toParent: self)
        playerController.player?.play()
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            player?.pause()
    }
    private func setupeDataVideo(strUrl: URL?) {
        if let url = strUrl {
            activityIndicator.startAnimating()
            viewModel?.showPreviewVideo(url: url.absoluteString,
                                        completion: { image in
                DispatchQueue.main.async { [weak self] in
                    self?.duration = self?.videoDuration(url)
                    self?.previewImage = image
                    self?.activityIndicator.stopAnimating()
                    self?.saveButton.isEnabled = true
                    self?.saveButton.alpha = 1
                }
            })
        }
    }
    func videoDuration(_ url: URL) -> String {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        let minutes = Int(durationInSeconds) / 60
        let seconds = Int(durationInSeconds) % 60
        return "\(minutes):\(seconds) \(HomeConstants.HomeText.minuteUnit.localized(LanguageConstant.appLaunguage))"
    }
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(backButton)
        view.addSubview(repeatButton)
        
        view.addSubview(resultView)
        
        view.addSubview(titleView)
        titleView.addSubview(titleTextView)
        titleTextView.delegate = self
        titleView.addSubview(titlePlaceholder)
        
        view.addSubview(editButton)
        editButton.isHidden = true
        
        view.addSubview(skipButton)
        view.addSubview(saveButton)
        saveButton.addSubview(activityIndicator)
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
        
        view.addSubview(loaderView)
        loaderView.viewModel = viewModel
        loaderView.isHidden = true
        
        view.addSubview(rateView)
        rateView.view = self
        rateView.isHidden = true
    }
    private func setupeText() {
        headerTitle.text = HomeConstants.HomeText.resultHeaderTitle.localized(LanguageConstant.appLaunguage)
        saveButton.setTitle(HomeConstants.HomeText.saveVideoButton.localized(LanguageConstant.appLaunguage),
                            for: .normal)
        skipButton.setTitle(HomeConstants.HomeText.skipButtonTitle.localized(LanguageConstant.appLaunguage),
                            for: .normal)
        titlePlaceholder.text = HomeConstants.HomeText.resultTitlePlaceholder.localized(LanguageConstant.appLaunguage)
        editButton.setTitle(HomeConstants.HomeText.editVideoTitle.localized(LanguageConstant.appLaunguage),
                            for: .normal)
    }
    private func setupeColor() {
        titleView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        titlePlaceholder.textColor = HomeConstants.HomeColor.colorWhite46
        saveButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        editButton.backgroundColor = HomeConstants.HomeColor.colorWhite8
        activityIndicator.color = .white
    }
    private func setupeData() {
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
        repeatButton.setBackgroundImage(HomeConstants.HomeImage.repeatImage,
                                        for: .normal)
    }
    private func setupeButton() {
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        saveButton.addTarget(self,
                             action: #selector(saveVide),
                             for: .touchUpInside)
        skipButton.addTarget(self,
                             action: #selector(skipTaped),
                             for: .touchUpInside)
        repeatButton.addTarget(self,
                               action: #selector(repeatRequest),
                               for: .touchUpInside)
        editButton.addTarget(self,
                             action: #selector(openEditor),
                             for: .touchUpInside)
    }
    
    @objc func repeatRequest() {
        loaderView.isHidden = false
        loaderView.loading = true
        loaderView.viewModel = viewModel
        loaderView.startAnimating()
        tabBarController?.tabBar.isHidden = true
        switch selector {
        case .textImageToVideo:
            loaderView.selector = .textImageToVideo
            loaderView.textToVideoData = tToVmodel
            guard let data = tToVmodel else { return }
            if tToVmodel?.image == nil {
                viewModel?.requestImageToVideoStatus(model: data,
                                                     type: .textToVideo,
                                                     delegate: nil)
            } else {
                viewModel?.requestImageToVideoStatus(model: data,
                                                     type: .imageToVideo,
                                                     delegate: nil)
            }
        case .videoToVideo:
            loaderView.selector = .videoToVideo
            loaderView.videoToVideoData = vToVmodel
            
           

            
            
            
            
            
            
            
            
            
        case .base:
            loaderView.selector = .base
            loaderView.model = baseModel
            var videoData: String?
            if baseModel?.duration == nil || baseModel?.ratio == nil || baseModel?.music == nil {
                videoData = baseModel?.description
            } else {
    //            let descriptionVideo = String(format: "%@ %@, %@, %@ %@, %@ %@",
    //                                          HomeConstants.HomeText.patternDuration.localized(LanguageConstant.appLaunguage),
    //                                          model?.duration ?? "",
    //                                          model?.description ?? "",
    //                                          HomeConstants.HomeText.patternRatio.localized(LanguageConstant.appLaunguage),
    //                                          model?.ratio ?? "",
    //                                          model?.music ?? "",
    //                                          HomeConstants.HomeText.patternMusic.localized(LanguageConstant.appLaunguage))
                let descriptionVideo = String(format: "%@, %@ %@",
                                              baseModel?.description ?? "",
                                              HomeConstants.HomeText.patternRatio.localized(LanguageConstant.appLaunguage),
                                              baseModel?.ratio ?? "")
                videoData = descriptionVideo
            }
            
            if let value = videoData,
               let mode = baseModel?.mode {
                viewModel?.postRequest(text: value,
                                       type: setupeType(mode))
            }
        case .none:
            break
        }
        navigationController?.popViewController(animated: false)
    }
    func setupeType(_ mode: PluginMode) -> GenerationType {
        switch mode {
        case .basicWorkflows:
            return .any
        case .instagramReels:
                return .instagram
        case .scriptToVideo:
            return .any
        case .youtubeShorts:
            return .youtube
        case .none:
            return .any
        }
    }
    @objc func openEditor() {
        viewModel?.viewAnimate(view: editButton,
                               duration: 0.2,
                               scale: 0.96)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            self?.viewModel?.openEditVideoController()
        }
    }
    @objc func skipTaped() {
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func saveVide() {
        viewModel?.viewAnimate(view: saveButton,
                               duration: 0.2,
                               scale: 0.96)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            self?.rateView.showMy()
        }
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    deinit {
        playerController.player?.pause()
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerTitle.snp.centerY)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
        }
        repeatButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerTitle.snp.centerY)
            make.right.equalTo(-20)
            make.width.height.equalTo(24)
        }
        
        resultView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(30)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(178)
        }
        titleView.snp.makeConstraints { make in
            make.top.equalTo(resultView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(50)
        }
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(15)
        }
        titlePlaceholder.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(25)
            make.height.equalTo(20)
        }
        editButton.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
        }
        
        skipButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(50)
            make.bottom.equalTo(saveButton.snp.top).inset(-5)
        }
        saveButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(20)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
        }
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension ResultViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        titleTextView.text = textView.text
        if textView.text.isEmpty {
            titlePlaceholder.isHidden = false
        } else {
            titlePlaceholder.isHidden = true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension ResultViewController: CustomViewDelegate {
    func isHideTabBar(_ bool: Bool) {
        tabBarController?.tabBar.isHidden = bool
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            self?.viewModel?.saveVideo(genType: self?.selector.type,
                                       title: self?.titleTextView.text,
                                       duration: self?.duration,
                                       url: self?.saveURL,
                                       previewImage: self?.previewImage)
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    func showView() {
        rateView.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
}
