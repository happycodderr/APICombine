

import Foundation

struct User: Decodable, Identifiable, Hashable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
    
}

// MARK: Address
struct Address: Decodable, Hashable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: Geo
struct Geo: Decodable, Hashable {
    let lat, lng: String
}

// MARK: Company
struct Company: Decodable, Hashable {
    let name, catchPhrase, bs: String
}

extension User {
    static let user: [User] = [ User(id: 1, name: "XYZ", username: "xyzuser", email: "xyz@gmail.com", address: Address(street: "Test Street", suite: "123", city: "Test", zipcode: "AB10 0CV", geo: Geo(lat: "10.0", lng: "10.0")), phone: "01234567890", website: "xyz@website.com", company: Company(name: "XYZCompany", catchPhrase: "You got the best", bs: "XX"))]
}
