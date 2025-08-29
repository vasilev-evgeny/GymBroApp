//
//  Cell.swift
//  GymBroApp
//
//  Created by Евгений Васильев on 26.08.2025.
//
import UIKit

class Cell : UICollectionViewCell {
    
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
    
    let label : UILabel = {
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
        backgroundImageView.addSubview(label)
    }
    
    private func setConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            label.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -10)
        ])
    }
    
}
