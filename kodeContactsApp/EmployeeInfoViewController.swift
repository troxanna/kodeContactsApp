//
//  EmployeeInfoViewController.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 19.02.2023.
//

import UIKit
import SnapKit

class EmployeeInfoViewController: UIViewController {
    //MARK: Private properties
    private var person: Person?
    
    func sendData(person: Person) {
        self.person = person
        print(person)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //создать кастомный navigation bar
    }
}

extension EmployeeInfoViewController {
    //MARK: Private methods
    
}
