//
//  SavedVideoCell.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit
import SnapKit

class SavedVideoCell: UITableViewCell {
    
    let swipeGesture = UISwipeGestureRecognizer()
    let tapGesture = UITapGestureRecognizer()
    weak var delegate: CellDelegate?
    var viewModel: HomeViewModelProtocol?
    var albumViewModel: AlbumViewModelProtocol?
    var model: SavedVideos?
    var albumModel: AlbumContents?
    
    var conteinerView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    var nameTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
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
        view.font = .systemFont(ofSize: 13,
                                weight: .semibold)
        view.textAlignment = .center
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
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        addSubview()
        сreatedConstraints()
        removeButton.backgroundColor = AlbumConstants.AlbumColor.backgroundColor
        contentView.backgroundColor = AlbumConstants.AlbumColor.backgroundColor
        addImage.image = UIImage(systemName: "checkmark.square.fill")
        playImage.image = UIImage(named: "playImage")
        addImage.tintColor = AlbumConstants.AlbumColor.customBlueColor
        removeImage.image = HomeConstants.HomeImage.remove
        
        conteinerView.addGestureRecognizer(swipeGesture)
        swipeGesture.addTarget(self,
                               action: #selector(show))
        swipeGesture.direction = .left
        removeButton.addTarget(self,
                               action: #selector(removeVideo),
                               for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(_ model: SavedVideos,
                   view: UIViewController) {
        nameTitle.text = model.title
        timeTitle.text = model.duration
        conteinerView.image = UIImage(data: model.previewImage)
    }
    func configureAlbum(_ model: AlbumContents,
                        view: UIViewController) {
        nameTitle.text = model.title
        timeTitle.text = model.duration
        conteinerView.image = UIImage(data: model.previewImage)
    }
    @objc func removeVideo() {
        if model == nil {
            if let nameAlbum = albumModel?.idNameAlbum {
                albumViewModel?.removeItemsinAlbum(idNameAlbum: nameAlbum)
            }
        } else {
            viewModel?.removeSavedVideos(id: Int(model?.id ?? 0))
        }
        delegate?.reloadData()
        hide()
    }
    @objc func show(_ swipe: UISwipeGestureRecognizer) {
        removeButton.isHidden = false
        conteinerView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self,
                             action: #selector(hide))
        conteinerView.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(-60)
            make.height.equalTo(178)
        }
    }
    @objc func hide() {
        removeButton.isHidden = true
        conteinerView.removeGestureRecognizer(tapGesture)
        conteinerView.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(178)
        }
    }
}
private extension SavedVideoCell {
    func addSubview() {
        contentView.addSubview(conteinerView)
        contentView.addSubview(nameTitle)
        contentView.addSubview(timeView)
        contentView.addSubview(timeTitle)
        contentView.addSubview(removeButton)
        removeButton.addSubview(removeImage)
        contentView.addSubview(addImage)
        addImage.isHidden = true
        
        conteinerView.addSubview(playImage)
    }
    func сreatedConstraints() {
        conteinerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(178)
        }
        nameTitle.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(100)
            make.left.equalTo(conteinerView.snp.left).inset(20)
            make.height.greaterThanOrEqualTo(20)
            make.bottom.equalToSuperview().inset(20)
        }
        timeView.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.right.equalTo(conteinerView.snp.right).inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        timeTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(timeView)
            make.left.equalTo(timeView.snp.left).inset(15)
            make.right.equalTo(timeView.snp.right).inset(15)
        }
        removeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(178)
            make.left.equalTo(conteinerView.snp.right).inset(-10)
        }
        removeImage.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(removeButton)
            make.width.height.equalTo(60)
        }
        addImage.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalToSuperview().inset(15)
            make.right.equalTo(conteinerView.snp.right).inset(15)
        }
        
        playImage.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(39)
        }
    }
}
