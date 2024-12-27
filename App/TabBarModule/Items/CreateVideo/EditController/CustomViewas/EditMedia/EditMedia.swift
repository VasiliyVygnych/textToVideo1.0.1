//
//  EditMedia.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 11.11.2024.
//

import UIKit
import SnapKit
import PhotosUI

class EditMedia: UIView {
    
    var viewModel: HomeViewModelProtocol?
    private let cellIdentifier = "media"
    private var otherCells = [0]
    private var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var headerTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .regular)
        view.textAlignment = .left
        return view
    }()
    private var selectSegmented: UISegmentedControl = {
        let view = UISegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.selectedSegmentIndex = 0
        return view
    }()
    
    private var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 0.5
        return view
    }()
    private var searchImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    private var searchTextField: UITextField = {
       let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .left
        view.keyboardType = .default
        return view
    }()
    private var placeholderSearch: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .medium)
        view.textAlignment = .left
        return view
    }()
    
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: 160,
                                height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(top: 10,
                                    left: 0,
                                    bottom: 10,
                                    right: 0)

        return layout
    }()
    lazy var collectionView: UICollectionView = {
       let view = UICollectionView(frame: .zero,
                                             collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(MediaCell.self,
                      forCellWithReuseIdentifier: cellIdentifier)
        return view
   }()
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        addSubview()
        setupeText()
        setupeColor()
        setupeData()
        setupeButton()
        setupeConstraints()
        setupeSegmentedControl()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupeSegmentedControl() {
        selectSegmented.selectedSegmentIndex = 0
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15,
                                     weight: .bold),
            .foregroundColor: UIColor.white]
        selectSegmented.setTitleTextAttributes(selectedAttributes,
                                               for: .selected)
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15,
                                     weight: .medium),
            .foregroundColor: UIColor.lightGray as Any]
        selectSegmented.setTitleTextAttributes(normalAttributes,
                                               for: .normal)
    }
    private func addSubview() {
        addSubview(headerTitle)
        
        addSubview(selectSegmented)
        
        addSubview(collectionView)
        collectionView.isUserInteractionEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(searchView)
        searchView.isHidden = true
        searchView.addSubview(searchImage)
        searchView.addSubview(separatorView)
        searchView.addSubview(searchTextField)
        searchTextField.delegate = self
        searchView.addSubview(placeholderSearch)
    }
    func setupeText() {
        placeholderSearch.text = "Search for stock photos and videos"
        headerTitle.text = "Chapter 1 > Media 1"
        selectSegmented.insertSegment(withTitle: HomeConstants.HomeText.libraryTitle.localized(LanguageConstant.appLaunguage),
                                      at: 0,
                                      animated: true)
        selectSegmented.insertSegment(withTitle: HomeConstants.HomeText.stockTitle.localized(LanguageConstant.appLaunguage),
                                      at: 1,
                                      animated: true)
    }
    private func setupeColor() {
        headerTitle.textColor = UIColor(named: "textGrayColor")
        selectSegmented.backgroundColor = HomeConstants.HomeColor.editViewsColor
        selectSegmented.selectedSegmentTintColor = HomeConstants.HomeColor.customBlueColor
        searchView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = HomeConstants.HomeColor.customGrayC4?.cgColor
        separatorView.backgroundColor = HomeConstants.HomeColor.customGrayC4
        placeholderSearch.textColor = HomeConstants.HomeColor.customGrayC4
    }
    private func setupeData() {
        searchImage.image = HomeConstants.HomeImage.searchImage
        images.append(UIImage())
    }
    private func setupeButton() {
        selectSegmented.addTarget(self,
                                  action: #selector(selectSegment),
                                  for: .valueChanged)
    }
    private func selectMedia() {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = .zero
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewModel?.presentController(view: picker)
    }
    @objc func selectSegment(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            collectionView.isHidden = false
            searchView.isHidden = true
        case 1:
            searchView.isHidden = false
            collectionView.isHidden = true
        default:
            break
        }
    }
    private func setupeConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(30)
        }
        selectSegmented.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(selectSegmented.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.bottom.equalToSuperview()
        }
        
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(selectSegmented.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(53)
        }
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.left.equalTo(searchImage.snp.left).inset(-15)
        }
        searchImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.width.height.equalTo(20)
        }
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(separatorView.snp.left).inset(-5)
        }
        placeholderSearch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(separatorView.snp.left).inset(-5)
        }
    }
}
extension EditMedia: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async { [self] in
                            self?.images.append(image)
                            self?.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
extension EditMedia: UITextFieldDelegate {
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
        if textField == searchTextField {
            searchTextField.text = newString
            if newString.isEmpty {
                placeholderSearch.isHidden = false
            } else {
                placeholderSearch.isHidden = true
            }
        }
       return false
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        endEditing(true)
    }
}
extension EditMedia: UICollectionViewDataSource,
                             UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as? MediaCell else { return UICollectionViewCell() }
        self.collectionView.isUserInteractionEnabled = true
        if otherCells.contains(indexPath.item) {
            cell.mediaButton.isHidden = false
            cell.mediaFile.isHidden = true
        } else {
            cell.mediaButton.isHidden = true
            cell.mediaFile.isHidden = false
            cell.mediaFile.image = images[indexPath.item]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let collectionCell = self.collectionView.cellForItem(at: indexPath) {
            let model = images[indexPath.item]
            viewModel?.viewAnimate(view: collectionCell,
                                   duration: 0.2,
                                   scale: 0.96)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if self.otherCells.contains(indexPath.item) {
                    self.selectMedia()
                } else {
                    
                    print(model)
                    
                    
                }
            }
        }
    }
}
