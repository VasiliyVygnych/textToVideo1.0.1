//
//  DetailViewController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 12.11.2024.
//

import UIKit
import SnapKit
import AVFoundation
import AVKit
import Photos

class DetailViewController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    var savedVideos: SavedVideos?
    var albumContents: AlbumContents?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let playerController = AVPlayerViewController()
    private let saveIndicator = UIActivityIndicatorView()
    private var video: URL?
    private var sevadCount = Int()
    
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
    private var saveButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        checkSubscriptionRequirements()
        setupeSubview()
        addConstraints()
        setupeButton()
        if let strURL = savedVideos?.videoURL {
            if let url = URL(string: strURL),
               let docUrl = viewModel?.createDocumentURL(url) {
                setupPlayer(docUrl)
            }
            headerTitle.text = savedVideos?.title
        } else {
            if let strURL = albumContents?.videoURL {
                if let url = URL(string: strURL),
                   let docUrl = viewModel?.createDocumentURL(url) {
                    setupPlayer(docUrl)
                }
            }
            headerTitle.text = albumContents?.title
        }
    }
    func setupPlayer(_ url: URL) {
        video = url
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerController.player = player
        playerLayer?.videoGravity = .resizeAspectFill
        self.addChild(playerController)
        contentView.addSubview(playerController.view)
        playerController.view.frame = contentView.bounds
        playerController.didMove(toParent: self)
        playerController.player?.play()
    }
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(saveIndicator)
        saveIndicator.color = .white
        view.addSubview(saveButton)
        view.addSubview(backButton)
        view.addSubview(contentView)
    }
    private func setupeButton() {
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
        saveButton.setBackgroundImage(SettingsConstants.SettingsImages.shareImages,
                                       for: .normal)
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        saveButton.addTarget(self,
                              action: #selector(saveVideo),
                              for: .touchUpInside)
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    @objc func saveVideo() {
        if let url = self.video {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                switch status {
                case .authorized: // Доступ разрешен
                    DispatchQueue.main.async { [weak self] in
                        if let url = self?.viewModel?.createDocumentURL(url) {   // save to galary
                            self?.viewModel?.saveVideoToGallerysss(url,
                                                                   completion: { result in
                                DispatchQueue.main.async { [weak self] in
                                    if result {
                                        self?.successSave()
                                    } else {
                                        self?.errorSave()
                                    }
                                }
                            })
                            self?.saveIndicator.startAnimating()
                            self?.saveButton.isHidden = true
                        }
                    }
                case .denied,
                        .restricted,
                        .notDetermined,
                        .limited: // Доступ запрещен или ограничен
                    DispatchQueue.main.async { [weak self] in
                        self?.accessPermission()
                    }
                @unknown default:
                    break
                }
            }
        }
    }
   private func accessPermission() {
        var actions: [UIAlertAction] = []
        let openSetting = UIAlertAction(title: "Open Settings".localized(LanguageConstant.appLaunguage),
                                        style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url,
                                          options: [:],
                                          completionHandler: nil)
            }
        }
        actions.append(openSetting)
        let cancel = UIAlertAction(title: "Cancel".localized(LanguageConstant.appLaunguage),
                                   style: .destructive)
        actions.append(cancel)
        if let errorAlert = viewModel?.showAlert(title: "Access to the gallery is closed".localized(LanguageConstant.appLaunguage),
                                                 message: "to open access, go to settings".localized(LanguageConstant.appLaunguage),
                                                 actions: actions,
                                                 popover: contentView) {
            present(errorAlert,
                    animated: true)
        }
    }
    func saveVideoToFiles(_ localURL: URL?) {
        guard let localURL,
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first else { return }
        let destinationURL = documentsDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
        do {
            try FileManager.default.moveItem(at: localURL,
                                             to: destinationURL)
            let documentPicker = UIDocumentPickerViewController(forExporting: [destinationURL])
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            DispatchQueue.main.async { [weak self] in
                self?.present(documentPicker,
                             animated: true)
            }
        } catch {
            print("Ошибка сохранения видео: \(error.localizedDescription)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) { [weak self] in
                self?.errorSave()
            }
        }
    }
    private func errorSave() {
        saveIndicator.stopAnimating()
        saveButton.isHidden = false
        saveButton.tintColor = .systemRed
        saveButton.setBackgroundImage(UIImage(systemName: "xmark.circle"),
                                                for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) { [weak self] in
            self?.saveButton.setBackgroundImage(SettingsConstants.SettingsImages.shareImages,
                                                 for: .normal)
        }
    }
    private func successSave() {
        viewModel?.editSavedCount()
        checkSubscriptionRequirements()
        saveIndicator.stopAnimating()
        saveButton.isHidden = false
        saveButton.tintColor = .white
        saveButton.setBackgroundImage(UIImage(systemName: "checkmark.circle"),
                                                for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) { [weak self] in
            self?.saveButton.setBackgroundImage(SettingsConstants.SettingsImages.shareImages,
                                                 for: .normal)
        }
    }
    func showAccessDeniedAlert() {
        let alert = UIAlertController(title: HomeConstants.HomeText.assetLibraryTitle.localized(LanguageConstant.appLaunguage),
                                      message: HomeConstants.HomeText.assetLibraryMessage.localized(LanguageConstant.appLaunguage),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: HomeConstants.HomeText.closeTitle.localized(LanguageConstant.appLaunguage),
                                      style: .default,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: Constants.TabBarText.itemsSettings.localized(LanguageConstant.appLaunguage),
                                      style: .cancel,
                                      handler: { action in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url,
                                          options: [:],
                                          completionHandler: nil)
            }
        }))
        present(alert,
                animated: true)
    }
    deinit {
        playerController.player?.pause()
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.centerY.equalTo( backButton.snp.centerY)
            make.height.equalTo(20)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.right.equalTo(-20)
            make.width.height.equalTo(30)
        }
        saveIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(saveButton)
        }
        contentView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
extension DetailViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentsAt urls: [URL]) { // Документ выбран
        DispatchQueue.main.async { [weak self] in
            self?.successSave()
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) { // Выбор документа отменен
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) { [weak self] in
            self?.saveIndicator.stopAnimating()
            self?.saveButton.isHidden = false
        }
    }
}
extension DetailViewController {
    func checkSubscriptionRequirements() {
        let data = viewModel?.getAppData()
        data?.forEach({ model in
            sevadCount = Int(model.savedLimit)
            if model.freeIsActive == true {
                saveButton.isHidden = true
            }
            if model.plusYearlyActive || model.plusMounthlyActive == true {
                if sevadCount == 0 {
                    saveButton.isHidden = true
                }
            }
        })
    }
}
