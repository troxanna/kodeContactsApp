//
//  ViewController.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 14.02.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        contentConfigurationView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        contentConfigurationTableView()
        
    }
    
    //MARK: Private properties
    
    private var tableView = UITableView()
    private var person = Person(id: "e66c4836-ad5f-4b93-b82a-9251b0f9aca2", avatarURL: "avatarURL", firstName: "River", lastName: "Gutkowski", userTag: "FM", department: "qa", position: "Technician", birthday: "1943-05-26", phone: "335-943-1610")
    private var employeesData: [Person] = []
}

//MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //employeesData.count == 0 -> Другой экран
        let viewController = EmployeeInfoViewController()
        viewController.sendData(person: person)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //employeesData.count
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if #available(iOS 14.0, *) {
            contentConfigurationTableViewCell(forVersion: 14, cell: cell)
        } else {
            contentConfigurationTableViewCell(cell: cell)
        }
        //не хватает : длины строки, userTag
        return cell
    }
}
 
//MARK: Private methods for iOS 14
@available(iOS 14.0, *)
extension ViewController {
    @available(iOS 14.0, *)
    private func contentConfigurationTableViewCell(forVersion: Int, cell: UITableViewCell) {
        var content = cell.defaultContentConfiguration()
        
        //Configuration image
        content.image = UIImage(named: person.avatarURL)
        
        //Configuration text
        content.text = "\(person.firstName) \(person.lastName)"
        content.textProperties.color = UIColor(red: 5/255, green: 5/255, blue: 6/255, alpha: 1)
        content.textProperties.font = UIFont(name: "Inter-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        
        //Configuration secondary text
        content.secondaryText = person.position
        content.secondaryTextProperties.color = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
        content.secondaryTextProperties.font = UIFont(name: "Inter-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        
        cell.contentConfiguration = content
    }
}

//MARK: Private methods

extension ViewController {
    private func contentConfigurationTableViewCell(cell: UITableViewCell) {
        //Configuration text
        cell.textLabel?.text = "\(person.firstName) \(person.lastName)"
        cell.textLabel?.font = UIFont(name: "Inter-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = UIColor(red: 5/255, green: 5/255, blue: 6/255, alpha: 1)
        
        //Configuration secondary text
        cell.detailTextLabel?.text = person.position
        cell.detailTextLabel?.font = UIFont(name: "Inter-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        cell.detailTextLabel?.textColor = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
        
        //Configuration image
        cell.imageView?.image = UIImage(named: person.avatarURL)
    }
    
    private func contentConfigurationTableView() {
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    private func contentConfigurationView() {
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    }
    
    private func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
}

