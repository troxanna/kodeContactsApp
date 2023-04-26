//
//  EmployeeTableViewCell.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 20.02.2023.
//

import UIKit
import SkeletonView

class EmployeeTableViewCell: UITableViewCell {
    //MARK: Properties
    static let identifier = "EmployeeCell"
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Color.richBlack.rawValue)
        label.font = UIFont(name: Font.interMedium.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Color.davysGrey.rawValue)
        label.font = UIFont(name: Font.interRegular.rawValue, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let userTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Color.spanishGray.rawValue)
        label.font = UIFont(name: Font.interMedium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 36
        image.clipsToBounds = true
        return image
    }()
    
    private let userAgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Color.davysGrey.rawValue)
        label.font = UIFont(name: Font.interRegular.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)
        label.isHidden = true
        return label
    }()
    
    var userAgeIsHidden: Bool = true {
        didSet {
            userAgeLabel.isHidden = userAgeIsHidden
        }
    }
    
    var avatarImage: UIImage {
        return avatarImageView.image ?? UIImage(named: User.CodingKeys.avatarURL.rawValue)!
    }
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createEmployeeCell()
        configurationSkeletonShowForCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Ovveride
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

//MARK: Private functions
extension EmployeeTableViewCell {
    private func createEmployeeCell() {
        
        avatarImageView.snp.makeConstraints({ make in
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
        contentView.backgroundColor = UIColor(named: Color.white.rawValue)

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

        contentView.addSubview(avatarImageView)
        contentView.addSubview(mainTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(userAgeLabel)

        avatarImageView.snp.makeConstraints({ make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.centerY.equalTo(contentView)
        })
        
        mainTitleLabel.snp.makeConstraints({ make in
            make.trailing.equalTo(contentView.snp.trailing).offset(16)
            make.top.equalTo(contentView.snp.top).offset(22)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
        })
        
        descriptionLabel.snp.makeConstraints({ make in
            make.leading.equalTo(mainTitleLabel.snp.leading)
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(4)
            make.trailing.equalTo(mainTitleLabel.snp.trailing).offset(16)
        })
        
        userAgeLabel.snp.makeConstraints({ make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).inset(16)
        })
    }
    
    private func fetchAvatarImage(urlString: String) {
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: urlString),
                  let imageData = try? Data(contentsOf: imageUrl) else {
                      DispatchQueue.main.async {
                          self.avatarImageView.image = UIImage(named: User.CodingKeys.avatarURL.rawValue)
                      }
                      return
            }
            DispatchQueue.main.async {
                self.avatarImageView.image = UIImage(data: imageData)
            }
        }
    }
}

//MARK: Public functions
extension EmployeeTableViewCell {
    func fullDataCell(data: User) {
        let userTag = data.userTag.lowercased()
        let formatter = DateFormatter()
        
        titleLabel.text = "\(data.firstName) \(data.lastName)"
        descriptionLabel.text = data.position
        userTagLabel.text = userTag
        userAgeLabel.text = formatter.getDateString(dateFormat: "d MMM", date: data.birthday)
        fetchAvatarImage(urlString: data.avatarURL)
    }

}

//MARK: Skeleton for cell
extension EmployeeTableViewCell {
    func configurationSkeletonShowForCell() {
        self.isSkeletonable = true
        contentView.isSkeletonable = true
        avatarImageView.isSkeletonable = true
        mainTitleLabel.isSkeletonable = true
        descriptionLabel.isSkeletonable = true
        
        descriptionLabel.skeletonTextLineHeight = .fixed(12)
        mainTitleLabel.skeletonTextLineHeight = .fixed(16)

        mainTitleLabel.linesCornerRadius = 8
        avatarImageView.skeletonCornerRadius = 35
        descriptionLabel.linesCornerRadius = 6
                
        mainTitleLabel.skeletonPaddingInsets.right = 80
        descriptionLabel.skeletonPaddingInsets.right = 220
        
        titleLabel.isHidden = true
        userTagLabel.isHidden = true
    }
    
    func configurationSkeletonHideForCell() {
        titleLabel.isHidden = false
        userTagLabel.isHidden = false
    }
}
