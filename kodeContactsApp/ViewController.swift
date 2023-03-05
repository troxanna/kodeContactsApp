//
//  ViewController.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 14.02.2023.
//

import UIKit
import SnapKit
import SkeletonView

class ViewController: UIViewController, SkeletonTableViewDataSource {
    
    //MARK: Private properties
    private var tableView:UITableView = {
        let tableView = UITableView()
        print("init tableView")
        return tableView
    }()

    private var person = Person(id: "e66c4836-ad5f-4b93-b82a-9251b0f9aca2", firstName: "River", lastName: "Gutkowski", department: "qa", position: "Technician", birthday: "1943-05-26", phone: "335-943-1610", userTag: "FM", avatarURL: "avatarURL")
    private var employeesData: [Person] = []

    //MARK: Override functions
    override func viewDidLoad() {
        print("load tableView")
        super.viewDidLoad()
        view.addSubview(tableView)
        print("add tableView")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        // не работает contentInset
//        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        createSearchBar()
        contentConfigurationView()
        contentConfigurationTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.identifier)

        skeletonShow()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            for _ in 1...10 {
                self.employeesData.append(self.person)
            }
            self.skeletonHide()
        })
        self.tableView.reloadData()
    
    }
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
        return employeesData.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return EmployeeTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier) as! EmployeeTableViewCell
        
        cell.fullDataCell(data: employeesData[indexPath.row])
        
        cell.titleLabel.isHidden = false
        cell.userTagLabel.isHidden = false
        
        return cell
    }
}

//MARK: Private methods

extension ViewController {
    private func contentConfigurationTableView() {
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
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

//MARK: Skeleton for Table View
extension ViewController {
    private func skeletonShow() {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient.init(baseColor: UIColor(red: 243/255, green: 243/255, blue: 246/255, alpha: 1), secondaryColor: UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)), animation: nil, transition: .crossDissolve(0.5))
    }
    
    private func skeletonHide() {
        self.tableView.stopSkeletonAnimation()
        self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
    }
    
}


