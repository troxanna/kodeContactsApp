//
//  EmployeeList.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 13.05.2023.
//

import Foundation

final class EmployeeList {
    private var employees: [[User]] = [[], []]
    private var filteredEmployees: [[User]] = [[], []]
    private var sortedEmployees: [[User]] = [[], []]
    private var searchEmployees: [[User]] = [[], []]
    
    // getters
    var readEmployees: [[User]] {
        return employees
    }
    var readFilteredEmployees: [[User]] {
        return filteredEmployees
    }
    var readSortedEmployees: [[User]] {
        return sortedEmployees
    }
    var readSearchEmployees: [[User]] {
        return searchEmployees
    }
    
    var sortedType = SortedType.alphabetically
    
    init () {}
}

extension EmployeeList {
    func insertData(_ data: [User]) {
        employees[0] = data
        sortedEmployees[0] = data
        filteredEmployees[0] = data
        searchEmployees[0] = []
        searchEmployees[1] = []
    }
    
    func filteredEmployees(for department: String) throws {
        if employees[0].isEmpty && employees[1].isEmpty {
            return
        }
        if department == Departments.all.value {
            filteredEmployees[0] = employees[0]
        } else {
            filteredEmployees[0] = employees[0].filter { Departments(rawValue: $0.department)?.value == department }
        }
        if sortedType == SortedType.birthday {
            sortedByBirthday(by: TypeEmployeeList.filtered)
        } else if sortedType == SortedType.alphabetically {
            sortedByAlphabetically(by: TypeEmployeeList.filtered)
        }
        if filteredEmployees[0].isEmpty && filteredEmployees[1].isEmpty {
            throw AppError.searchError
        }
    }
    
    func searchEmployees(searchText: String) throws {
        if filteredEmployees[0].isEmpty && filteredEmployees[1].isEmpty {
            throw AppError.emptyDataError
        }
        logicSearch(for: 0, searchText: searchText)
        logicSearch(for: 1, searchText: searchText)
        print(searchEmployees[0])
        
        if searchEmployees[0].isEmpty && searchEmployees[1].isEmpty {
            throw AppError.emptyDataError
        }
        
        if sortedType == SortedType.birthday {
            sortedByBirthday(by: TypeEmployeeList.search)
        } else if sortedType == SortedType.alphabetically {
            sortedByAlphabetically(by: TypeEmployeeList.search)
        }
    }
    
    func sortedByBirthday(by employeesInput: TypeEmployeeList) {
        var tmpEmployees: [[User]] = [[], []]
        
        switch employeesInput {
        case .base:
            tmpEmployees = employees
        case .filtered:
            tmpEmployees = filteredEmployees
        case .search:
            tmpEmployees = searchEmployees
        case .sorted:
            tmpEmployees = sortedEmployees
        }
        
        logicSortedByBirthday(by: tmpEmployees)
    }
    
    func sortedByAlphabetically(by employeesInput: TypeEmployeeList) {
        var tmpEmployees: [[User]] = [[], []]
        
        switch employeesInput {
        case .base:
            tmpEmployees = employees
        case .filtered:
            tmpEmployees = filteredEmployees
        case .search:
            tmpEmployees = searchEmployees
        case .sorted:
            tmpEmployees = sortedEmployees
        }
        
        logicSortedByAlphabetically(by: tmpEmployees)
    }
}

private extension EmployeeList {
    private func logicSortedByAlphabetically(by employeesInput: [[User]]) {
        sortedEmployees[0] = employeesInput[0].sorted {
            $0.firstName < $1.firstName
        }
        sortedEmployees[1] = []
    }
    
    private func logicSortedByBirthday(by employeesInput: [[User]]) {
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
