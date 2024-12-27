//
//  CropImageController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 06.12.2024.
//

import UIKit
import SnapKit

class CropImageController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    weak var delegate: CropViewDelegate?
    var image: UIImage?
    var selectCropType = CropEnum.horizontal
    private let pinchGesture = UIPinchGestureRecognizer()
    private let panGesture = UIPanGestureRecognizer()
    private var currentScale: CGFloat = 1.0
    private let minScale: CGFloat = 0.2
    private let maxScale: CGFloat = 5.0
    
    private var topView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
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
    private var doneButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.titleLabel?.font = .systemFont(ofSize: 18,
                                            weight: .bold)
        return view
    }()
    private var previewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private var hCropButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 25
        view.tag = 1
        return view
    }()
    private var hCropImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    private var hCropTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .center
        return view
    }()
    
    private var hFrameView: UIImageView = { // рамка кропа
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
//        view.backgroundColor = .systemPink
//        view.alpha = 0.5
        return view
    }()
    private var horizonalCrop: UIView = { // границы кропа
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .red
//        view.alpha = 0.5
        return view
    }()

    private var vCropButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 25
        view.tag = 2
        return view
    }()
    private var vCropImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    private var vCropTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .center
        return view
    }()
    private var vFrameView: UIImageView = { // рамка кропа
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
//        view.backgroundColor = .systemOrange
//        view.alpha = 0.5
        return view
    }()
    private var vetricalCrop: UIView = { // границы кропа
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .red
//        view.alpha = 0.5
        return view
    }()
    private var bottomView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        setupeSubview()
        setupeText()
        setupeColor()
        setupeImage()
        addConstraints()
        setupeButton()
        switch selectCropType {
        case .horizontal:
            hCropButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
            vCropButton.backgroundColor = HomeConstants.HomeColor.customGrayColor
            vFrameView.isHidden = true
            hFrameView.isHidden = false
        case .vertical:
            vCropButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
            hCropButton.backgroundColor = HomeConstants.HomeColor.customGrayColor
            hFrameView.isHidden = true
            vFrameView.isHidden = false
        }
    }
    private func setupeSubview() {
        view.addSubview(previewImage)
        
        view.addSubview(topView)
        view.addSubview(hFrameView)
        view.addSubview(vFrameView)
        vFrameView.isHidden = true
        view.addSubview(bottomView)
        
        view.addSubview(vetricalCrop)
        view.addSubview(horizonalCrop)
        
        view.addSubview(headerTitle)
        view.addSubview(backButton)
        view.addSubview(doneButton)
    
        view.addSubview(hCropButton)
        hCropButton.addSubview(hCropImage)
        hCropButton.addSubview(hCropTitle)
        
        view.addSubview(vCropButton)
        vCropButton.addSubview(vCropImage)
        vCropButton.addSubview(vCropTitle)
    }
    private func setupeText() {
        headerTitle.text = "Crop image".localized(LanguageConstant.appLaunguage)
        doneButton.setTitle("Done".localized(LanguageConstant.appLaunguage),
                            for: .normal)
        vCropTitle.text = "768 x 1280"
        hCropTitle.text = "1280 x 768"
    }
    private func setupeColor() {
        headerTitle.textColor = .white
        hCropButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        hCropTitle.textColor = .white
        vCropButton.backgroundColor = HomeConstants.HomeColor.customGrayColor
        vCropTitle.textColor = .white
    }
    private func setupeImage() {
        previewImage.image = image
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
        doneButton.setTitleColor(HomeConstants.HomeColor.customBlueColor,
                                 for: .normal)
        vCropImage.image = UIImage(named: "vCropImageButton")
        hCropImage.image = UIImage(named: "hCropImageButton")
        vCropTitle.textColor = .white
        hCropTitle.textColor = .white
        
        hFrameView.image = UIImage(named: "hFrameCrop")
        vFrameView.image = UIImage(named: "vFrameCrop")
        topView.image = UIImage(named: "flexImage")
        bottomView.image = UIImage(named: "flexImage")
    }
    private func setupeButton() {
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        doneButton.addTarget(self,
                             action: #selector(cropping),
                             for: .touchUpInside)
        hCropButton.addTarget(self,
                              action: #selector(selectCrop),
                              for: .touchUpInside)
        vCropButton.addTarget(self,
                              action: #selector(selectCrop),
                              for: .touchUpInside)
        pinchGesture.addTarget(self,
                               action: #selector(zoomImage))
        view.addGestureRecognizer(pinchGesture)
        panGesture.addTarget(self,
                             action: #selector(scrollImage))
        view.addGestureRecognizer(panGesture)
    }
    @objc func scrollImage(_ gesture: UIPanGestureRecognizer) {
        view.layoutIfNeeded()
        let translation = gesture.translation(in: previewImage)
        if gesture.state == .began || gesture.state == .changed {
            previewImage.center = CGPoint(x: previewImage.center.x + translation.x,
                                         y: previewImage.center.y + translation.y)
            gesture.setTranslation(.zero,
                                    in: previewImage)
        }
    }
    @objc func zoomImage(_ gesture: UIPinchGestureRecognizer) {
        view.layoutIfNeeded()
        if gesture.state == .began || gesture.state == .changed {
            let newScale = currentScale * gesture.scale
                if newScale < minScale {
                    gesture.scale = minScale / currentScale
                } else if newScale > maxScale {
                    gesture.scale = maxScale / currentScale
                } else {
                    previewImage.transform = previewImage.transform.scaledBy(x: gesture.scale,
                                                                             y: gesture.scale)
                currentScale = newScale
                gesture.scale = 1.0
            }
        }
    }
    @objc func cropping() {
        delegate?.didCropImage(cropImage(), type: selectCropType)
        navigationController?.popViewController(animated: false)
    }
    @objc func selectCrop(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            selectCropType = .horizontal
            hCropButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
            vCropButton.backgroundColor = HomeConstants.HomeColor.customGrayColor
            vFrameView.isHidden = true
            hFrameView.isHidden = false
        case 2:
            selectCropType = .vertical
            vCropButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
            hCropButton.backgroundColor = HomeConstants.HomeColor.customGrayColor
            hFrameView.isHidden = true
            vFrameView.isHidden = false
        default:
            break
        }
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: false)
    }
    private func cropImage() -> UIImage? {
        view.layoutIfNeeded()
        var image: UIImage?
        switch selectCropType {
        case .horizontal:
            let visibleRect = horizonalCrop.convert(horizonalCrop.bounds,
                                                    to: previewImage)
            let renderer = UIGraphicsImageRenderer(bounds: visibleRect)
            image = renderer.image { _ in
                previewImage.drawHierarchy(in: previewImage.bounds,
                                           afterScreenUpdates: true)
            }
        case .vertical:
            let visibleRect = vetricalCrop.convert(vetricalCrop.bounds,
                                                   to: previewImage)
            let renderer = UIGraphicsImageRenderer(bounds: visibleRect)
            image = renderer.image { _ in
                previewImage.drawHierarchy(in: previewImage.bounds,
                                           afterScreenUpdates: true)
            }
        }
        return image
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.centerY.equalTo( backButton.snp.centerY)
            make.height.equalTo(20)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
        }
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo( backButton.snp.centerY)
            make.right.equalTo(-20)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(50)
        }
        previewImage.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.bottom.equalTo(hCropButton.snp.top).inset(-20)
        }
        hCropButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(view.snp.centerX).offset(-10)
            make.height.equalTo(50)
            make.bottomMargin.equalToSuperview().inset(20)
        }
        hCropImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.width.equalTo(24)
            make.height.equalTo(16)
        }
        hCropTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(hCropImage.snp.right).inset(-5)
            make.right.equalTo(-5)
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(previewImage.snp.top)
        }
        hFrameView.snp.makeConstraints { make in
            make.top.bottom.equalTo(previewImage)
            make.left.right.equalToSuperview()
        }
        horizonalCrop.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(1)
            make.centerY.equalTo(hFrameView).offset(-10)
            make.height.equalTo(hFrameView.snp.height).multipliedBy(1.0/2.9)
        }
        
        vCropButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.height.equalTo(50)
            make.bottomMargin.equalToSuperview().inset(20)
        }
        vCropImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.width.equalTo(16)
            make.height.equalTo(24)
        }
        vCropTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(vCropImage.snp.right).inset(-5)
            make.right.equalTo(-5)
        }
        
        vFrameView.snp.makeConstraints { make in
            make.top.bottom.equalTo(previewImage)
            make.left.right.equalToSuperview()
        }
        vetricalCrop.snp.makeConstraints { make in
            make.top.bottom.equalTo(vFrameView).inset(1)
            make.left.right.equalToSuperview().inset(10)
        }
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(previewImage.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
