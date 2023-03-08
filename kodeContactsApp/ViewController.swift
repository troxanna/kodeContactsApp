//
//  ViewController.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 14.02.2023.
//

import UIKit
import SnapKit
import SkeletonView

protocol ErrorViewDelegate: AnyObject {
    func buttonRepeatRequestPressed()
}

class ViewController: UIViewController, SkeletonTableViewDataSource {
    
    //MARK: Private properties
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    private var employees: [User] = []

    //MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        createSearchBar()
        contentConfigurationView()
        contentConfigurationTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.identifier)
        
        self.skeletonShow()
        self.updateDataTableView()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    //        нужно ли обновлять tableView когда возвращаемся на него с EmployeeInfoViewController?
    //        skeletonShow()
    //  getUsers
    }
}

//MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //employeesData.count == 0 -> Другой экран
        let cell: EmployeeTableViewCell? = tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell
        
        let viewController = EmployeeInfoViewController()
        viewController.sendData(person: employees[indexPath.row])
        let image = cell?.getAvatarImage()
        viewController.sendImage(image: image)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return EmployeeTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier) as! EmployeeTableViewCell
        let employee = employees[indexPath.row]
        
        cell.fullDataCell(data: employee)
        cell.configurationSkeletonHideForCell()
        
        return cell
    }
}

//MARK: Private functions
extension ViewController {
    private func contentConfigurationTableView() {
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
    }
    
    private func contentConfigurationView() {
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    
    private func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    private func updateDataTableView() {
        APIManager.shared.getUsers { [weak self] users in
            do {
                let data = try users()
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.employees = data
                    self.tableView.reloadData()
                    self.skeletonHide()
                }
            }
            catch AppError.emptyDataError {
                DispatchQueue.main.async {
                    self?.showError(screenError: .searchError)
                }
            }
            catch {
                DispatchQueue.main.async {
                    self?.showError(screenError: .criticalError)
                }
            }
        }
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
        self.view.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
    }
}

//MARK: Handler error
extension ViewController {
    private func showError(screenError: ScreenError) {
        self.tableView.removeFromSuperview()
        let errorView = screenError.errorView
        errorView.delegate = self
        self.view.addSubview(errorView)
        errorView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        switch screenError {
        case .criticalError:
            self.navigationController?.navigationBar.isHidden = true
        default:
            break
        }
        
        self.skeletonHide()
    }
}

//MARK: ErrorViewDelegate
extension ViewController: ErrorViewDelegate {
    func buttonRepeatRequestPressed() {
        //доработать скелетон при повторном запросе
        headerPreferError = false
        self.navigationController?.navigationBar.isHidden = false
        self.setupTableView()
    }
}
