import Foundation

public protocol Address {
    var houseNo: Int { get }
    var street: String { get }
    var city: String { get }
    var state: String { get }
}

public protocol Person {
    var firstName: String { get }
    var lastName: String { get }
    var address: Address { get }
}

public class Employee: Person {
    public let firstName: String
    public let lastName: String
    public let address: Address
    
    public init(firstName: String, lastName: String, address: Address) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
    }
    
    public func printEmployeeInfo() {
        print("\(firstName) \(lastName)")
        print("\(address.houseNo). \(address.street), \(address.city), \(address.state)")
    }
}

public class EmployeeAddress: Address {
    public let houseNo: Int
    public let street: String
    public let city: String
    public let state: String
    
    public init(houseNo: Int, street: String, city: String, state: String) {
        self.houseNo = houseNo
        self.street = street
        self.city = city
        self.state = state
    }
}

