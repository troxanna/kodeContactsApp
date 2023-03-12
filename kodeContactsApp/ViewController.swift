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

protocol DepartmentSegmentedControlDelegate: AnyObject {
    func buttonSegmentPressed(department: String)
}

class ViewController: UIViewController, SkeletonTableViewDataSource {
    
    //MARK: Private properties
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var departmentSegmentedControll: DepartmentSegmentedControl = {
        let segmentedControl = DepartmentSegmentedControl(frame: .zero, items: Departaments.departments)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var searchBar: SearchBar = {
        let searchBar = SearchBar()
        return searchBar
    }()

    private var employees: [User] = []
    private var filteredEmployees: [User] = []

    //MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentConfigurationView()
        createTableView()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
}

//MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: EmployeeTableViewCell? = tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell
        
        let viewController = EmployeeInfoViewController()
        viewController.sendData(person: filteredEmployees[indexPath.row])
        let image = cell?.getAvatarImage()
        viewController.sendImage(image: image)
        navigationController?.pushViewController(viewController, animated: true)
        
        updateSearchBarEndEditing()
    }
}

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //employeesData.count == 0 -> Другой экран
        return filteredEmployees.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return EmployeeTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier) as! EmployeeTableViewCell
        let employee = filteredEmployees[indexPath.row]
        
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

    private func createTableView() {
        view.addSubview(tableView)
        view.addSubview(departmentSegmentedControll)

        tableView.snp.makeConstraints({ make in
            make.right.left.bottom.equalToSuperview()
            make.top.equalTo(departmentSegmentedControll.snp.bottom).offset(16)

        })
        departmentSegmentedControll.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        })
        
        departmentSegmentedControll.delegate = self
    }
    
    private func setupTableView() {
        contentConfigurationTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.identifier)
        
        self.skeletonShow()
        self.updateDataTableView()
    }
    
    private func updateDataTableView() {
        APIManager.shared.getUsers { [weak self] users in
            do {
                let data = try users()
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.employees = data
                    self.filteredEmployees = data
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
        
        switch screenError {
        case .criticalError:
            errorView.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
            navigationController?.isNavigationBarHidden = true
            departmentSegmentedControll.removeFromSuperview()
        default:
            errorView.snp.makeConstraints({ make in
                make.right.left.bottom.equalToSuperview()
                make.top.equalTo(departmentSegmentedControll.snp.bottom)
            })
        }
        self.skeletonHide()
    }
}

//MARK: ErrorViewDelegate
extension ViewController: ErrorViewDelegate {
    func buttonRepeatRequestPressed() {
        headerPreferError = false
        navigationController?.isNavigationBarHidden = false
        createTableView()
        updateDataTableView()
    }
}

//MARK: DepartmentSegmentedControlDelegate
extension ViewController: DepartmentSegmentedControlDelegate {
    func buttonSegmentPressed(department: String) {
        do {
            try filteredEmployees(for: department)
            createTableView()
            tableView.reloadData()
        }
        catch AppError.searchError {
            showError(screenError: .searchError)
        }
        catch {
            showError(screenError: .criticalError)
        }
    }
    
    func filteredEmployees(for department: String) throws {
        if department == Departaments.all.value {
            filteredEmployees = employees
        } else {
            filteredEmployees = employees.filter { Departaments(rawValue: $0.department)?.value == department }
        }
        if filteredEmployees.isEmpty {
            throw AppError.searchError
        }
    }
}

//MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateSearchBarForBeginEditing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateSearchBarEndEditing()
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchBarEndEditing()
    }
    
    private func updateSearchBarForBeginEditing() {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.placeholder = nil
        searchBar.searchTextField.rightViewMode = .never
    }
    
    private func updateSearchBarEndEditing() {
        searchBar.placeholder = SearchTextFieldData.placeholder.rawValue
        searchBar.endEditing(true)
        searchBar.searchTextField.rightViewMode = .always
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
