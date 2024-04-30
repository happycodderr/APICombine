
import Foundation
import Combine

protocol Networkable {
    func fetchUsers<T:Decodable>(urlRequest: URLRequest, type: T.Type) -> AnyPublisher<T,Error>
}

final class NetworkManager: Networkable {
    func fetchUsers<T>(urlRequest: URLRequest, type: T.Type) -> AnyPublisher<T, any Error> where T : Decodable {
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{$0.data}
            .decode(type: type.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
