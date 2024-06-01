//
//  ViewController.swift
//  hands_test_life_game
//
//  Created by Флоранс on 31.05.2024.
//

import UIKit
import SnapKit

enum CellType: CaseIterable {
    case living
    case died
    case life
    case death
}

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 40)
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        view.addSubview(cv)
        return cv
    }()
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let color = UIColor(named: "Color 1")?.cgColor
        gradient.colors = [color!, UIColor.black.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x : 0.0, y : 0)
        gradient.endPoint = CGPoint(x :0.0, y: 0.5)
        gradient.frame = view.bounds
        return gradient
    }()
    
    private lazy var createBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 36))
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor = .purple
        button.setTitle("Сотворить", for: .normal)
        button.addTarget(self, action: #selector(buttonClicked),
                         for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    private var numberOfOrderedLivingCells = 0
    private var numberOfOrderedDiedCells = 0
    private var numberOfCells = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Клеточное наполнение"
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseId)
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseId
        )
        let bgView = UIView(frame: collectionView.bounds)
        bgView.layer.insertSublayer(gradient, at: 0)
        collectionView.backgroundView = bgView
        setupLayout()
    }
    
    // MARK: - Status Bar BG
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top
            let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: topPadding ?? 0.0))
            statusBar.backgroundColor = UIColor(named: "Color")
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)
        }

    }
    
    // MARK: - Private Methodds
    private func setupLayout() {
        createBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    // MARK: - New Cell Creation
    @objc func buttonClicked(sender: UIButton) {
        numberOfCells+=1
        let index = IndexPath(item: numberOfCells-1, section: 0)
        collectionView.insertItems(at: [index])
        if !collectionView.indexPathsForVisibleItems.contains(index) {
            collectionView.scrollToItem(at: index, at: .top, animated: true)
        }
        
        guard let lifeCell = collectionView.cellForItem(
            at: IndexPath(item: numberOfCells-5, section: 0)
        ) as? CustomCell else { return }
        
        
        if numberOfOrderedDiedCells == 3 && lifeCell.status == .life {
            numberOfCells-=1
            collectionView.deleteItems(at: [IndexPath(item: numberOfCells-4, section: 0)])
        }
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCell.reuseId, for: indexPath
        ) as? CustomCell else { return UICollectionViewCell() }
        
        let status = [CellType.living, CellType.died].randomElement()!
        
        if numberOfOrderedLivingCells == 3 {
            cell.configure(with: .life)
            numberOfOrderedDiedCells = 0
            numberOfOrderedLivingCells = 0
            return cell
        }
        
        if status == .living {
            numberOfOrderedDiedCells = 0
            numberOfOrderedLivingCells+=1
        } else {
            numberOfOrderedLivingCells = 0
            numberOfOrderedDiedCells+=1
        }
        cell.configure(with: status)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.bounds.width - 32, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseId,
            for: indexPath
        ) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        
        return sectionHeaderView
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
    }
}

final class SectionHeaderView: UICollectionReusableView {
    static let reuseId = "SectionHeaderView"
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Клеточное наполнение"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        title.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}

