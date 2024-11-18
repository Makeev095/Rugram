////
////  PostTableViewCell.swift
////  Rugram
////
////  Created by Дмитрий Макеев on 18.11.2024.
////
//
//import UIKit
//
//class PostTableViewCell: UITableViewCell {
//    
//    let postImageView = UIImageView()
//    let authorLabel = UILabel()
//    let contentLabel = UILabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupViews() {
//        postImageView.contentMode = .scaleAspectFill
//        postImageView.clipsToBounds = true
//        postImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        authorLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        authorLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        contentLabel.numberOfLines = 0
//        contentLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        contentView.addSubview(authorLabel)
//        contentView.addSubview(postImageView)
//        contentView.addSubview(contentLabel)
//        
//        NSLayoutConstraint.activate([
//            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            
//            postImageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
//            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            postImageView.heightAnchor.constraint(equalToConstant: 200), // Высота изображения
//            
//            contentLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
//            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
//        ])
//    }
//}


import UIKit

class PostTableViewCell: UITableViewCell {
    
    let postImageView = UIImageView()
    let authorLabel = UILabel()
    let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 10 // Закругленные углы
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        
        postImageView.layer.cornerRadius = 10
           postImageView.layer.shadowColor = UIColor.black.cgColor
           postImageView.layer.shadowOpacity = 0.1
           postImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
           postImageView.layer.shadowRadius = 4
        
        authorLabel.font = UIFont.boldSystemFont(ofSize: 14)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(authorLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(contentLabel)
        
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.9) // Полупрозрачный белый
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            postImageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: 300), // Высота изображения
            
            contentLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
