//
//  DetailViewController.swift
//  White&Fluffy
//
//  Created by Lev on 02.08.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    let presenter: DetailViewPresenter!
    
    init(with presenter: DetailViewPresenter){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigatiomBar() {
        self.navigationItem.title = "Photo Info"
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9844798446, green: 0.78441149, blue: 0.01730724052, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9844798446, green: 0.78441149, blue: 0.01730724052, alpha: 1)
    }
    
    private lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIScrollView())
    
    private lazy var contentView: DetailView = {
        
        let view = DetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        guard let model = presenter.modelDetail else { return view }
        view.setupView(model: model)
        
        view.tapHandler = {
            [weak self] in self?.likeAction()
        }
        view.delegate = self
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigatiomBar()
        self.setupView()
    }
    
    func photoUpdated(model: DetailModel) {
        print("modeeel", model.likePressed)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            
            self.contentView.likeButton.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.contentView.likeButton.alpha = 1
            self.contentView.setupView(model: model)
            
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
                
                self.contentView.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.contentView.likeButton.alpha = 0.8
                
            }
        }
    }
    
    private func likeAction() {
        
        guard let liked = presenter.modelDetail?.likePressed else { return }
        
        if liked {
            let alert = UIAlertController(title: "Attention!", message: "Delete from favourites?", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "Yes", style: .default, handler: {action in print ("Yes")
                
                self.presenter.deletePhoto()
            })
            
            let noButton = UIAlertAction(title: "No", style: .default, handler: {action in print ("No")})
            alert.addAction(yesButton)
            alert.addAction(noButton)
            
            present(alert, animated: true, completion: nil)
        } else {
            presenter.addPhoto()
        }
    }
    
    private func setupView() {
        
        view.addSubview(scrollView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

// MARK: - DetailViewDelegate
extension DetailViewController: DetailViewDelegate {
    
    func tapSender(photos: [UIImage]) { //, sender: UIBarButtonItem)
        print("&&&&????")
        print("start", #function)
        
        let shareController = UIActivityViewController(activityItems: photos, applicationActivities: nil)
        //tyItems: selectedImages, applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                //self.refresh()
            }
        }
        //shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
        print(#function)
    }
}
