//
//  YearTableViewCell.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 03.04.2023.
//

import UIKit

class YearTableViewCell: UITableViewCell {

    static let identifier = IdentifierTableViewCell.year.rawValue
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Color.silverSand.rawValue)
        label.font = UIFont(name: Font.interMedium.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let leftLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(named: Color.silverSand.rawValue)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 0.5
        return label
    }()
    
    private let rightLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(named: Color.silverSand.rawValue)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 0.5
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(leftLine)
        contentView.addSubview(rightLine)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        leftLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(72)
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(contentView.snp.left).inset(24)
        }
        
        rightLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(72)
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).inset(24)
        }
        
        setTitle()
    }
    
    func setTitle() {
        let date = Date()
        let currentYear = date.yearInt
        titleLabel.text = "\(currentYear + 1)"
    }
    
}
