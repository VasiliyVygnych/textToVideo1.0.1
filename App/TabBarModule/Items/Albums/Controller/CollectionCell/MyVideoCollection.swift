//
//  MyVideoCollection.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit
import SnapKit
import AVFoundation
import AVKit

class MyVideoCollection: UICollectionViewCell {
    
    var viewModel: AlbumViewModelProtocol?
    var model: SavedVideos?
    var views = UIViewController()
    
    var conteinerCell: UIImageView = {
         let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
         return view
     }()
    var nameTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 8,
                                 weight: .bold)
        view.textColor = .white
        view.textAlignment = .left
        view.numberOfLines = 0
       return view
    }()
    private var timeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.backgroundColor = .black
        view.alpha = 0.2
        return view
    }()
    private var timeTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 7,
                                weight: .medium)
        view.textAlignment = .center
        return view
    }()
    var addImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    var playImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        initialization()
        setupeConstraint()
        addImage.image = UIImage(systemName: "checkmark.square.fill")
        playImage.image = UIImage(named: "playImage")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureSaveVideo(_ model: SavedVideos) {
        nameTitle.text = model.title
        timeTitle.text = model.duration
        conteinerCell.image = UIImage(data: model.previewImage)
    }
    func configure(_ model: AlbumContents) {
        nameTitle.text = model.title
        timeTitle.text = model.duration
        conteinerCell.image = UIImage(data: model.previewImage)
    }
}
private extension MyVideoCollection {
    func initialization() {
        contentView.addSubview(conteinerCell)
        contentView.addSubview(nameTitle)
        contentView.addSubview(timeView)
        contentView.addSubview(timeTitle)
        contentView.addSubview(addImage)
        addImage.isHidden = true
        
        conteinerCell.addSubview(playImage)
    }
    func setupeConstraint() {
        conteinerCell.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nameTitle.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(30)
            make.left.equalTo(10)
            make.height.lessThanOrEqualTo(20)
            make.bottom.equalToSuperview().inset(5)
        }
        timeView.snp.makeConstraints { make in
            make.height.equalTo(13)
            make.right.equalTo(-5)
            make.bottom.equalToSuperview().inset(5)
        }
        timeTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(timeView)
            make.left.equalTo(timeView.snp.left).inset(5)
            make.right.equalTo(timeView.snp.right).inset(5)
        }
        addImage.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.top.equalToSuperview().inset(5)
            make.right.equalTo(conteinerCell.snp.right).inset(5)
        }
        playImage.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(15)
        }
    }
}
