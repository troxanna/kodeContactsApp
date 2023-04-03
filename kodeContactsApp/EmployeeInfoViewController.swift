//
//  EmployeeInfoViewController.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 19.02.2023.
//

import UIKit
import SnapKit

class EmployeeInfoViewController: UIViewController  {
    //MARK: Private properties
    private var person: User!
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1)
        return label
    }()
    
    private let userTag: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
        return label
    }()
    
    private let position: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
        return label
    }()
    
    private let avatarImage:UIImageView = {
        let image = UIImageView()
        return image
    }()

    private let dateBirthDay: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1)
        return label
    }()
    
    private let age: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
        return label
    }()
    
    private let numberPhone: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Icons.phone.rawValue), for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1), for: .normal)
        return button
    }()
    
    private let employeeInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
        return view
    }()
    
    private let employeeDetailsInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let line: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
        return label
    }()
    
    private let imageStar: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Icons.star.rawValue)
        return image
    }()
    
    private let blurView: BlurEffectView = {
        let view = BlurEffectView()
        return view
    }()
    
    private let stackDateBirthDay = UIStackView()

    //MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        contentConfigurationNavigationBar()
        configurationEmployeeInfoView()
        configurationEmployeeDetailsInfoView()
        fullData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        navigationItem.titleView = nil
    }
    
}

//MARK: Private functions
extension EmployeeInfoViewController {
    //MARK: NavigationBar
    private func contentConfigurationNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: UIImage(named: Icons.arrowBack.rawValue), style: .done, target: nil, action: nil)
        backButtonItem.target = self
        backButtonItem.action = #selector(backAction)
        backButtonItem.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButtonItem
        
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: EmployeeInfoView
    private func configurationEmployeeInfoView() {
        view.addSubview(employeeInfoView)
            employeeInfoView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        employeeInfoView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints({ make in
            make.size.equalTo(CGSize(width: 104, height: 104))
            make.centerX.equalTo(employeeInfoView)
            make.top.equalTo(employeeInfoView).inset(72)
        })
        
        let xStack = UIStackView()
        xStack.axis = .horizontal
        xStack.addArrangedSubview(nameLabel)
        xStack.addArrangedSubview(userTag)
        xStack.spacing = 4
        xStack.alignment = .center
        nameLabel.snp.makeConstraints({ make in
            make.height.equalTo(28)
        })
        userTag.snp.makeConstraints({ make in
            make.height.equalTo(22)
        })
        
        let yStack = UIStackView()
        yStack.axis = .vertical
        yStack.addArrangedSubview(xStack)
        yStack.addArrangedSubview(position)
        yStack.spacing = 12
        yStack.alignment = .center
        
        position.snp.makeConstraints({ make in
            make.height.equalTo(16)
        })
        
        employeeInfoView.addSubview(yStack)
        yStack.snp.makeConstraints({ make in
            make.top.equalTo(avatarImage.snp.bottom).offset(24)
            make.centerX.equalTo(employeeInfoView)
        })
    }
    
    //MARK: EmployeeDetailsInfoView
    private func configurationEmployeeDetailsInfoView() {
        view.addSubview(employeeDetailsInfoView)
        employeeDetailsInfoView.snp.makeConstraints({ make in
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(position.snp.bottom).offset(24)
        })
        
        configurationEmployeeDateBirthdayView()
        configurationHorizontalLine()
        configurationEmployeeNumberPhoneButton()
        
    }
    
    private func configurationHorizontalLine() {
        employeeDetailsInfoView.addSubview(line)
        line.snp.makeConstraints({ make in
            make.height.equalTo(0.5)
            make.left.equalTo(employeeDetailsInfoView.snp.left).inset(16)
            make.right.equalTo(employeeDetailsInfoView.snp.right).inset(16)
            make.top.equalTo(stackDateBirthDay.snp.bottom)
        })
    }
    
    private func configurationEmployeeDateBirthdayView() {
        stackDateBirthDay.axis = .horizontal
        stackDateBirthDay.alignment = .center
        stackDateBirthDay.addArrangedSubview(imageStar)
        stackDateBirthDay.addArrangedSubview(dateBirthDay)
        stackDateBirthDay.addArrangedSubview(age)
        
        dateBirthDay.snp.makeConstraints({ make in
            make.height.equalTo(60)
            make.left.equalTo(imageStar.snp.right).offset(14)
        })

        age.snp.makeConstraints({ make in
            make.height.equalTo(60)
        })
        
        employeeDetailsInfoView.addSubview(stackDateBirthDay)
        stackDateBirthDay.snp.makeConstraints({ make in
            make.left.equalTo(employeeDetailsInfoView.snp.left).inset(16)
            make.right.equalTo(employeeDetailsInfoView.snp.right).inset(16)
            make.top.equalTo(employeeDetailsInfoView.snp.top)
        })
        
        //как настроить высоту чере приоритеты?
        imageStar.snp.makeConstraints({ make in
            make.size.equalTo(CGSize(width: 20, height: 20))
        })
    }
    
    private func configurationEmployeeNumberPhoneButton() {

        employeeDetailsInfoView.addSubview(numberPhone)
        numberPhone.snp.makeConstraints({ make in
            make.left.equalTo(employeeDetailsInfoView.snp.left).inset(16)
            make.top.equalTo(line.snp.bottom)
            make.height.equalTo(60)
        })
        numberPhone.setTitleInsets(imageTitlePadding: 14)
        
        numberPhone.addTarget(self, action: #selector(buttonNumberPhonePressed), for: .touchUpInside)

    }
}

//MARK: Private data formatter functions
extension EmployeeInfoViewController {
    private func fullData() {
        let tmpYear = getUserAge(from: person.birthday)
        
        nameLabel.text = "\(person.firstName) \(person.lastName)"
        userTag.text = person.userTag.lowercased()
        position.text = person.position
        dateBirthDay.text = ConvertDateBirthDay()
        age.text = "\(tmpYear.0) \(tmpYear.1) "
        numberPhone.setTitle(formatPhoneNumber(number: person.phone), for: .normal)
    }
    
    private func ConvertDateBirthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.date(from: person.birthday)
        formatter.dateFormat = "d MMMM y"
        let date = formatter.string(from: dateString!)
        return date
    }
    
    private func getUserAge(from: String) -> (Int, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: person.birthday)
        let calendar = Calendar.current
        let currentDate = Date()
        
        if let someDate = date {
            let year = calendar.dateComponents([.year], from: someDate, to: currentDate).year ?? 0
            if year < 10 {
                if year < 5 {
                    return (year, "года")
                }
            }
            else {
                if year % 10 < 5 {
                    return (year, "года")
                }
            }
            return (year, "лет")
        }
        //Обработать исключение
        return (0, "")
    }
    
    private func formatPhoneNumber(number: String) -> String {
        let mask = "+7 (XXX) XXX XX XX"
        var result = ""
        var index = number.startIndex
        for ch in mask where index < number.endIndex {
            if number[index] == "-" {
                result.append(ch)
                index = number.index(after: index)
            }
            else if ch == "X" {
                result.append(number[index])
                index = number.index(after: index)
            }
            else {
                result.append(ch)
            }
        }
        return result
    }
    
    private func removeNumberFormat(number: String) -> String {
        let digits = CharacterSet.decimalDigits
        var text = ""
        for char in number.unicodeScalars {
            if digits.contains(char) {
                text.append(char.description)
            }
        }
        return text
    }
}

//MARK: Public functions
extension EmployeeInfoViewController {
    func sendData(person: User) {
        self.person = person
    }
    
    func sendImage(image: UIImage?) {
        avatarImage.image = image
    }
    
    
}

//MARK: Action sheet
extension EmployeeInfoViewController {
    @objc private func buttonNumberPhonePressed() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionCall = UIAlertAction(title: numberPhone.title(for: .normal), style: .default) {(actionSheet) in
            self.callPhoneNumber()
            self.blurView.removeFromSuperview()
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel){(actionSheet) in
            self.blurView.removeFromSuperview()
        }
        actionSheet.addAction(actionCall)
        actionSheet.addAction(actionCancel)
        self.view.addSubview(self.blurView)
        self.present(actionSheet, animated: true)
        contentConfigurationNumberPhoneAlert(actionSheet: actionSheet)
    }

    private func contentConfigurationNumberPhoneAlert(actionSheet: UIAlertController) {
        actionSheet.view.tintColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        actionSheet.view.layer.cornerRadius = 13

    }
    
    private func callPhoneNumber() {
        if let number = numberPhone.title(for: .normal),
            let url = URL(string: "tel://+\(removeNumberFormat(number: number))") {
            if (UIApplication.shared.canOpenURL(url)) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

