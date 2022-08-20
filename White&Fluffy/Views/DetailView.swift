//
//  DetailView.swift
//  White&Fluffy
//
//  Created by Lev on 01.08.2022.
//

import UIKit

protocol DetailViewDelegate: AnyObject {
    func tapSender(photos: [UIImage])//, sender: UIBarButtonItem)
}

class DetailView: UIView {
    
    public var tapHandler: (() -> Void)?
    weak var delegate: DetailViewDelegate?
    
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.backgroundColor = .red
        photoView.sizeToFit()
        photoView.clipsToBounds = true
        return photoView
    }()
    
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.boldSystemFont(ofSize: 20)
        authorLabel.textColor = .black
        authorLabel.numberOfLines = 2
        return authorLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    lazy var likeButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        button.tintColor = .systemGray5
        button.alpha = 0.8
        button.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up.circle.fill"), for: .normal)
        button.tintColor = .systemYellow
        button.addTarget(self, action: #selector(tapSendButton), for: .touchUpInside)
        return button
    }()
    
    private let downloadsLabel: UILabel = {
        let viewsLabel = UILabel()
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.font = UIFont.systemFont(ofSize: 14)
        viewsLabel.textColor = .systemGray
        return viewsLabel
    }()
    
    private let dateLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        likesLabel.textColor = .systemGray
        return likesLabel
    }()
    
    private let locationLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        likesLabel.textColor = .systemGray
        return likesLabel
    }()
    
    func setupView(model: DetailModel) {
        guard let urlPhoto = URL(string: model.fotoUrl) else {
            return }
        photoView.sd_setImage(with: urlPhoto) { _,_,_,_ in
            if let widthImage = self.photoView.image?.size.width {
                let ratio = (self.photoView.image?.size.height)! / (widthImage / UIScreen.main.bounds.width)
                self.photoView.heightAnchor.constraint(equalToConstant: ratio).isActive = true
            }
        }
        authorLabel.text = "Author:" + model.author
        descriptionLabel.text = "Description:" + model.description
        dateLabel.text = "Date:" + model.date
        locationLabel.text = "Location:" + model.location
        downloadsLabel.text = "Downloads:" + model.downloads
        likeButton.tintColor = model.likePressed ? .red : .systemGray5
    }
    
    
    private func layout(){
        
        [photoView,
         authorLabel,
         descriptionLabel,
         downloadsLabel,
         likeButton,
         dateLabel,
         locationLabel,
         sendButton].forEach { self.addSubview($0) }
        
        let inset: CGFloat = 10
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: self.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: inset),
            authorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            authorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: inset),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: inset),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            locationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: inset),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            downloadsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: inset),
            downloadsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset)
        ])
        
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: inset * 2),
            sendButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset * 2),
            sendButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset * 2),
            sendButton.heightAnchor.constraint(equalToConstant: inset * 4),
            sendButton.widthAnchor.constraint(equalTo: self.likeButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: inset * 2),
            likeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset * 2),
            likeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset * 2),
            likeButton.heightAnchor.constraint(equalToConstant: inset * 3),
            likeButton.widthAnchor.constraint(equalTo: self.likeButton.heightAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapLike() {
        tapHandler?()
    }
    
    @objc private func tapSendButton(sender: UIBarButtonItem) {
        guard let photo = photoView.image else { return }
        let sendPhotos = [photo]
        print(photo)
        delegate?.tapSender(photos: sendPhotos) //, sender: sender)
    }
}
