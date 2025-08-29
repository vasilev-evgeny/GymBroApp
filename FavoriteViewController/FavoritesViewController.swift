//
//  FavoritesViewController.swift
//  GymBroApp
//
//  Created by Евгений Васильев on 29.08.2025.
//
import UIKit
class FavoritesViewController : UIViewController {
    
    enum Constants {
        
    }
    
    //MARK: - Create UI
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .center
        label.text = "Favorite exercises"
        return label
    }()
      
    let favCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    //MARK: - Set Delegates
    
    func setDelegates() {
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        favCollectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavCell")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(favCollectionView)
        view.addSubview(titleLabel)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        favCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            favCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            favCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            favCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}

extension FavoritesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavCell", for: indexPath) as! FavoriteCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
    }
    
}

