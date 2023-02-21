//
//  EmployeeTableViewCell.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 20.02.2023.
//

import UIKit

protocol EmployeeTableViewCellProtocol {
    func fullDataCell(data: Person)
}

class EmployeeTableViewCell: UITableViewCell {
    
    //MARK: Private properties
    private let cellView: UIView = {
        let view = UIView()
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let userTagLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let avatarImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createEmployeeCell()
        contentConfigurationCell()
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
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints({ make in
            make.edges.equalTo(contentView)
        })
        
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
        configurationStackView()
        
    }
    
    private func configurationStackView() {
        let xStack = UIStackView()
        xStack.axis = .horizontal
        xStack.addArrangedSubview(titleLabel)
        xStack.addArrangedSubview(userTagLabel)
        
        let yStack = UIStackView()
        yStack.axis = .vertical
        yStack.addArrangedSubview(xStack)
        yStack.addArrangedSubview(descriptionLabel)
        
        let mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.addArrangedSubview(avatarImage)
        mainStack.addArrangedSubview(yStack)
        
        cellView.addSubview(mainStack)
        
        mainStack.snp.makeConstraints({ make in
            make.leading.trailing.equalTo(cellView).inset(16)
        })
        
        mainStack.spacing = 16
        yStack.alignment = .top
        xStack.alignment = .bottom
        xStack.spacing = 6
        yStack.distribution = .fillEqually
        yStack.spacing = -8
    }
    
    private func contentConfigurationCell() {
        configurationTitle()
        configurationDescription()
        configurationUserTag()
    }
    
    private func configurationTitle() {
        titleLabel.textColor = UIColor(red: 5/255, green: 5/255, blue: 6/255, alpha: 1)
        titleLabel.font = UIFont(name: "Inter-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    private func configurationDescription() {
        descriptionLabel.textColor = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
        descriptionLabel.font = UIFont(name: "Inter-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private func configurationUserTag() {
        userTagLabel.textColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
        userTagLabel.font = UIFont(name: "Inter-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
    }
}

//MARK: EmployeeTableViewCellProtocol
extension EmployeeTableViewCell: EmployeeTableViewCellProtocol {
    func fullDataCell(data: Person) {
        let userTag = data.userTag.lowercased()
        titleLabel.text = "\(data.firstName) \(data.lastName)"
        descriptionLabel.text = data.position
        userTagLabel.text = userTag
        avatarImage.image = UIImage(named: data.avatarURL)
    }
}
