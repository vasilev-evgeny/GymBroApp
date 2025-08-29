//
//  ViewController.swift
//  GymBroApp
//
//  Created by Евгений Васильев on 26.08.2025.
//

import UIKit

class ViewController: UIViewController {
    
    let workoutTypes : [String] = ["cardio","olympic_weightlifting","plyometrics","powerlifting","strength","stretching","strongman"]
    let workoutImages : [String] = ["kipchoge","vlasov","jordan","malanichev","zass","stretching","eddiehall"]
    let musculeType : [String] = ["abdominals","abductors","adductors","biceps","calves","chest","forearms","glutes","hamstrings","lats","lower back","middle back","neck","quadriceps","traps","triceps"]
    let dificulty : [String] = ["beginner","intermediate","expert"]
    let netMan = NetworkManager()
    var exercisesArray : [Exercise] = []
    var searchActivate = false
    
    private let imageManager = GoogleImageManager.shared
    
    private var lastSelectedWorkoutCell: Cell?
    private var lastSelectedMuscleCell: Cell?
    private var lastSelectedDifficultyCell: Cell?
    private var lastSelectedResultCell: ResultCell?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Create UI
    
    let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let workoutTypeCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let musculeTypeCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let dificultyTypeCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let resultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.isHidden = true
        view.alpha = 0
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let findButton : UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let mainStackView : UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
    
    //MARK: - Setup SearchBar
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Looking for workout?"
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        let textField = searchBar.searchTextField
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.masksToBounds = true
        if let leftIconView = textField.leftView as? UIImageView {
            leftIconView.image = UIImage(systemName: "magnifyingglass")
            leftIconView.tintColor = .black
        }
        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            clearButton.tintColor = .black
        }
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.hidesBackButton = true
    }
    
    
    //MARK: - Set Delegates
    
    func setDelegates() {
        workoutTypeCollectionView.delegate = self
        workoutTypeCollectionView.dataSource = self
        workoutTypeCollectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        musculeTypeCollectionView.delegate = self
        musculeTypeCollectionView.dataSource = self
        musculeTypeCollectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        dificultyTypeCollectionView.delegate = self
        dificultyTypeCollectionView.dataSource = self
        dificultyTypeCollectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
        resultsCollectionView.register(ResultCell.self, forCellWithReuseIdentifier: "ResultCell")
        scrollView.delegate = self
    }
    
    //MARK: - Action Func
    
    @objc func findButtonTapped(sender: UIButton) {
        sender.buttonTappedAnimate()
        searchActivate = true
        let difficulty = lastSelectedDifficultyCell?.label.text
        let muscle = lastSelectedMuscleCell?.label.text
        let workoutType = lastSelectedWorkoutCell?.label.text
        guard difficulty != nil || muscle != nil || workoutType != nil else {
            showAlert(message: "Please select at least one filter category")
            return
        }
        resultsCollectionView.isHidden = true
        resultsCollectionView.alpha = 0
        netMan.diff = difficulty
        netMan.muscule = muscle
        netMan.sport = workoutType
        netMan.loadExercise{ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let exercises):
                    print("Successfully loaded \(exercises.count) exercises")
                    self.exercisesArray = exercises
                    print("Data loaded, array count: \(self.exercisesArray.count)")
                    self.resetSelections()
                    self.preloadImagesForExercises()
                    self.resultsCollectionView.reloadData()
                    if !self.exercisesArray.isEmpty {
                        self.resultsCollectionView.isHidden = false
                        UIView.animate(withDuration: 0.3) {
                            self.resultsCollectionView.alpha = 1
                        }
                    } else {
                        self.showAlert(message: "No exercises found for the selected criteria")
                    }
                case .failure(let error):
                    print("Error loading exercises: \(error.localizedDescription)")
                    self.showAlert(message: "Failed to load exercises: \(error.localizedDescription)")
                }
            }
        }
        print(exercisesArray.count)
    }
    
    private func preloadImagesForExercises() {
        for (index, exercise) in exercisesArray.enumerated() {
            // Загружаем изображение только если его еще нет
            if exercise.imageData == nil {
                imageManager.loadImageForExercise(exercise) { [weak self] imageData in
                    DispatchQueue.main.async {
                        guard let self = self,
                              index < self.exercisesArray.count,
                              let imageData = imageData else { return }
                        
                        // Обновляем упражнение с данными изображения
                        self.exercisesArray[index].imageData = imageData
                        
                        // Перезагружаем только конкретную ячейку
                        let indexPath = IndexPath(item: index, section: 0)
                        
                        // Проверяем, видима ли ячейка сейчас
                        if self.resultsCollectionView.indexPathsForVisibleItems.contains(indexPath) {
                            self.resultsCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showExerciseDetail(_ exercise: Exercise) {
        let detailVC = ExerciseDetailViewController()
        detailVC.exercise = exercise
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func resetSelections() {
        lastSelectedWorkoutCell?.deselected()
        lastSelectedMuscleCell?.deselected()
        lastSelectedDifficultyCell?.deselected()
        lastSelectedResultCell?.deselected()
        
        lastSelectedWorkoutCell = nil
        lastSelectedMuscleCell = nil
        lastSelectedDifficultyCell = nil
        lastSelectedResultCell = nil
        
        workoutTypeCollectionView.selectItem(at: nil, animated: false, scrollPosition: [])
        musculeTypeCollectionView.selectItem(at: nil, animated: false, scrollPosition: [])
        dificultyTypeCollectionView.selectItem(at: nil, animated: false, scrollPosition: [])
        resultsCollectionView.selectItem(at: nil, animated: false, scrollPosition: [])
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setupSearchController()
        setDelegates()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(resultsCollectionView)
        mainStackView.addArrangedSubview(workoutTypeCollectionView)
        mainStackView.addArrangedSubview(musculeTypeCollectionView)
        mainStackView.addArrangedSubview(dificultyTypeCollectionView)
        mainStackView.addArrangedSubview(findButton)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        resultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultsCollectionView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        workoutTypeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            workoutTypeCollectionView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        musculeTypeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            musculeTypeCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        dificultyTypeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dificultyTypeCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        findButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            findButton.heightAnchor.constraint(equalToConstant: 46),
        ])
    }
}

// MARK: - EXTESION UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else {
                    // Если поиск пустой, скрываем результаты
                    exercisesArray = []
                    resultsCollectionView.reloadData()
                    resultsCollectionView.isHidden = true
                    resultsCollectionView.alpha = 0
                    return
                }
        performSearch(searchText: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // Реализуем поиск по мере ввода
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performDelayedSearch), object: nil)
            
            if searchText.isEmpty {
                exercisesArray = []
                resultsCollectionView.reloadData()
                resultsCollectionView.isHidden = true
                resultsCollectionView.alpha = 0
                resetSelections()
            } else {
                // Задержка для избежания частых запросов при вводе
                perform(#selector(performDelayedSearch), with: searchText, afterDelay: 0.5)
            }
        }
    
    @objc private func performDelayedSearch(_ searchText: String) {
            performSearch(searchText: searchText)
        }
    
    private func performSearch(searchText: String) {
        let selectedMuscle = lastSelectedMuscleCell?.label.text
        let selectedType = lastSelectedWorkoutCell?.label.text
        let selectedDifficulty = lastSelectedDifficultyCell?.label.text
        resultsCollectionView.isHidden = true
        resultsCollectionView.alpha = 0
        netMan.searchExercises(
            name: searchText,
            muscle: selectedMuscle,
            equipment: nil, 
            type: selectedType,
            difficulty: selectedDifficulty
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let exercises):
                    self.exercisesArray = exercises
                    self.resetSelections()
                    self.preloadImagesForExercises()
                    self.resultsCollectionView.reloadData()
                    if !self.exercisesArray.isEmpty {
                        self.resultsCollectionView.isHidden = false
                        UIView.animate(withDuration: 0.3) {
                            self.resultsCollectionView.alpha = 1
                        }
                        print("Found \(exercises.count) exercises")
                    } else {
                        self.resultsCollectionView.isHidden = true
                        self.resultsCollectionView.alpha = 0
                        print("No exercises found")
                    }
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                    self.exercisesArray = []
                    self.resultsCollectionView.reloadData()
                    self.resultsCollectionView.isHidden = true
                    self.resultsCollectionView.alpha = 0
                }
            }
        }
    }
}

//MARK: - EXTENSION UICollectionView
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case workoutTypeCollectionView:
            return workoutTypes.count
        case musculeTypeCollectionView:
            return musculeType.count
        case dificultyTypeCollectionView:
            return dificulty.count
        case resultsCollectionView:
            return exercisesArray.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width/3
        let height: CGFloat = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case workoutTypeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
            cell.label.text = workoutTypes[indexPath.item]
            cell.backgroundImageView.image = UIImage(named: workoutImages[indexPath.item])
            return cell
        case musculeTypeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
            cell.label.text = musculeType[indexPath.item]
            return cell
        case dificultyTypeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
            cell.label.text = dificulty[indexPath.item]
            return cell
        case resultsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as! ResultCell
            print(" dequeueReusableCellWithIdentifier для ResultCell, индекс: \(indexPath)")
            print("Данные: name = \(exercisesArray[indexPath.item].name), equipment =\(exercisesArray[indexPath.item].equipment)")
            cell.titleLabel.text = exercisesArray[indexPath.item].name
            cell.equipLabel.text = exercisesArray[indexPath.item].equipment
            cell.backgroundImageView.image = UIImage(named: "vlasov")
            if let image = exercisesArray[indexPath.item].image {
                cell.backgroundImageView.image = image
            } else {
                cell.backgroundImageView.image = UIImage(named: "vlasov")
                imageManager.loadImageForExercise(exercisesArray[indexPath.item]) { [weak self] imageData in
                    DispatchQueue.main.async {
                        guard let self = self,
                              indexPath.item < self.exercisesArray.count,
                              let imageData = imageData,
                              let currentCell = self.resultsCollectionView.cellForItem(at: indexPath) as? ResultCell else { return }
                        self.exercisesArray[indexPath.item].imageData = imageData
                        currentCell.backgroundImageView.image = UIImage(data: imageData)
                    }
                }
            }
            return cell
        default:
            fatalError("Unknown collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case workoutTypeCollectionView:
            if let cell = collectionView.cellForItem(at: indexPath) as? Cell {
                        // Сбрасываем предыдущее выделение
                        lastSelectedWorkoutCell?.deselected()
                        
                        // Устанавливаем новое выделение
                        cell.selected()
                        lastSelectedWorkoutCell = cell
                    }
        case musculeTypeCollectionView:
            if let cell = collectionView.cellForItem(at: indexPath) as? Cell {
                        lastSelectedMuscleCell?.deselected()
                        cell.selected()
                        lastSelectedMuscleCell = cell
                    }
        case dificultyTypeCollectionView:
            if let cell = collectionView.cellForItem(at: indexPath) as? Cell {
                        lastSelectedDifficultyCell?.deselected()
                        cell.selected()
                        lastSelectedDifficultyCell = cell
                    }
        case resultsCollectionView:
            if let cell = collectionView.cellForItem(at: indexPath) as? ResultCell {
                        lastSelectedResultCell?.deselected()
                        cell.selected()
                        lastSelectedResultCell = cell
                        
                        let exercise = exercisesArray[indexPath.item]
                        self.showExerciseDetail(exercise)
                    }
        default:
            fatalError("Unknown collection view")
        }
    }
    
}
