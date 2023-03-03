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
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: "cell")
        contentConfigurationTableView()
        
    }
    
//MARK: Private properties
    
    private var tableView = UITableView()
    private var person = Person(id: "e66c4836-ad5f-4b93-b82a-9251b0f9aca2", firstName: "River", lastName: "Gutkowski", department: "qa", position: "Technician", birthday: "1943-05-26", phone: "335-943-1610", userTag: "FM", avatarURL: "avatarURL")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EmployeeTableViewCell
        cell.fullDataCell(data: person)
        return cell
    }
}

//MARK: Private methods

extension ViewController {
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

