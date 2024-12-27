//
//  BasicWorkflowsPlugin.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import UIKit
import SnapKit
import MediaPlayer
import MobileCoreServices

class BasicWorkflowsPlugin: UIViewController {
    
    var pluginMode = PluginMode.none
    var viewModel: HomeViewModelProtocol?
    weak var delegate: PluginDelegate?
    private var gesture = UITapGestureRecognizer()
    private var contentSize: CGSize {
        CGSize(width: view.frame.width,
               height: view.frame.height)
    }
    var isDescription = false
    var isMusic = false
    var model: BaseData?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear
        view.contentSize = contentSize
        return view
    }()

    private var durationTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    private var durationView: UIButton = {
       let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var durationArrow: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    private var durationSeparatorView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var durationValue: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
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
        view.layer.cornerRadius = 12
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
    
    private var musicTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    private var musicView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var musicNameTextField: UITextField = {
       let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 17,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .left
        view.keyboardType = .default
        return view
    }()
    private var musicPlaceholder: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .medium)
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    
    private var uploadMusicButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.titleLabel?.font = .systemFont(ofSize: 12,
                                            weight: .semibold)
        return view
    }()
    
    private var aspectRatioTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    private var aspectRatioView: UIButton = {
       let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var aspectRatioArrow: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    private var aspectRatioSeparatorView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var aspectRatioValue: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()

    private var saveButton: UIButton = {
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
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        addConstraints()
        setupeButton()
        registerdNotificftion()
        switch pluginMode {
        case .none, .basicWorkflows:
            break
        case .scriptToVideo:
            break
        case .youtubeShorts:
            aspectRatioTitle.isHidden = true
            aspectRatioView.isHidden = true
            durationTitle.text = HomeConstants.HomeText.durationTitleYouTube.localized(LanguageConstant.appLaunguage)
            aspectRatioValue.text = "9:16"
        case .instagramReels:
            aspectRatioTitle.isHidden = true
            durationTitle.text = HomeConstants.HomeText.durationTitleInstagram.localized(LanguageConstant.appLaunguage)
            aspectRatioValue.text = "9:16"
            durationView.isHidden = true
            durationTitle.isHidden = true
            aspectRatioView.isHidden = true
        }
        if model?.description?.isEmpty == false {
            setupeEditData(model)
        }
        hideMusic()
        hideDuration()
    }
    func setupeEditData(_ data: BaseData?) {
        durationValue.text = data?.duration
        descriptionTextView.text = data?.description
        musicNameTextField.text = data?.music
        aspectRatioValue.text = data?.ratio
        descriptionPlaceholder.isHidden = true
        musicPlaceholder.isHidden = true
    }
    private func setupeSubview() {
        view.addSubview(scrollView)
        scrollView.addSubview(durationTitle)
        scrollView.addSubview(durationView)
        durationView.addSubview(durationArrow)
        durationView.addSubview(durationSeparatorView)
        durationView.addSubview(durationValue)
        
        scrollView.addSubview(descriptionTitle)
        scrollView.addSubview(descriptionView)
        descriptionView.addSubview(descriptionTextView)
        descriptionTextView.delegate = self
        descriptionView.addSubview(descriptionPlaceholder)
        
        scrollView.addSubview(musicTitle)
        scrollView.addSubview(musicView)
        scrollView.addSubview(uploadMusicButton)
        musicView.addSubview(musicNameTextField)
        musicNameTextField.delegate = self
        musicView.addSubview(musicPlaceholder)
        
        
        scrollView.addSubview(aspectRatioTitle)
        scrollView.addSubview(aspectRatioView)
        aspectRatioView.addSubview(aspectRatioArrow)
        aspectRatioView.addSubview(aspectRatioSeparatorView)
        aspectRatioView.addSubview(aspectRatioValue)
        
        view.addSubview(saveButton)
        checkValidInput()
    }
    private func hideDuration() {
        durationTitle.isHidden = true
        durationView.isHidden = true
        durationView.snp.updateConstraints { make in
            make.top.equalTo(durationTitle.snp.bottom).offset(-50)
            make.height.equalTo(30)
        }
    }
    private func hideMusic() {
        uploadMusicButton.isHidden = true
        musicTitle.isHidden = true
        musicView.isHidden = true
        isMusic = true
        musicView.snp.updateConstraints { make in
            make.top.equalTo(musicTitle.snp.bottom).offset(-40)
            make.height.equalTo(30)
        }
    }
    func checkValidInput() {
        if model == nil {
            if isDescription && isMusic == true {
                saveButton.isEnabled = true
                saveButton.alpha = 1
            } else {
                saveButton.isEnabled = false
                saveButton.alpha = 0.3
            }
        } else {
            saveButton.isEnabled = true
            saveButton.alpha = 1
        }
    }
    private func setupeText() {
        durationTitle.text = HomeConstants.HomeText.durationTitle.localized(LanguageConstant.appLaunguage)
        descriptionTitle.text = HomeConstants.HomeText.descriptionTitle.localized(LanguageConstant.appLaunguage)
        musicTitle.text = HomeConstants.HomeText.musicTitle.localized(LanguageConstant.appLaunguage)
        aspectRatioTitle.text = HomeConstants.HomeText.aspectRatioTitle.localized(LanguageConstant.appLaunguage)
        saveButton.setTitle(HomeConstants.HomeText.saveChanges.localized(LanguageConstant.appLaunguage),
                            for: .normal)
        descriptionPlaceholder.text = HomeConstants.HomeText.descriptionPlaceholder.localized(LanguageConstant.appLaunguage)
        uploadMusicButton.setTitle(HomeConstants.HomeText.uploadMusicButton.localized(LanguageConstant.appLaunguage),
                                   for: .normal)
        musicPlaceholder.text = HomeConstants.HomeText.musicPlaceholder.localized(LanguageConstant.appLaunguage)
        
    }
    private func setupeColor() {
        durationTitle.textColor = HomeConstants.HomeColor.colorWhite77
        durationView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        descriptionTitle.textColor = HomeConstants.HomeColor.colorWhite77
        descriptionView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        musicTitle.textColor = HomeConstants.HomeColor.colorWhite77
        musicView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        aspectRatioTitle.textColor = HomeConstants.HomeColor.colorWhite77
        aspectRatioView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        saveButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        durationSeparatorView.backgroundColor = HomeConstants.HomeColor.colorGray14
        descriptionTextView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        descriptionPlaceholder.textColor = HomeConstants.HomeColor.colorWhite46
        uploadMusicButton.setTitleColor(HomeConstants.HomeColor.customBlueColor,
                                        for: .normal)
        musicPlaceholder.textColor = HomeConstants.HomeColor.colorWhite46
        aspectRatioSeparatorView.backgroundColor = HomeConstants.HomeColor.colorGray14
    }
    private func setupeData() {
        durationArrow.image = HomeConstants.HomeImage.arrowDown
        aspectRatioArrow.image = HomeConstants.HomeImage.arrowDown
        durationValue.text = HomeConstants.HomeText.firstDurationValue.localized(LanguageConstant.appLaunguage)
        aspectRatioValue.text = "9:16"
    }
    private func setupeButton() {
        saveButton.addTarget(self,
                             action: #selector(saveChanges),
                             for: .touchUpInside)
        uploadMusicButton.addTarget(self,
                                    action: #selector(uploadMusik),
                                    for: .touchUpInside)
        aspectRatioView.addTarget(self,
                                  action: #selector(openSeelctRatio),
                                  for: .touchUpInside)
        durationView.addTarget(self,
                               action: #selector(openSeelctDuration),
                               for: .touchUpInside)
        scrollView.addGestureRecognizer(gesture)
        gesture.addTarget(self,
                          action: #selector(tapScrollView))
    }
    @objc func openSeelctRatio() {
        UIView.animate(withDuration: 0.2) {
            self.aspectRatioArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            if let value = self.aspectRatioValue.text {
                viewModel?.openAspectRatioController(selectValue: value,
                                                     view: self,
                                                     delegate: self)
            }
        }
    }
    @objc func openSeelctDuration() {
        UIView.animate(withDuration: 0.2) {
            self.durationArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {  [self] in
            if let value = self.durationValue.text {
                self.viewModel?.openSelectDurationController(view: self,
                                                             selectValue: value,
                                                             pluginMode: self.pluginMode,
                                                             delegate: self)
            }
        }
    }
    @objc func uploadMusik() {
        selectingMusicFromFiles()
    }
    private func selectingMusicFromFiles() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio],
                                                            asCopy: true)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker,
                animated: true)
    }
    private func choosingMusicFromAppleMusic() {
        let documentPicker = MPMediaPickerController(mediaTypes: .anyAudio)
        documentPicker.allowsPickingMultipleItems = false
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker,
                animated: true)
    }
    @objc func tapScrollView() {
        scrollView.endEditing(true)
    }
    @objc func saveChanges() {
        viewModel?.viewAnimate(view: saveButton,
                               duration: 0.2,
                               scale: 0.96)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [self] in
            self.dismiss(animated: true)
        }
    }
    deinit {
        removeNotofocation()
        let data = BaseData(id: nil,
                             mode: pluginMode,
                             duration: durationValue.text,
                             ratio: aspectRatioValue.text,
                             description: descriptionTextView.text,
                             descriptionAI: nil,
                             music: musicNameTextField.text)
        delegate?.dataForVideoGeneration(data: data)
    }
    private func addConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
        durationTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        durationView.snp.makeConstraints { make in
            make.top.equalTo(durationTitle.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        durationArrow.snp.makeConstraints { make in
            make.centerY.equalTo(durationView)
            make.right.equalTo(-15)
            make.width.height.equalTo(24)
        }
        durationSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.right.equalTo(durationArrow.snp.left).inset(-15)
        }
        durationValue.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalTo(durationView)
            make.height.equalTo(20)
            make.right.equalTo(durationSeparatorView.snp.left).inset(-10)
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
        
        musicTitle.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        musicView.snp.makeConstraints { make in
            make.top.equalTo(musicTitle.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        musicNameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(25)
            make.height.equalTo(20)
        }
        musicPlaceholder.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(25)
            make.height.greaterThanOrEqualTo(20)
        }
        uploadMusicButton.snp.makeConstraints { make in
            make.centerY.equalTo(musicTitle.snp.centerY)
            make.right.equalTo(musicView.snp.right)
            make.height.equalTo(30)
            make.width.lessThanOrEqualTo(150)
        }
        
        aspectRatioTitle.snp.makeConstraints { make in
            make.top.equalTo(musicView.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        aspectRatioView.snp.makeConstraints { make in
            make.top.equalTo(aspectRatioTitle.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualToSuperview().inset(100)
        }
        aspectRatioArrow.snp.makeConstraints { make in
            make.centerY.equalTo(aspectRatioView)
            make.right.equalTo(-15)
            make.width.height.equalTo(24)
        }
        aspectRatioSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.right.equalTo(aspectRatioArrow.snp.left).inset(-15)
        }
        aspectRatioValue.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalTo(aspectRatioView)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(100)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(20)
        }
    }
}
extension BasicWorkflowsPlugin: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        descriptionTextView.text = textView.text
        if textView.text.isEmpty {
            isDescription = false
            checkValidInput()
            descriptionPlaceholder.isHidden = false
        } else {
            isDescription = true
            checkValidInput()
            descriptionPlaceholder.isHidden = true
        }
    }
}
extension BasicWorkflowsPlugin: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField,
                  shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range,
                                                               with: string)
        if textField == musicNameTextField {
            musicNameTextField.text = newString
            if newString.isEmpty {
                isMusic = false
                musicPlaceholder.isHidden = false
            } else {
                musicPlaceholder.isHidden = true
                isMusic = true
                checkValidInput()
            }
        }
       return false
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func registerdNotificftion() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    func removeNotofocation() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    @objc func willShow(_ notification: Notification) {
        if musicNameTextField.isFirstResponder {
            view.frame.origin.y = -120
        }
    }
    @objc func willHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
}
extension BasicWorkflowsPlugin: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
//        UserDefaults.standard.set(url,
//                                  forKey: "musicURL") // test
        
        isMusic = true
        checkValidInput()
        let fileName = url.lastPathComponent
        let modifiedString = String(fileName.dropLast(4))
        let cleanedString = modifiedString.replacingOccurrences(of: "_",
                                                                with: "")
        let cleaned = cleanedString.replacingOccurrences(of: "-",
                                                         with: " ")
        let nameSong = cleaned.removingDigits()
        musicNameTextField.text = nameSong
        musicPlaceholder.isHidden = true
        isMusic = true
        checkValidInput()
    }
}
extension BasicWorkflowsPlugin: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        dismiss(animated: true)
        if let mediaItem = mediaItemCollection.items.first {
            musicNameTextField.text = mediaItem.title
            musicPlaceholder.isHidden = true
            isMusic = true
            checkValidInput()
            if let url = mediaItem.assetURL {
                print("Выбранная песня: \(url)")
            }
        }
    }
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true)
    }
}
extension BasicWorkflowsPlugin: ParametersDelegate {
    func setDuration(value: String,
                     duration: DurationGenerate) {
        durationValue.text = value
    }
    
    func defaultArrow() {
        UIView.animate(withDuration: 0.2) {
            self.aspectRatioArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
            self.durationArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
        }
    }
    func setRatio(value: String) {
        aspectRatioValue.text = value
    }
    func setModel(model: ModelsToCreate) {}
}

extension String {
    func removingDigits() -> String {
        return self.replacingOccurrences(of: "[0-9]", with: "",
                                         options: .regularExpression)
    }
}
