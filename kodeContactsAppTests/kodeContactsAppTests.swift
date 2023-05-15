//
//  kodeContactsAppTests.swift
//  kodeContactsAppTests
//
//  Created by Anastasia Nevodchikova on 14.02.2023.
//

import XCTest
@testable import kodeContactsApp


class kodeContactsAppTests: XCTestCase {

    var sut: EmployeeList!
    
    override func setUpWithError() throws {
        sut = EmployeeList()
    }
    
    func testInsertData() {
        // given
        let employees = [User(id: "58ce2239-fafb-4131-bb6e-16dd0d959deb", firstName: "Cade", lastName: "Willms", department: "analytics", position: "Representative", birthday: "1992-07-01", phone: "476-766-4756", userTag: "IQ", avatarURL: "avatarUrl"), User(id: "0ca33d9e-181f-4777-b577-ff1719868523", firstName: "Deondre", lastName: "Kerluke", department: "pr", position: "Analyst", birthday: "1966-04-02", phone: "988-467-6678", userTag: "PG", avatarURL: "avatarUrl"), User(id: "ddbba54d-cabf-4a50-a83d-2eae50bfbee5", firstName: "Viola", lastName: "Brown", department: "analytics", position: "Architect", birthday: "1979-01-01", phone: "420-997-6912", userTag: "SJ", avatarURL: "avatarUrl"), User(id: "c5c078f0-9226-4557-bbb9-c3037ceb048a", firstName: "Christelle", lastName: "Heaney", department: "pr", position: "Officer", birthday: "2001-03-07", phone: "317-469-1282", userTag: "AL", avatarURL: "avatarUrl")]

        // when
        sut.insertData(employees)
        
        // then
        XCTAssertEqual(sut.readEmployees[0].count, employees.count, "Employees count error")
        XCTAssertEqual(sut.readSortedEmployees[0].count, employees.count, "Sorted Employees count error")
        XCTAssertEqual(sut.readFilteredEmployees[0].count, employees.count, "Filtered Employees count error")
        XCTAssertEqual(sut.readSearchEmployees[0].count, 0, "Search Employees count error")
    }
    
    func testSortedByAlphabetically() {
      // given
  
        
      // when


      // then

    }

    override func tearDownWithError() throws {
        sut = nil
    }

}
