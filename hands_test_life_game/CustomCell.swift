//
//  CustomCell.swift
//  hands_test_life_game
//
//  Created by Флоранс on 31.05.2024.
//

import UIKit

final class CustomCell: UICollectionViewCell {
    static let reuseId = "CustomCell"
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let firstLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()
    
    var status = CellType.living
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        commonInit()
    }
    
    private func commonInit() {
        let innerStackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel])
        innerStackView.axis = .vertical
        innerStackView.spacing = 2
        
        let mainStackView = UIStackView(arrangedSubviews: [avatarImageView, innerStackView])
        mainStackView.axis = .horizontal
        mainStackView.alignment = .top
        mainStackView.spacing = 10
        
        contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(16)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Layout
    func configure(with type: CellType) {
        status = type
        switch type {
        case .living:
            avatarImageView.image = UIImage(named: "Image 1")
            firstLabel.text = "Живая"
            secondLabel.text = "и шевелится!"
        case .died:
            avatarImageView.image = UIImage(named: "Image 2")
            firstLabel.text = "Мертвая"
            secondLabel.text = "или прикидывается"
        default:
            avatarImageView.image = UIImage(named: "Image")
            firstLabel.text = "Жизнь"
            secondLabel.text = "Ку ку!"
        }
    }
    
}
