//
//  ResultCell.swift
//  GymBroApp
//
//  Created by Евгений Васильев on 28.08.2025.
//
//
import UIKit

class FavoriteCell : UICollectionViewCell {
    
    //MARK: - Create UI
    
    let backgroundImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "kipchoge")
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "Weight Lifting"
        return label
    }()
    
    let equipLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "dumbell"
        return label
    }()
    
    //MARK: - Func
    
    func selected() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                }
            }
            self.backgroundImageView.layer.borderColor = UIColor.red.cgColor
            self.backgroundImageView.layer.borderWidth = 3
        }
    }
    
    func deselected() {
        DispatchQueue.main.async {
            self.backgroundImageView.layer.borderColor = UIColor.clear.cgColor
            self.backgroundImageView.layer.borderWidth = 0
        }
    }
    
    //MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(titleLabel)
        backgroundImageView.addSubview(equipLabel)
    }
    
    private func setConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
        ])
        
        equipLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            equipLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            equipLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
        ])
    }
    
}

