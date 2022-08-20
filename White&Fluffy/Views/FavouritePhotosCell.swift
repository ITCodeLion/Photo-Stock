//
//  FavouritePhotosCell.swift
//  White&Fluffy
//
//  Created by Lev on 22.06.2022.
//

import UIKit

class FavouritePhotosCell: UITableViewCell {
    
    private let viewPost: UIView = {
        let viewPost = UIView()
        viewPost.translatesAutoresizingMaskIntoConstraints = false
        viewPost.backgroundColor = .white
        return viewPost
    }()
    
    private let imagePostView: UIImageView = {
        let imagePostView = UIImageView()
        imagePostView.translatesAutoresizingMaskIntoConstraints = false
        imagePostView.contentMode = .scaleAspectFill
        imagePostView.layer.cornerRadius = 10
        imagePostView.clipsToBounds = true
        return imagePostView
    }()
    
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.text = "AuthorLabel"
        authorLabel.font = UIFont.boldSystemFont(ofSize: 20)
        authorLabel.textColor = .black
        authorLabel.numberOfLines = 2
        return authorLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(_ infoData: FavouriteBase) {
        
        guard let url = URL(string: infoData.urlSmall) else { return }
        imagePostView.sd_setImage(with: url, completed: nil)
        
        authorLabel.text = infoData.user
        
    }
    
    private func layout() {
        
        [viewPost, imagePostView, authorLabel].forEach { contentView.addSubview($0) }
        
        let inset: CGFloat = 16
        
        NSLayoutConstraint.activate([
            viewPost.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewPost.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewPost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewPost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imagePostView.topAnchor.constraint(equalTo: viewPost.topAnchor, constant: inset),
            imagePostView.leadingAnchor.constraint(equalTo: viewPost.leadingAnchor, constant: inset),
            imagePostView.widthAnchor.constraint(equalToConstant: 100),
            imagePostView.heightAnchor.constraint(equalTo: imagePostView.widthAnchor, multiplier: 1.0),
            imagePostView.bottomAnchor.constraint(equalTo: viewPost.bottomAnchor, constant: -inset)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.centerYAnchor.constraint(equalTo: imagePostView.centerYAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: imagePostView.trailingAnchor, constant: inset),
            authorLabel.trailingAnchor.constraint(equalTo: viewPost.trailingAnchor, constant: -inset)
        ])
    }
}
