//
//  EmployeeDetailViewController.swift
//  C0695372_CoreDataExample
//
//  Created by Rodrigo Coutinho on 2017-07-10.
//  Copyright © 2017 Rodrigo Coutinho. All rights reserved.
//

import UIKit
import CoreData

class EmployeeDetailViewController: UIViewController {

    @IBOutlet var employeeIdTextField: UITextField!
    @IBOutlet var employeeNameTextField: UITextField!
    @IBOutlet var employeeSalaryTextField: UITextField!
    @IBOutlet var employeeBirthdatePicker: UIDatePicker!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let employee = employee {
            title = "Edit employee"
            
            employeeIdTextField.text = "\(employee.id)"
            employeeNameTextField.text = employee.name
            employeeSalaryTextField.text = String(format: "%.2f", employee.salary)
            employeeBirthdatePicker.date = employee.birthdate! as Date
        }
    }

    @IBAction func closeDetails(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveEmployee(_ sender: UIBarButtonItem) {
        
        guard let employeeIdStr = employeeIdTextField.text, !employeeIdStr.isEmpty, let employeeId = Int32(employeeIdStr) else {
            let alertController = UIAlertController(title: "Missing employee Id", message: "Please inform the employee id", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            employeeIdTextField.becomeFirstResponder()
            return
        }
        
        guard let employeeName = employeeNameTextField.text, !employeeName.isEmpty else {
            let alertController = UIAlertController(title: "Missing employee name", message: "Please inform the employee name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            employeeNameTextField.becomeFirstResponder()
            return
        }
        
        guard let employeeSalaryStr = employeeSalaryTextField.text, !employeeSalaryStr.isEmpty, let salary = Double(employeeSalaryStr) else {
            let alertController = UIAlertController(title: "Missing employee salary", message: "Please inform the employee salary", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            employeeSalaryTextField.becomeFirstResponder()
            return
        }
        
        saveEmployee(id: employeeId, name: employeeName, salary: salary)
        
    }
    
    func saveEmployee(id: Int32, name: String, salary: Double) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Employee", in: managedContext)!
        
        if let employee = self.employee {
            
            employee.id = id
            employee.name = name
            employee.salary = salary
            employee.birthdate = employeeBirthdatePicker.date as NSDate
            
        } else {
        
            let employee = NSManagedObject(entity: entity, insertInto: managedContext) as! Employee
            
            employee.id = id
            employee.name = name
            employee.salary = salary
            employee.birthdate = employeeBirthdatePicker.date as NSDate
            
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
        
        dismiss(animated: true, completion: nil)
        
    }

}
