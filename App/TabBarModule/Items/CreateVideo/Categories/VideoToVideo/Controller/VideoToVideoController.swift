//
//  VideoToVideoController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 06.12.2024.
//

import UIKit
import SnapKit
import PhotosUI
import AVFoundation
import AVKit

class VideoToVideoController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    var alerts: AlertManagerProtocol?
    var incompleteModel: IncompleteData?
    private var model: VideoToVideoData?
    private var videoStrUrl: String?
    private var styleImage: UIImage?
    private var styleMode: String?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let playerController = AVPlayerViewController()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var loaderView = LoaderView()
    private var isSelectVideo: Bool = false
    private var isSelectStyle: Bool = false
    
    private var headerTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textAlignment = .center
        return view
    }()
    private var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var deleteButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        return view
    }()
    private var crownImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    private var videoSelectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var previewVodeo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var infoVideoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        return view
    }()
    private var infoVideoTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .bold)
        view.textAlignment = .center
        return view
    }()
    private var photoButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var galaryButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var removeVideoButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var styleSelectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var infoStyleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        return view
    }()
    private var infoStyleTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .bold)
        view.textAlignment = .center
        return view
    }()
    private var addStyleButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    
    private var generationButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        view.setTitleColor(.white,
                           for: .normal)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        viewModel?.requestDelegate = self
        setupeSubview()
        setupeText()
        setupeColor()
        setupeImage()
        addConstraints()
        setupeButton()
        if let data = incompleteModel {
            setIncompleteData(data)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(backButton)
        view.addSubview(deleteButton)
        view.addSubview(crownImage)
        deleteButton.isHidden = true
        
        view.addSubview(videoSelectView)
        videoSelectView.addSubview(previewVodeo)
        videoSelectView.addSubview(activityIndicator)
        
        view.addSubview(infoVideoView)
        infoVideoView.addSubview(infoVideoTitle)
        view.addSubview(photoButton)
        view.addSubview(galaryButton)
        view.addSubview(removeVideoButton)
        removeVideoButton.isHidden = true
        
        
        view.addSubview(styleSelectView)
        view.addSubview(infoStyleView)
        infoStyleView.addSubview(infoStyleTitle)
        view.addSubview(addStyleButton)
        
        view.addSubview(generationButton)
        generationButton.isEnabled = false
        generationButton.alpha = 0.5
        
        view.addSubview(loaderView)
        loaderView.viewModel = viewModel
        loaderView.isHidden = true
    }
    private func setupeText() {
        headerTitle.text = "Video to video".localized(LanguageConstant.appLaunguage)
        deleteButton.setTitle("delete".localized(LanguageConstant.appLaunguage),
                              for: .normal)
        infoVideoTitle.text = "Video".localized(LanguageConstant.appLaunguage)
        infoStyleTitle.text = "Style".localized(LanguageConstant.appLaunguage)
        generationButton.setTitle("Generate".localized(LanguageConstant.appLaunguage),
                                  for: .normal)
    }
    private func setupeColor() {
        headerTitle.textColor = .white
        deleteButton.setTitleColor(HomeConstants.HomeColor.customBlueColor,
                                   for: .normal)
        videoSelectView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        previewVodeo.backgroundColor = .clear
        
        infoVideoTitle.textColor = .white
        infoVideoView.backgroundColor = UIColor(named: "infoViewColor")
        infoStyleView.backgroundColor = UIColor(named: "infoViewColor")
        infoStyleTitle.textColor = .white
        styleSelectView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        generationButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
    }
    private func setupeImage() {
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
        crownImage.image = UIImage(named: "crownGoldImage")
        photoButton.setBackgroundImage(UIImage(named: "selectPhototImage"),
                                       for: .normal)
        galaryButton.setBackgroundImage(UIImage(named: "selectGalaryImage"),
                                        for: .normal)
        removeVideoButton.setBackgroundImage(UIImage(named: "removeVideoImage"),
                                             for: .normal)
        addStyleButton.setBackgroundImage(UIImage(named: "addVideoImage"),
                                          for: .normal)
    }
    private func setIncompleteData(_ data: IncompleteData) {
        deleteButton.isHidden = false
        styleMode = data.styleMode
        videoStrUrl = data.strUrl
        styleImage = UIImage(data: data.selectImage)
        if styleMode != nil {
            photoButton.isHidden = true
            galaryButton.isHidden = true
            removeVideoButton.isHidden = false
            isSelectStyle = true
        }
        if videoStrUrl != nil {
            isSelectVideo = true
        }
        if let urlStr = videoStrUrl,
           let url = URL(string: urlStr),
           let docUrl = viewModel?.createDocumentURL(url) {
            setupPlayer(url: docUrl)
            

            addStyleButton.tag = 1
            infoVideoView.isHidden = true
        }
        checkSelect()
    }
    private func checkSelect() {
        if isSelectStyle && isSelectVideo == true {
            generationButton.isEnabled = true
            generationButton.alpha = 1
        } else {
            generationButton.isEnabled = false
            generationButton.alpha = 0.5
        }
    }
    private func setupeButton() {
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        deleteButton.addTarget(self,
                               action: #selector(deleteIncomplete),
                               for: .touchUpInside)
        photoButton.addTarget(self,
                              action: #selector(openCamera),
                              for: .touchUpInside)
        galaryButton.addTarget(self,
                               action: #selector(openGalary),
                               for: .touchUpInside)
        removeVideoButton.addTarget(self,
                                    action: #selector(removeSelectVideo),
                                    for: .touchUpInside)
        addStyleButton.addTarget(self,
                                 action: #selector(openSelecStyle),
                                 for: .touchUpInside)
        generationButton.addTarget(self,
                                   action: #selector(generationVideo),
                                   for: .touchUpInside)
    }
    @objc func generationVideo() {
        viewModel?.viewAnimate(view: generationButton,
                               duration: 0.2,
                               scale: 0.97)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            let data = VideoToVideoData(urlString: videoStrUrl,
                                           styleMode: styleMode,
                                           setyleImage: styleImage)
            model = data
            // network
    
            isLoader(true,
                     model: data)
        }
    }
    func isLoader(_ bool: Bool,
                  model: VideoToVideoData?) {
        if bool == true {
            loaderView.loading = true
            loaderView.viewModel = viewModel
            loaderView.selector = .videoToVideo
            loaderView.isHidden = false
            loaderView.videoToVideoData = model
            loaderView.startAnimating()
            tabBarController?.tabBar.isHidden = true
        } else {
            loaderView.loading = false
            loaderView.isHidden = true
            loaderView.textToVideoData = nil
            loaderView.selector = .none
            loaderView.stopAnimating()
            tabBarController?.tabBar.isHidden = false
        }
    }
    @objc func openSelecStyle(_ sender: UIButton) {
        viewModel?.viewAnimate(view: addStyleButton,
                               duration: 0.2,
                               scale: 0.97)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            switch sender.tag {
            case 0:
                viewModel?.presentCategoryViewController(delegate: self)
            case 1:
                sender.tag = 0
                isSelectStyle = false
                checkSelect()
                addStyleButton.setBackgroundImage(UIImage(named: "addVideoImage"),
                                                     for: .normal)
            default:
                break
            }
        }
    }
    @objc func removeSelectVideo() {
        viewModel?.viewAnimate(view: removeVideoButton,
                               duration: 0.2,
                               scale: 0.97)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            galaryButton.isHidden = false
            photoButton.isHidden = false
            infoVideoView.isHidden = false
            previewVodeo.isHidden = true
            isSelectVideo = false
            checkSelect()
            removeVideoButton.isHidden = true
            videoSelectView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        }
    }
    @objc func deleteIncomplete() {
        if let data = incompleteModel {
            viewModel?.removeIncompleteData(id: Int(data.id))
        }
        navigationController?.popViewController(animated: true)
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    @objc func openCamera() {
        viewModel?.viewAnimate(view: photoButton,
                               duration: 0.2,
                               scale: 0.97)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self?.setupeCamera()
                break
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in }
            case .denied, .restricted:
                DispatchQueue.main.async { [weak self] in
                    self?.checkCameraAccess()
                }
            @unknown default:
                DispatchQueue.main.async { [weak self] in
                    self?.checkCameraAccess()
                }
            }
        }
    }
    private func setupeCamera() {
        switch UIImagePickerController.isSourceTypeAvailable(.camera) {
        case true:
            let pc = UIImagePickerController()
            pc.delegate = self
            pc.sourceType = .camera
            pc.mediaTypes = ["public.movie"]
            present(pc,
                    animated: true)
        case false:
            print("Камера недоступна")
        }
    }
    @objc func openGalary() {
        viewModel?.viewAnimate(view: galaryButton,
                               duration: 0.2,
                               scale: 0.97)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .denied,
                    .restricted:
                self?.checkCameraAccess()
            case .limited,
                    .authorized,
                    .notDetermined:
                self?.selectPhotos()
            @unknown default:
                break
            }
        }
    }
    private func selectPhotos() {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.selectionLimit = 1
        configuration.filter = .videos
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker,
                animated: true)
    }
    private func checkCameraAccess() {
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
        if let errorAlert = viewModel?.showAlert(title: "Access to the camera is closed".localized(LanguageConstant.appLaunguage),
                                                 message: "to open access, go to settings".localized(LanguageConstant.appLaunguage),
                                                 actions: actions,
                                                 popover: videoSelectView) {
            present(errorAlert,
                    animated: true)
        }
    }
    func setupPlayer(url: URL) {
        previewVodeo.isHidden = false
        player = AVPlayer(url: url)
        playerController.player = player
        playerController.view.frame = previewVodeo.bounds
        addChild(playerController)
        previewVodeo.addSubview(playerController.view)
        playerController.didMove(toParent: self)
        playerController.player?.play()
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.centerY.equalTo(backButton.snp.centerY)
            make.height.equalTo(20)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
        }
        crownImage.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalTo(backButton.snp.centerY)
            make.width.height.equalTo(26)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(crownImage.snp.left).inset(-5)
            make.centerY.equalTo(backButton.snp.centerY)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(100)
        }
       
        videoSelectView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(230)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        previewVodeo.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(230)
        }
        infoVideoView.snp.makeConstraints { make in
            make.top.equalTo(videoSelectView.snp.top).offset(20)
            make.left.equalTo(videoSelectView.snp.left).inset(20)
            make.height.equalTo(35)
            make.width.greaterThanOrEqualTo(83)
        }
        infoVideoTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        photoButton.snp.makeConstraints { make in
            make.top.equalTo(videoSelectView.snp.top).offset(10)
            make.width.height.equalTo(53)
            make.right.equalTo(videoSelectView.snp.right).inset(10)
        }
        galaryButton.snp.makeConstraints { make in
            make.top.equalTo(photoButton.snp.bottom).offset(10)
            make.width.height.equalTo(53)
            make.right.equalTo(videoSelectView.snp.right).inset(10)
        }
        removeVideoButton.snp.makeConstraints { make in
            make.top.equalTo(photoButton.snp.bottom).offset(10)
            make.width.height.equalTo(53)
            make.right.equalTo(videoSelectView.snp.right).inset(10)
        }
        
        styleSelectView.snp.makeConstraints { make in
            make.top.equalTo(videoSelectView.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(230)
        }
        infoStyleView.snp.makeConstraints { make in
            make.top.equalTo(styleSelectView.snp.top).offset(20)
            make.left.equalTo(styleSelectView.snp.left).inset(20)
            make.height.equalTo(35)
            make.width.greaterThanOrEqualTo(83)
        }
        infoStyleTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        addStyleButton.snp.makeConstraints { make in
            make.top.equalTo(styleSelectView.snp.top).offset(10)
            make.width.height.equalTo(53)
            make.right.equalTo(styleSelectView.snp.right).inset(10)
        }
        
        generationButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(20)
        }
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension VideoToVideoController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if results.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.startAnimating()
            }
        }
        for result in results {
            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
                    guard let url = url else { return }
                    if let fileURL = self?.viewModel?.saveTemporaryFile(url) {
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            videoSelectView.backgroundColor = .black
                            videoStrUrl = fileURL.absoluteString
                            photoButton.isHidden = true
                            galaryButton.isHidden = true
                            infoVideoView.isHidden = true
                            removeVideoButton.isHidden = false
                            previewVodeo.isHidden = true
                            setupPlayer(url: fileURL)
                            activityIndicator.stopAnimating()
                            isSelectVideo = true
                            checkSelect()
                        }
                    }
                }
            }
        }
    }
}
extension VideoToVideoController: UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
             if let videoURL = info[.mediaURL] as? URL { // video
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    videoSelectView.backgroundColor = .black
                    videoStrUrl = videoURL.absoluteString
                    photoButton.isHidden = true
                    galaryButton.isHidden = true
                    infoVideoView.isHidden = true
                    removeVideoButton.isHidden = false
                    previewVodeo.isHidden = true
                    setupPlayer(url: videoURL)
                    isSelectVideo = true
                    checkSelect()
                }
            }
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
extension VideoToVideoController: CategoryViewDelegate {
    func didSelectCategory(_ category: String?,
                           image: UIImage?) {
        styleMode = category
        styleImage = image
        addStyleButton.tag = 1
        addStyleButton.setBackgroundImage(UIImage(named: "removeVideoImage"),
                                          for: .normal)
        isSelectStyle = true
        checkSelect()
    }
}
extension VideoToVideoController: RequestDelegate {
    func getResult(data: ResponseData?) {}
    func getAIText(data: ScriptData?) {}
    func getResultTextToVideo(_ data: TextToImageResponse?) {}
    func getResultVideoToVideo() {
        isLoader(false,
                 model: nil)
//        if data == nil {
//            errorGenefation()
//        } else {
//            if let strUrl = data.url,
//               let url = URL(string: strUrl) {
//                viewModel?.downloadVideo(url,
//                                         completion: { docUrl in
//                    DispatchQueue.main.async { [weak self] in
//                        self?.viewModel?.openResultViewController(baseModel: nil,
//                                                                  tToVModel: nil,
//                                                                  vToVmodel: model,
//                                                                  data: nil,
//                                                                  fileURL: docUrl,
//                                                                  selector: .videoToVideo)
//                    }
//                })
//            }
//        }
    }
    func error() {
        errorGenefation()
    }
    func errorGenefation() {
        let action = UIAlertAction(title: "Ok",
                                   style: .cancel) { _ in
            self.isLoader(false,
                          model: nil)
        }
        if let errorAlert = alerts?.requestError(title: HomeConstants.HomeText.errorTitle.localized(LanguageConstant.appLaunguage),
                                                 message: HomeConstants.HomeText.errorMessage.localized(LanguageConstant.appLaunguage),
                                                 action: action) {
            present(errorAlert,
                    animated: true)
        }
    }
}
