//
//  TextToImageController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 05.12.2024.
//

import UIKit
import SnapKit
import PhotosUI
import AVFoundation
import AVKit

class TextToImageController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    var alerts: AlertManagerProtocol?
    var incompleteModel: IncompleteData?
    private var durationView = DurationView()
    private var selecModel = ModelView()
    private var model: TextToVideoData?
    private var loaderView = LoaderView()
    private var cropType = CropEnum.horizontal
    private var gesture = UITapGestureRecognizer()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let playerController = AVPlayerViewController()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var selectImage: UIImage?
    private var cropImage: UIImage?
    private var videoStrUrl: String?
    private var durationValue: String?
    private var selectDuration: String?
    private var modelsValue: String?
    private var modelsType = ModelsToCreate.natash
    private var durationType = DurationGenerate.seconds5
    
    private var addPhoto: Bool = false
    private var isSelectPhoto: Bool = false
    private var isPromt: Bool = false
    
    let defaults = UserDefaults.standard
    let key = DurationGenerate.key.value
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width,
               height: view.frame.height)
    }
    
    private var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    private var headerTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
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
    
    private var conteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var selectorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 23
        return view
    }()
    private var buttonWithPhoto: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.tag = 1
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        return view
    }()
    private var buttonWithoutPhoto: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.tag = 2
        view.layer.cornerRadius = 20
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear
        view.contentSize = contentSize
        return view
    }()

    private var imageSelectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var previewVodeo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var previewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
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
    private var cropButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var descriptionTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    private var descriptionView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        return view
    }()
    private var descriptionTextView: UITextView = {
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
    private var descriptionPlaceholder: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textAlignment = .left
        view.numberOfLines = 0
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
        defaultValue()
        if let data = incompleteModel {
            setIncompleteData(data)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(willShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        durationView.alpha = 0
        durationView.snp.updateConstraints { make in
            make.top.equalTo(selecModel.snp.bottom).offset(0)
            make.height.equalTo(0)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    private func defaultValue() {
        modelsValue = "kling-video"
        selectDuration = "5"
    }
    private func setupeSubview() {
        shadowView.alpha = 0
        view.addSubview(headerTitle)
        view.addSubview(backButton)
        view.addSubview(deleteButton)
        deleteButton.isHidden = true
        
        view.addSubview(conteinerView)
        conteinerView.addSubview(selectorView)
        selectorView.addSubview(buttonWithPhoto)
        selectorView.addSubview(buttonWithoutPhoto)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageSelectView)
        imageSelectView.addSubview(activityIndicator)
        imageSelectView.addSubview(previewVodeo)
        previewVodeo.isHidden = true
        imageSelectView.addSubview(previewImage)
        
        scrollView.addSubview(photoButton)
        scrollView.addSubview(galaryButton)
        scrollView.addSubview(cropButton)
        cropButton.isHidden = true
        
        scrollView.addSubview(selecModel)
        selecModel.viewModel = viewModel
        selecModel.views = self
        selecModel.delegate = self
        
        scrollView.addSubview(durationView)
        durationView.viewModel = viewModel
        durationView.views = self
        durationView.delegate = self
        
        scrollView.addSubview(descriptionTitle)
        scrollView.addSubview(descriptionView)
        descriptionView.addSubview(descriptionTextView)
        descriptionTextView.delegate = self
        descriptionView.addSubview(descriptionPlaceholder)
        
        scrollView.addSubview(generationButton)
        generationButton.isEnabled = false
        generationButton.alpha = 0.5
        
        view.addSubview(loaderView)
        loaderView.viewModel = viewModel
        loaderView.isHidden = true
        view.addSubview(shadowView)
    }
    private func setupeText() {
        headerTitle.text = "Text/Image to video".localized(LanguageConstant.appLaunguage)
        deleteButton.setTitle("delete".localized(LanguageConstant.appLaunguage),
                              for: .normal)
        buttonWithPhoto.setTitle("Use photo".localized(LanguageConstant.appLaunguage),
                                 for: .normal)
        buttonWithoutPhoto.setTitle("No photo".localized(LanguageConstant.appLaunguage),
                                    for: .normal)
        
        descriptionTitle.text = HomeConstants.HomeText.descriptionTitle.localized(LanguageConstant.appLaunguage)
        descriptionPlaceholder.text = HomeConstants.HomeText.descriptionPlaceholder.localized(LanguageConstant.appLaunguage)
        generationButton.setTitle("Generate".localized(LanguageConstant.appLaunguage),
                                  for: .normal)
    }
    private func setupeColor() {
        headerTitle.textColor = .white
        selectorView.backgroundColor = UIColor(named: "infoViewColor")
        
        buttonWithPhoto.backgroundColor = .white
        buttonWithPhoto.setTitleColor(.black,
                                      for: .normal)
        
        buttonWithoutPhoto.backgroundColor = .clear
        buttonWithoutPhoto.setTitleColor(.lightGray,
                                         for: .normal)
        imageSelectView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        descriptionTitle.textColor = HomeConstants.HomeColor.colorWhite77
        descriptionView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        descriptionTextView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        descriptionPlaceholder.textColor = HomeConstants.HomeColor.colorWhite46
        generationButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        deleteButton.setTitleColor(HomeConstants.HomeColor.customBlueColor,
                                   for: .normal)
    }
    private func setupeImage() {
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
        photoButton.setBackgroundImage(UIImage(named: "selectPhototImage"),
                                       for: .normal)
        galaryButton.setBackgroundImage(UIImage(named: "selectGalaryImage"),
                                        for: .normal)
        cropButton.setBackgroundImage(UIImage(named: "selectCropImage"),
                                        for: .normal)
    }
    private func setIncompleteData(_ data: IncompleteData) {
        deleteButton.isHidden = false
        previewImage.image = UIImage(data: data.selectImage)
        selectImage = UIImage(data: data.selectImage)
        videoStrUrl = data.strUrl
        durationView.duration = data.duration
        durationView.setupeText()
        durationValue = data.duration
        if let ratio = data.ratio {
            switch ratio {
            case "horizontal":
                cropType = .horizontal
            case "vertical":
                cropType = .vertical
            default:
                break
            }
        }
        let credits = Int(data.credits)
        defaults.setValue(credits,
                          forKey: key)
        descriptionPlaceholder.isHidden = true
        descriptionTextView.text = data.descriptions
        generationButton.isEnabled = true
        generationButton.alpha = 1
        if selectImage == nil {
            imageSelectView.alpha = 0
            photoButton.alpha = 0
            galaryButton.alpha = 0
            cropButton.alpha = 0
            imageSelectView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            isSelectPhoto = true
            checkSelector()
            buttonWithPhoto.backgroundColor = .clear
            buttonWithPhoto.setTitleColor(.lightGray,
                                          for: .normal)
            buttonWithoutPhoto.backgroundColor = .white
            buttonWithoutPhoto.setTitleColor(.black,
                                             for: .normal)
            cropButton.isHidden = true
        } else {
            cropButton.isHidden = false
        }
        if videoStrUrl != nil {
            cropButton.isHidden = true
            previewVodeo.isHidden = false
            imageSelectView.backgroundColor = .black
            videoStrUrl = data.strUrl
            if let urlStr = videoStrUrl,
               let url = URL(string: urlStr) {
                setupPlayer(url: url)
            }
        }
    }
    private func setupeButton() {
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        photoButton.addTarget(self,
                              action: #selector(openCamera),
                              for: .touchUpInside)
        galaryButton.addTarget(self,
                               action: #selector(openGalary),
                               for: .touchUpInside)
        cropButton.addTarget(self,
                             action: #selector(openCrop),
                             for: .touchUpInside)
        generationButton.addTarget(self,
                                   action: #selector(generationVideo),
                                   for: .touchUpInside)
        deleteButton.addTarget(self,
                               action: #selector(deleteIncomplete),
                               for: .touchUpInside)
        buttonWithPhoto.addTarget(self,
                                  action: #selector(selectorTapped),
                                  for: .touchUpInside)
        buttonWithoutPhoto.addTarget(self,
                                     action: #selector(selectorTapped),
                                     for: .touchUpInside)
        scrollView.addGestureRecognizer(gesture)
        gesture.addTarget(self,
                          action: #selector(tapScrollView))
    }
    @objc func selectorTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            isHiddenSelectImage(false)
        case 2:
            isHiddenSelectImage(true)
        default:
            break
        }
    }
    private func isHiddenSelectImage(_ dool: Bool) {
        if dool {
            isSelectPhoto = true
            checkSelector()
            buttonWithPhoto.backgroundColor = .clear
            buttonWithPhoto.setTitleColor(.lightGray,
                                          for: .normal)
            buttonWithoutPhoto.backgroundColor = .white
            buttonWithoutPhoto.setTitleColor(.black,
                                             for: .normal)
            selectImage = nil
            UIView.animate(withDuration: 0.7) { [weak self] in
                self?.imageSelectView.alpha = 0
                self?.photoButton.alpha = 0
                self?.galaryButton.alpha = 0
                self?.cropButton.alpha = 0
                self?.imageSelectView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self?.view.layoutIfNeeded()
            }
        } else {
            isSelectPhoto = false
            checkSelector()
            buttonWithPhoto.backgroundColor = .white
            buttonWithPhoto.setTitleColor(.black,
                                          for: .normal)
            buttonWithoutPhoto.backgroundColor = .clear
            buttonWithoutPhoto.setTitleColor(.lightGray,
                                             for: .normal)
            selectImage = previewImage.image
            if selectImage != nil {
                isSelectPhoto = true
                checkSelector()
            }
            UIView.animate(withDuration: 0.7) { [weak self] in
                self?.imageSelectView.alpha = 1
                self?.photoButton.alpha = 1
                self?.galaryButton.alpha = 1
                self?.cropButton.alpha = 1
                self?.imageSelectView.snp.updateConstraints { make in
                    make.height.equalTo(230)
                }
                self?.view.layoutIfNeeded()
            }
        }
    }
    @objc func deleteIncomplete() {
        if let data = incompleteModel {
            viewModel?.removeIncompleteData(id: Int(data.id))
        }
        navigationController?.popViewController(animated: true)
    }
    @objc func tapScrollView() {
        scrollView.endEditing(true)
    }
    @objc func generationVideo() {
        viewModel?.viewAnimate(view: generationButton,
                               duration: 0.2,
                               scale: 0.97)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            if let data = incompleteModel {
                viewModel?.removeIncompleteData(id: Int(data.id))
            }
            let data = TextToVideoData(duration: selectDuration,
                                       ratio: cropType,
                                       description: descriptionTextView.text,
                                       image: cropImage,
                                       strUrl: videoStrUrl,
                                       models: modelsValue,
                                       type: modelsType,
                                       durationType: durationType,
                                       credits: 0)
            chekGenerate(data)
            model = data
            if selectImage == nil {
                viewModel?.requestImageToVideoStatus(model: data,
                                                     type: .textToVideo,
                                                     delegate: self)
            } else {
                viewModel?.requestImageToVideoStatus(model: data,
                                                     type: .imageToVideo,
                                                     delegate: self)
            }
            isLoader(true,
                     model: data)
        }
    }
    func checkSelector() {
        if isSelectPhoto && isPromt == true {
            generationButton.isEnabled = true
            generationButton.alpha = 1
        } else {
            generationButton.isEnabled = false
            generationButton.alpha = 0.5
        }
    }
    func isLoader(_ bool: Bool,
                  model: TextToVideoData?) {
        if bool == true {
            loaderView.loading = true
            loaderView.viewModel = viewModel
            loaderView.selector = .textImageToVideo
            loaderView.isHidden = false
            loaderView.textToVideoData = model
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
//            pc.mediaTypes = ["public.image",
//                             "public.movie"]
            pc.mediaTypes = ["public.image"]
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
    @objc func openCrop() {
        viewModel?.viewAnimate(view: cropButton,
                               duration: 0.2,
                               scale: 0.97)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            viewModel?.openCropImageController(image: selectImage,
                                               delegate: self,
                                               cropType: cropType)
        }
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    private func selectPhotos() {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
//        configuration.filter = .any(of: [.images,
//                                        .videos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker,
                animated: true)
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
                                                 popover: selectorView) {
            present(errorAlert,
                    animated: true)
        }
    }
    @objc func willShow(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -145
        }
    }
    @objc func willHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func addConstraints() {
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerTitle.snp.makeConstraints { make in
            make.right.equalTo(deleteButton.snp.left).inset(-5)
            make.left.equalTo(backButton.snp.right).inset(-5)
            make.centerY.equalTo(backButton.snp.centerY)
            make.height.equalTo(20)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalTo(backButton.snp.centerY)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(100)
        }
        
        conteinerView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        selectorView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.width.greaterThanOrEqualTo(150)
        }
        buttonWithPhoto.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(2)
            make.height.equalToSuperview().inset(2)
            make.right.equalTo(selectorView.snp.centerX).offset(-2)
        }
        buttonWithPhoto.titleLabel?.snp.makeConstraints({ make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
        })
        buttonWithoutPhoto.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-2)
            make.height.equalToSuperview().inset(2)
            make.left.equalTo(selectorView.snp.centerX).offset(2)
        }
        buttonWithoutPhoto.titleLabel?.snp.makeConstraints({ make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
        })
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(conteinerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
        
        imageSelectView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(deleteButton.snp.right).offset(20)
            make.height.equalTo(230)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        previewVodeo.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(55)
            make.height.equalTo(230)
        }
        previewImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        photoButton.snp.makeConstraints { make in
            make.top.equalTo(imageSelectView.snp.top).offset(10)
            make.width.height.equalTo(53)
            make.right.equalTo(imageSelectView.snp.right).inset(10)
        }
        galaryButton.snp.makeConstraints { make in
            make.top.equalTo(photoButton.snp.bottom).offset(10)
            make.width.height.equalTo(53)
            make.right.equalTo(imageSelectView.snp.right).inset(10)
        }
        cropButton.snp.makeConstraints { make in
            make.top.equalTo(galaryButton.snp.bottom).offset(10)
            make.width.height.equalTo(53)
            make.right.equalTo(imageSelectView.snp.right).inset(10)
        }
        
        selecModel.snp.makeConstraints { make in
            make.top.equalTo(imageSelectView.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
        durationView.snp.makeConstraints { make in
            make.top.equalTo(selecModel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.top.equalTo(durationView.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(200)
        }
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        descriptionPlaceholder.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(23)
            make.width.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(20)
        }
        
        generationButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(descriptionView.snp.bottom).offset(40)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottom.equalToSuperview().inset(20)
        }
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension TextToImageController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        descriptionTextView.text = textView.text
        if textView.text.isEmpty {
            generationButton.isEnabled = false
            generationButton.alpha = 0.5
            descriptionPlaceholder.isHidden = false
        } else {
            generationButton.isEnabled = true
            generationButton.alpha = 1
            descriptionPlaceholder.isHidden = true
            isPromt = true
            checkSelector()
        }
    }
}
extension TextToImageController: PHPickerViewControllerDelegate {
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
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            previewImage.isHidden = false
                            previewVodeo.isHidden = true
                            imageSelectView.backgroundColor = HomeConstants.HomeColor.customGrayColor
                            selectImage = image
                            cropImage = image
                            previewImage.image = image
                            cropButton.isHidden = false
                            activityIndicator.stopAnimating()
                            view.endEditing(true)
                            isSelectPhoto = true
                            checkSelector()
                        }
                    }
                }
            } else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
                    guard let url = url else { return }
                    if let fileURL = self?.viewModel?.saveTemporaryFile(url) {
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            cropButton.isHidden = true
                            previewImage.isHidden = true
                            selectImage = nil
                            cropImage = nil
                            previewVodeo.isHidden = false
                            imageSelectView.backgroundColor = .black
                            videoStrUrl = fileURL.absoluteString
                            activityIndicator.stopAnimating()
                            setupPlayer(url: fileURL)
                        }
                    }
                }
            }
        }
    }
}
extension TextToImageController: UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let image = info[.originalImage] as? UIImage { // photo
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    previewImage.isHidden = false
                    previewVodeo.isHidden = true
                    imageSelectView.backgroundColor = HomeConstants.HomeColor.customGrayColor
                    selectImage = image
                    cropImage = image
                    previewImage.image = image
                    cropButton.isHidden = false
                    view.endEditing(true)
                    isSelectPhoto = true
                    checkSelector()
                }
            } else if let videoURL = info[.mediaURL] as? URL { // video
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    previewImage.isHidden = true
                    cropButton.isHidden = true
                    selectImage = nil
                    cropImage = nil
                    previewVodeo.isHidden = false
                    imageSelectView.backgroundColor = .black
                    videoStrUrl = videoURL.absoluteString
                    setupPlayer(url: videoURL)
                }
            }
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
extension TextToImageController: CropViewDelegate {
    func didCropImage(_ image: UIImage?,
                      type: CropEnum) {
        cropType = type
        cropImage = image
        previewImage.image = image
    }
}
extension TextToImageController: DurationDelegate {
    func setValue(value: String,
                  duration: DurationGenerate) {
        durationValue = value
        selectDuration = value
        durationType = duration
    }
}
extension TextToImageController: SelectModelDelgate {
    func selectModel(_ model: ModelsToCreate) {
        modelsType = model
        switch model {
        case .dinsonPro:
            modelsValue = "kling-video" // Dinson Pro
            showDuration(true)
        case .dinsonStandart:
            modelsValue = "kling-video" // Dinson Standart
            showDuration(false)
        case .natash:
            modelsValue = "minimax-video" // Natash
            showDuration(false)
        case .none:
            break
        }
    }
    func isShowView(_ bool: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            if bool {
                self?.shadowView.alpha = 0.5
            } else {
                self?.shadowView.alpha = 0
            }
        }
    }
    private func showDuration(_ bool: Bool) {
        if bool {
            UIView.animate(withDuration: 0.7) { [weak self] in
                guard let self else { return }
                durationView.alpha = 1
                durationView.snp.updateConstraints { make in
                    make.top.equalTo(self.selecModel.snp.bottom).offset(10)
                    make.height.equalTo(100)
                }
                view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.7) { [weak self] in
                guard let self else { return }
                durationView.alpha = 0
                durationView.snp.updateConstraints { make in
                    make.top.equalTo(self.selecModel.snp.bottom).offset(0)
                    make.height.equalTo(0)
                }
                view.layoutIfNeeded()
            }
        }
    }
}
extension TextToImageController: RequestDelegate {
    func getResult(data: ResponseData?) {}
    func getAIText(data: ScriptData?) {}
    func getResultVideoToVideo() {}
    func error() {
        errorGenefation()
    }
    func getResultTextToVideo(_ data: TextToImageResponse?) {
        if data == nil {
            errorGenefation()
        } else {
            if let strUrl = data?.fileURL,
               let url = URL(string: strUrl) {
                viewModel?.downloadVideo(url,
                                         completion: { docUrl in
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        viewModel?.openResultViewController(baseModel: nil,
                                                            tToVModel: model,
                                                            vToVmodel: nil,
                                                            data: nil,
                                                            fileURL: docUrl,
                                                            selector: .textImageToVideo)
                        let credits = defaults.integer(forKey: key) // списание кредитов
                        viewModel?.updateCredits(isAdd: false,
                                                 credits: credits)
                        isLoader(false,
                                 model: nil)
                    }
                })
            }
        }
    }
    func errorGenefation() {
        let action = UIAlertAction(title: "Ok",
                                   style: .cancel) { [weak self] _ in
            self?.isLoader(false,
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
extension TextToImageController: RequestStatusDelegate {
    func getStatus(value: Int?) {
        guard let value else { return }
        if value < 99 {
            DispatchQueue.main.async { [weak self] in
                self?.loaderView.progressTitle.text = "\(value)%"
            }
        }
    }
}
extension TextToImageController {
    func chekGenerate(_ data: TextToVideoData) { // запоминает сколько кредитов стоит генерация
        switch data.type {
        case .dinsonPro:
            switch data.durationType {
            case .seconds5:
                defaults.setValue(data.durationType.credits,
                                  forKey: key)
            case .seconds10:
                defaults.setValue(data.durationType.credits,
                                  forKey: key)
            case .none, .key:
                break
            }
        case .dinsonStandart:
            let credits = 10
            defaults.setValue(credits,
                              forKey: key)
        case .natash:
            let credits = 10
            defaults.setValue(credits,
                              forKey: key)
        case .none:
            break
        }
    }
}
