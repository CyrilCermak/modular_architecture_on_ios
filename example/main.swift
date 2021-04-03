import Foundation
import Employee

let employee = Employee(firstName: "Cyril",
                       lastName: "Cermak",
                       address: EmployeeAddress(houseNo: 1, street: "PorschePlatz", city: "Stuttgart", state: "Germany"))

employee.printEmployeeInfo()
