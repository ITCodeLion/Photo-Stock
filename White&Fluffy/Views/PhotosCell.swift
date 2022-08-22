//
//  PhotosCell.swift
//  White&Fluffy
//
//  Created by Lev on 19.06.2022.
//

import UIKit
import SDWebImage

class PhotosCell: UICollectionViewCell {
    
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else {
                return }
            photoView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhoto()
    }
    
    private func setupPhoto() {
        addSubview(photoView)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: self.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
