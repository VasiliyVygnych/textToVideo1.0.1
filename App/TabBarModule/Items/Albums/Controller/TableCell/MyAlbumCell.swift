//
//  MyAlbumCell.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit
import SnapKit

class MyAlbumCell: UITableViewCell {
    
    let swipeGesture = UISwipeGestureRecognizer()
    let tapGesture = UITapGestureRecognizer()
    var viewModel: AlbumViewModelProtocol?
    var albumContents: [AlbumContents]?
    var views = UIViewController()
    weak var delegate: CellDelegate?
    var model: AlbumsData?
    
    private var conteinerCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    private var nameAlbumTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 15,
                                 weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    private var arrowImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "doneImage")
        return view
    }()
    private var countView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 9
        return view
    }()
    private var videoCountTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 14,
                                weight: .medium)
        view.textAlignment = .center
        return view
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 160,
                                height: 81)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = .init(top: 5,
                                    left: 5,
                                    bottom: 5,
                                    right: 5)
        return layout
    }()
    lazy var collectionView: UICollectionView = {
       let view = UICollectionView(frame: .zero,
                                             collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.allowsSelection = false
        view.isUserInteractionEnabled = false
        return view
   }()
    
    var removeButton: UIButton = {
       let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        return view
    }()
    var removeImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        addSubview()
        сreatedConstraints()
        setupeCollection()
        setupeView()
        removeImage.image = HomeConstants.HomeImage.remove
        contentView.backgroundColor = AlbumConstants.AlbumColor.backgroundColor
        conteinerCell.addGestureRecognizer(swipeGesture)
        swipeGesture.addTarget(self,
                               action: #selector(show))
        swipeGesture.direction = .left
        removeButton.addTarget(self,
                               action: #selector(removeAlbum),
                               for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupeView() {
        conteinerCell.backgroundColor = AlbumConstants.AlbumColor.customGrayColor
        arrowImage.image = AlbumConstants.AlbumImage.chevronRight
        countView.backgroundColor = AlbumConstants.AlbumColor.colorWhite11
    }
    private func setupeCollection() {
        collectionView.register(MyVideoCollection.self,
                                forCellWithReuseIdentifier: "myCollection")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func configure(_ model: AlbumsData) {
        nameAlbumTitle.text = model.nameAlbum
        if let nameId = model.nameId {
            albumContents = viewModel?.getAlbumContents(nameID: nameId)
        }
        videoCountTitle.text = String(albumContents?.count ?? 0)
        collectionView.reloadData()
    }
    @objc func removeAlbum() {
        viewModel?.removeAlbumsData(id: Int(model?.id ?? 0))
        delegate?.reloadData()
        hide()
    }
    @objc func show(_ swipe: UISwipeGestureRecognizer) {
        removeButton.isHidden = false
        conteinerCell.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self,
                             action: #selector(hide))
        conteinerCell.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(-60)
            make.height.equalTo(150)
        }
    }
    @objc func hide() {
        removeButton.isHidden = true
        conteinerCell.removeGestureRecognizer(tapGesture)
        conteinerCell.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(150)
        }
    }
}
private extension MyAlbumCell {
    func addSubview() {
        contentView.addSubview(conteinerCell)
        conteinerCell.addSubview(nameAlbumTitle)
        conteinerCell.addSubview(arrowImage)
        conteinerCell.addSubview(countView)
        countView.addSubview(videoCountTitle)
        conteinerCell.addSubview(collectionView)
        
        contentView.addSubview(removeButton)
        removeButton.addSubview(removeImage)
    }
    func сreatedConstraints() {
        conteinerCell.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(150)
            make.centerY.equalToSuperview()
        }
        nameAlbumTitle.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(15)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(200)
        }
        countView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.left.equalTo(nameAlbumTitle.snp.right).inset(-10)
            make.centerY.equalTo(nameAlbumTitle.snp.centerY)
        }
        videoCountTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(countView)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        arrowImage.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.width.height.equalTo(27)
            make.right.equalTo(-15)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(nameAlbumTitle.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(150)
            make.left.equalTo(conteinerCell.snp.right).inset(-10)
        }
        removeImage.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(removeButton)
            make.width.height.equalTo(60)
        }
    }
}
extension MyAlbumCell: UICollectionViewDelegate,
                               UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        albumContents?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollection",
                                                               for: indexPath) as? MyVideoCollection,
                 let model = albumContents?[indexPath.row] else { return UICollectionViewCell() }
        cell.viewModel = viewModel
        cell.views = views
        cell.configure(model)
        cell.views = views
        return cell
    }
}
