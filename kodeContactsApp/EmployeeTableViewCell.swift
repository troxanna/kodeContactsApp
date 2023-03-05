//
//  EmployeeTableViewCell.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 20.02.2023.
//

import UIKit
import SkeletonView

protocol EmployeeTableViewCellProtocol {
    func fullDataCell(data: Person)
}

class EmployeeTableViewCell: UITableViewCell {
    
    //MARK: Private properties
    
    static let identifier = "cell"
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 5/255, green: 5/255, blue: 6/255, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let userTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let avatarImage: UIImageView = {
        let image = UIImageView()
//        image.layer.cornerRadius = 50
        return image
    }()
    
    
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createEmployeeCell()
        configurationSkeletonForCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Ovveride
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: Private functions
extension EmployeeTableViewCell {
    private func createEmployeeCell() {
        
        avatarImage.snp.makeConstraints({ make in
            make.size.equalTo(CGSize(width: 72, height: 72))
        })
        
        titleLabel.snp.makeConstraints({ make in
            make.height.equalTo(20)
        })
        
        userTagLabel.snp.makeConstraints({ make in
            make.height.equalTo(18)
        })
        
        descriptionLabel.snp.makeConstraints({ make in
            make.height.equalTo(16)
        })
        
        configurationConstraints()
        
    }
    
    private func configurationConstraints() {
        contentView.backgroundColor = .white

        mainTitleLabel.addSubview(titleLabel)
        mainTitleLabel.addSubview(userTagLabel)
        

        userTagLabel.snp.makeConstraints({ make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.bottom.equalTo(titleLabel.snp.bottom)
        })

        titleLabel.snp.makeConstraints({ make in
            make.leading.equalTo(mainTitleLabel.snp.leading)
            make.top.equalTo(mainTitleLabel.snp.top)
            make.bottom.equalTo(mainTitleLabel.snp.bottom)
        })

        contentView.addSubview(avatarImage)
        contentView.addSubview(mainTitleLabel)
        contentView.addSubview(descriptionLabel)

        avatarImage.snp.makeConstraints({ make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.centerY.equalTo(contentView)
        })
        
        mainTitleLabel.snp.makeConstraints({ make in
            make.trailing.equalTo(contentView.snp.trailing).offset(16)
            make.top.equalTo(contentView.snp.top).offset(22)
            make.leading.equalTo(avatarImage.snp.trailing).offset(16)
        })
        
        descriptionLabel.snp.makeConstraints({ make in
            make.leading.equalTo(mainTitleLabel.snp.leading)
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(4)
            make.trailing.equalTo(mainTitleLabel.snp.trailing).offset(16)
        })
    }
}

//MARK: EmployeeTableViewCellProtocol
extension EmployeeTableViewCell: EmployeeTableViewCellProtocol {
    func fullDataCell(data: Person) {
        let userTag = data.userTag?.lowercased()
        titleLabel.text = "\(data.firstName) \(data.lastName)"
        descriptionLabel.text = data.position
        userTagLabel.text = userTag
        avatarImage.image = UIImage(named: data.avatarURL ?? "avatarURL")
    }
}

//MARK: Skeleton for cell
extension EmployeeTableViewCell {
    func configurationSkeletonForCell() {
        self.isSkeletonable = true
        contentView.isSkeletonable = true
        avatarImage.isSkeletonable = true
        mainTitleLabel.isSkeletonable = true
        descriptionLabel.isSkeletonable = true
        
        descriptionLabel.skeletonTextLineHeight = .fixed(12)
        mainTitleLabel.skeletonTextLineHeight = .fixed(16)

        mainTitleLabel.linesCornerRadius = 8
        avatarImage.skeletonCornerRadius = 35
        descriptionLabel.linesCornerRadius = 6
                
        mainTitleLabel.skeletonPaddingInsets.right = 80
        descriptionLabel.skeletonPaddingInsets.right = 220
        
        titleLabel.isHidden = true
        userTagLabel.isHidden = true
    }
}
