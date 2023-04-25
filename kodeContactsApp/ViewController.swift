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

protocol SortedBottomSheetViewControllerDelegate: AnyObject {
    func sortedTableView(by sortedType: SortedType)
}

class ViewController: UIViewController, SkeletonTableViewDataSource {
    
    //MARK: Private properties
    private var sortedType = SortedType.alphabetically
    private var errorView: ErrorView?
    
    private var refreshLoadingView: UIView!
    private var refreshView: CircularProgressView!
    private var isRefreshAnimating = false
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    private var departmentSegmentedControll: DepartmentSegmentedControl = {
        let segmentedControl = DepartmentSegmentedControl(frame: .zero, items: Departaments.departments)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.isUserInteractionDisabledWhenSkeletonIsActive = true
        return searchBar
    }()

    private var employees: [[User]] = [[], []]
    private var filteredEmployees: [[User]] = [[], []]
    private var sortedEmployees: [[User]] = [[], []]
    private var searchEmployees: [[User]] = [[], []]

    //MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentConfigurationView()
        createTableView()
        setupTableView()
        setupRefreshControl()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.titleView = searchBar
        searchBar.delegate = self
//        setupRefreshControl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        refreshView.animationCircular()
    }
    
}

//MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == sortedEmployees[indexPath.section].count && sortedEmployees[1].count != 0 {
            return
        }
        let cell: EmployeeTableViewCell? = tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell
        let viewController = EmployeeInfoViewController()
        viewController.sendData(person: sortedEmployees[indexPath.section][indexPath.row])
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
        if section == 0 && sortedEmployees[1].count != 0 {
            return sortedEmployees[section].count + 1
        }
        return sortedEmployees[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return EmployeeTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == sortedEmployees[indexPath.section].count && sortedEmployees[1].count != 0 {
            return tableView.dequeueReusableCell(withIdentifier: YearTableViewCell.identifier) as! YearTableViewCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier) as! EmployeeTableViewCell
        let employee = sortedEmployees[indexPath.section][indexPath.row]
        
        cell.fullDataCell(data: employee)
        if sortedType == SortedType.birthday {
            cell.userAgeLabel.isHidden = false
        } else {
            cell.userAgeLabel.isHidden = true
        }
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
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.width, height: 16)))
    }
    
    private func contentConfigurationView() {
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }

    private func createTableView() {
        view.addSubview(tableView)
        view.addSubview(departmentSegmentedControll)

        tableView.snp.makeConstraints({ make in
            make.right.left.bottom.equalToSuperview()
            //offset 16
            make.top.equalTo(departmentSegmentedControll.snp.bottom)

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
        tableView.register(YearTableViewCell.self, forCellReuseIdentifier: YearTableViewCell.identifier)
        
        self.skeletonShow()
        self.updateDataTableView()
    }
    
    private func updateDataTableView() {
        APIManager.shared.getUsers { [weak self] users in
            do {
                let data = try users()
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.employees[0] = data
                    self.sortedEmployees[0] = data
                    self.filteredEmployees[0] = data
                    self.handlerFilteredEmployees(for: self.departmentSegmentedControll.currentActiveSegment)
                    self.searchEmployees[0] = []
                    self.searchEmployees[1] = []
                    if let searchText = self.searchBar.searchTextField.text {
                        if searchText != "" {
                            self.handlerSearch(searchText: searchText)
                        }
                    }
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
        errorView?.removeFromSuperview()
        errorView = screenError.errorView
        errorView!.delegate = self
        self.view.addSubview(errorView!)
        
        switch screenError {
        case .criticalError:
            errorView!.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
            navigationController?.isNavigationBarHidden = true
            departmentSegmentedControll.removeFromSuperview()
        default:
            errorView!.snp.makeConstraints({ make in
                make.right.left.bottom.equalToSuperview()
                make.top.equalTo(departmentSegmentedControll.snp.bottom)
            })
            tableView.isHidden = true
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
        handlerFilteredEmployees(for: department)
        if let searchText = searchBar.searchTextField.text {
            if searchText != "" {
                handlerSearch(searchText: searchText)
            }
        }
    }
    
    func handlerFilteredEmployees(for department: String) {
        do {
            try filteredEmployees(for: department)
            errorView?.removeFromSuperview()
            tableView.isHidden = false
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
            filteredEmployees[0] = employees[0]
        } else {
            filteredEmployees[0] = employees[0].filter { Departaments(rawValue: $0.department)?.value == department }
        }
        if sortedType == SortedType.birthday {
            sortedByBirthday(by: filteredEmployees)
        } else if sortedType == SortedType.alphabetically {
            sortedByAlphabetically(by: filteredEmployees)
        }
        if filteredEmployees[0].isEmpty && filteredEmployees[1].isEmpty {
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
        if (searchText == "") {
            handlerFilteredEmployees(for: departmentSegmentedControll.currentActiveSegment)
        } else {
            handlerSearch(searchText: searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateSearchBarEndEditing()
        handlerFilteredEmployees(for: departmentSegmentedControll.currentActiveSegment)
        searchBar.text = ""
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = self.searchBar.searchTextField.text {
            if searchText != "" {
                self.handlerSearch(searchText: searchText)
            }
        }
        updateSearchBarEndEditing()
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        didTapSortButton()
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
    
    private func didTapSortButton() {
        let vc = SortedBottomSheetViewController(currentSortedType: sortedType)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    private func handlerSearch(searchText: String) {
        do {
            try searchEmployees(searchText: searchText)
            errorView?.removeFromSuperview()
            tableView.isHidden = false
            tableView.reloadData()
        } catch {
            showError(screenError: .searchError)
        }
    }
    
    private func searchEmployees(searchText: String) throws {
        if filteredEmployees[0].isEmpty && filteredEmployees[1].isEmpty {
//            searchEmployees[0] = []
//            searchEmployees[1] = []
            throw AppError.emptyDataError
        }
        logicSearch(for: 0, searchText: searchText)
        logicSearch(for: 1, searchText: searchText)
        print(searchEmployees[0])
        
        if searchEmployees[0].isEmpty && searchEmployees[1].isEmpty {
            throw AppError.emptyDataError
        }
        
        if sortedType == SortedType.birthday {
            sortedByBirthday(by: searchEmployees)
        } else if sortedType == SortedType.alphabetically {
            sortedByAlphabetically(by: searchEmployees)
        }
    }
    
    private func logicSearch(for index: Int, searchText: String) {
        for item in filteredEmployees[index] {
            if item.firstName.contains(searchText) || item.lastName.contains(searchText) || item.userTag.lowercased().contains(searchText) {
                if searchEmployees[index].contains(item) {
                    continue
                }
                searchEmployees[index].append(item)
            } else {
                if searchEmployees[index].contains(item) {
                    print(item.id)
                    let removeIndex = searchEmployees[index].firstIndex(of: item)
                    searchEmployees[index].remove(at: removeIndex!)
                }
            }
        }
    }
}

//MARK: SortedBottomSheetViewControllerDelegate
extension ViewController: SortedBottomSheetViewControllerDelegate {
    func sortedTableView(by selectedSortedType: SortedType) {
        
        if selectedSortedType == SortedType.birthday && sortedType != SortedType.birthday {
            sortedByBirthday(by: filteredEmployees)
            searchBar.setSortedIcon(for: Icons.sortActive)
        }
        else if selectedSortedType == SortedType.alphabetically && sortedType != SortedType.alphabetically {
            sortedByAlphabetically(by: filteredEmployees)
            searchBar.setSortedIcon(for: Icons.sortInactive)
        }
        sortedType = selectedSortedType
        tableView.reloadData()
    }
    
    private func sortedByBirthday(by employeesInput: [[User]]) {
        let dateFormatter = DateFormatter()
        let currentDate = Date()
        var tmpEmployees = employeesInput
        
        //Сортировка по дате рождения
        tmpEmployees[0] = tmpEmployees[0].sorted {
            dateFormatter.getMonth(date: $0.birthday) < dateFormatter.getMonth(date: $1.birthday)
        }
        tmpEmployees[0] = tmpEmployees[0].sorted {
            dateFormatter.getDay(date: $0.birthday) < dateFormatter.getDay(date: $1.birthday) && dateFormatter.getMonth(date: $0.birthday) == dateFormatter.getMonth(date: $1.birthday)
        }
        
        //Распределение пользователей по разделам таблицы в зависимости от даты рождения (текущий год/следующий год)
        sortedEmployees[0] = tmpEmployees[0].filter { dateFormatter.getMonth(date: $0.birthday) <= 12 && dateFormatter.getMonth(date: $0.birthday) > currentDate.monthInt || (dateFormatter.getMonth(date: $0.birthday) == currentDate.monthInt && dateFormatter.getDay(date: $0.birthday) >= currentDate.dayInt)}
        sortedEmployees[1] = tmpEmployees[0].filter {!(dateFormatter.getMonth(date: $0.birthday) <= 12 && dateFormatter.getMonth(date: $0.birthday) > currentDate.monthInt || (dateFormatter.getMonth(date: $0.birthday) == currentDate.monthInt && dateFormatter.getDay(date: $0.birthday) >= currentDate.dayInt))}
    }
    
    private func sortedByAlphabetically(by employeesInput: [[User]]) {
        sortedEmployees[0] = employeesInput[0].sorted {
            $0.firstName < $1.firstName
        }
        sortedEmployees[1] = []
    }
}

//MARK: Refresh Controll
extension ViewController {
    
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.tintColor = .clear
        
        refreshView = CircularProgressView()
        refreshView.frame = tableView.refreshControl!.bounds
        
        refreshLoadingView = UIView(frame: tableView.refreshControl!.bounds)
        refreshLoadingView.backgroundColor = .clear
        refreshLoadingView.clipsToBounds = true

        refreshLoadingView.addSubview(refreshView)
        refreshView.snp.makeConstraints({ make in
            make.center.equalTo(refreshLoadingView.snp.center)
        })

        tableView.refreshControl!.addSubview(self.refreshLoadingView)
    }

    
    private func refresh() {
        tableView.refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.searchBar.endEditing(true)
            self.updateDataTableView()
            self.refreshView.stopAnimation(for: AnimationType.spinner.rawValue)
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var refreshBounds = tableView.refreshControl!.bounds
        let pullDistance = max(0.0, -tableView.refreshControl!.frame.origin.y)
        if pullDistance == 0.0 {
            self.isRefreshAnimating = false
        }

        let midX = self.tableView.frame.size.width / 2.0
        
        let refreshViewHeight = self.refreshView.bounds.size.height
        let refreshViewHeightHalf = refreshViewHeight / 2.0
        
        let refreshViewWidth = self.refreshView.bounds.size.width
        let refreshViewWidthHalf = refreshViewWidth / 2.0
        
        let pullRatio = min(max(pullDistance, 0.0), 100.0) / 100.0
        
        let refreshViewY = pullDistance / 2.0 - refreshViewHeightHalf
        
        let refreshViewX = (midX - refreshViewWidth - refreshViewWidthHalf) + (refreshViewWidth * pullRatio)

        var refreshViewFrame = self.refreshView.frame
        refreshViewFrame.origin.x = refreshViewX
        refreshViewFrame.origin.y = refreshViewY;
        
        self.refreshView.frame = refreshViewFrame;
        
        refreshBounds.size.height = pullDistance;
        
        self.refreshLoadingView.frame = refreshBounds;
        
        if (self.isRefreshAnimating == false) {
            refreshView.setProgress(to: Float(pullRatio))
            isRefreshAnimating = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let pullDistance = max(0.0, -tableView.refreshControl!.frame.origin.y)
        let pullRatio = min(max(pullDistance, 0.0), 100.0) / 100.0
        if pullRatio == 1.0 {
            refreshView.basicAnimation()
            refresh()
            isRefreshAnimating = true
        }
    }
    
    
}

