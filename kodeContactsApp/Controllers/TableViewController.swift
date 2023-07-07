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

class TableViewController: UIViewController, SkeletonTableViewDataSource {
    
    //MARK: Private properties
    private var errorView: ErrorView?
    
    private var refreshLoadingView: UIView!
    private var refreshView: CircularProgressView!
    private var isRefreshAnimating = false
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    private var departmentSegmentedControll: DepartmentSegmentedControl = {
        let segmentedControl = DepartmentSegmentedControl(frame: .zero, items: Departments.departments)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.isUserInteractionDisabledWhenSkeletonIsActive = true
        return searchBar
    }()
    
    private let employeesList = EmployeeList() //weak?
    private var onCompletion: (_: () throws -> [User]) -> () = {_ in}

    //MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        contentConfigurationView()
        createTableView()
        initOnCompletion()
        setupTableView()
        setupRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView.animationCircular()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
}

//MARK: UITableViewDelegate
extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == employeesList.readSortedEmployees[indexPath.section].count && employeesList.readSortedEmployees[1].count != 0 {
            return
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell else {
            return
        }
        
        let viewController = EmployeeInfoViewController()
        viewController.sendData(person: employeesList.readSortedEmployees[indexPath.section][indexPath.row])
        viewController.sendImage(image: cell.avatarImage)
        navigationController?.pushViewController(viewController, animated: true)
        
        updateSearchBarEndEditing()
    }
}

//MARK: UITableViewDataSource
extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && employeesList.readSortedEmployees[1].count != 0 {
            return employeesList.readSortedEmployees[section].count + 1
        }
        return employeesList.readSortedEmployees[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return EmployeeTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == employeesList.readSortedEmployees[indexPath.section].count && employeesList.readSortedEmployees[1].count != 0 {
            return tableView.dequeueReusableCell(withIdentifier: YearTableViewCell.identifier) as! YearTableViewCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier) as! EmployeeTableViewCell
        
        let employee = employeesList.readSortedEmployees[indexPath.section][indexPath.row]
        
        cell.fullDataCell(data: employee)
        if employeesList.sortedType == SortedType.birthday {
            cell.userAgeIsHidden = false
        } else {
            cell.userAgeIsHidden = true
        }
        cell.configurationSkeletonHideForCell()
        
        return cell
    }
}

//MARK: Private functions
private extension TableViewController {
    func contentConfigurationTableView() {
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.width, height: 16)))
    }
    
    func contentConfigurationView() {
        view.backgroundColor = UIColor(named: Color.white.rawValue)
    }

    func createTableView() {
        view.addSubview(tableView)
        view.addSubview(departmentSegmentedControll)

        tableView.snp.makeConstraints { make in
            make.right.left.bottom.equalToSuperview()
            //offset 16
            make.top.equalTo(departmentSegmentedControll.snp.bottom)

        }
        departmentSegmentedControll.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        departmentSegmentedControll.delegate = self
    }
    
    func setupTableView() {
        contentConfigurationTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.identifier)
        tableView.register(YearTableViewCell.self, forCellReuseIdentifier: YearTableViewCell.identifier)
        
        skeletonShow()
        updateDataTableView()
    }
    
    func tableReloadData() {
        errorView?.removeFromSuperview()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func initOnCompletion() {
        onCompletion = {[weak self] users in
            do {
                let data = try users()
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.employeesList.insertData(data)
                    self.handlerFilteredEmployees(for: self.departmentSegmentedControll.currentActiveSegment)
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
            }}
    }
    
    func updateDataTableView() {
        if currentReachabilityStatus == .notReachable {
            handlerErrorInternetConnection()
        } else {
            do {
                try APIManager.shared.getUsers(completion: onCompletion)
            } catch {
                self.showError(screenError: .criticalError)
            }
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
}

//MARK: Skeleton for Table View
extension TableViewController {
    private func skeletonShow() {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient.init(baseColor: UIColor(named: Color.antiFlashWhite.rawValue)!, secondaryColor: UIColor(named: Color.lotion.rawValue)!), animation: nil, transition: .crossDissolve(0.5))
    }
    
    private func skeletonHide() {
        self.tableView.stopSkeletonAnimation()
        self.view.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
    }
}

//MARK: Handler error
extension TableViewController {
    private func showError(screenError: ScreenError) {
        errorView?.removeFromSuperview()
        errorView = screenError.errorView
        errorView!.delegate = self
        self.view.addSubview(errorView!)
        
        switch screenError {
        case .criticalError:
            errorView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            navigationController?.isNavigationBarHidden = true
            departmentSegmentedControll.removeFromSuperview()
        default:
            errorView!.snp.makeConstraints { make in
                make.right.left.bottom.equalToSuperview()
                make.top.equalTo(departmentSegmentedControll.snp.bottom)
            }
            tableView.isHidden = true
        }
        self.skeletonHide()
    }
}

//MARK: ErrorViewDelegate
extension TableViewController: ErrorViewDelegate {
    func buttonRepeatRequestPressed() {
        navigationController?.isNavigationBarHidden = false
        createTableView()
        updateDataTableView()
    }
}

//MARK: DepartmentSegmentedControlDelegate
extension TableViewController: DepartmentSegmentedControlDelegate {
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
            try employeesList.filteredEmployees(for: department)
            tableReloadData()
        }
        catch AppError.searchError {
            showError(screenError: .searchError)
        }
        catch {
            showError(screenError: .criticalError)
        }
    }
}

//MARK: UISearchBarDelegate
extension TableViewController: UISearchBarDelegate {
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
        searchBar.setSearchIcon(for: Icons.searchActive)
        searchBar.placeholder = nil
        searchBar.searchTextField.rightViewMode = .never
    }
    
    private func updateSearchBarEndEditing() {
        searchBar.placeholder = SearchTextFieldData.placeholder.text
        searchBar.endEditing(true)
        searchBar.searchTextField.rightViewMode = .always
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.setSearchIcon(for: Icons.searchInactive)
    }
    
    private func didTapSortButton() {
        let vc = SortedBottomSheetViewController(currentSortedType: employeesList.sortedType)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    private func handlerSearch(searchText: String) {
        do {
            try employeesList.searchEmployees(searchText: searchText)
            tableReloadData()
        } catch {
            showError(screenError: .searchError)
        }
    }
}

//MARK: SortedBottomSheetViewControllerDelegate
extension TableViewController: SortedBottomSheetViewControllerDelegate {
    func sortedTableView(by selectedSortedType: SortedType) {
        
        if selectedSortedType == SortedType.birthday && employeesList.sortedType != SortedType.birthday {
            employeesList.sortedByBirthday(by: TypeEmployeeList.filtered)
            searchBar.setSortedIcon(for: Icons.sortActive)
        }
        else if selectedSortedType == SortedType.alphabetically && employeesList.sortedType != SortedType.alphabetically {
            employeesList.sortedByAlphabetically(by: TypeEmployeeList.filtered)
            searchBar.setSortedIcon(for: Icons.sortInactive)
        }
        employeesList.sortedType = selectedSortedType
        tableView.reloadData()
    }
}

//MARK: Refresh Controll
extension TableViewController {
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.tintColor = .clear
        
        refreshView = CircularProgressView()
        refreshView.frame = tableView.refreshControl!.bounds
        
        refreshLoadingView = UIView(frame: tableView.refreshControl!.bounds)
        refreshLoadingView.backgroundColor = .clear
        refreshLoadingView.clipsToBounds = true

        refreshLoadingView.addSubview(refreshView)
        refreshView.snp.makeConstraints { make in
            make.center.equalTo(refreshLoadingView.snp.center)
        }

        tableView.refreshControl!.addSubview(self.refreshLoadingView)
    }

    
    private func refresh() {
        tableView.refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.searchBar.endEditing(true)
            self.updateDataTableView()
            self.refreshView.stopAnimation(for: AnimationType.spinner.rawValue)
            self.refreshView.stopAnimation(for: AnimationType.fill.rawValue)
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

//MARK: UpdateErrorViewController
private extension TableViewController {
    func handlerErrorInternetConnection() {
        let vc = InternetConnectionErrorViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            vc.dismiss(animated: true)
            self.skeletonHide()
        }
    }
}
