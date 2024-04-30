
import Foundation
import Combine

final class UserListViewModel: ObservableObject {
    @Published var userList: [User] = []
    @Published var filteredUserList: [User] = []
    @Published var customError: NetworkError?
    private var cancellable = Set<AnyCancellable>()
    private let networkManager: Networkable
    
    init(networkManager: Networkable) {
        self.networkManager = networkManager
    }
    
    func fetchUsersFromAPI(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        self.networkManager.fetchUsers(urlRequest: request, type: [User].self)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Task completed")
                    break
                case .failure(let error):
                    switch error {
                    case is DecodingError:
                        self.customError = NetworkError.parsingError
                    case is URLError:
                        self.customError = NetworkError.inValidURLError
                    case NetworkError.dataNotFoundError:
                        self.customError = NetworkError.dataNotFoundError
                    case NetworkError.responseError:
                        self.customError = NetworkError.responseError
                    default:
                        self.customError = NetworkError.dataNotFoundError
                    }
                }
            } receiveValue: { list in
                self.userList = list.sorted(by: { $0.name < $1.name })
                self.filteredUserList = list.sorted(by: { $0.name < $1.name })
            }.store(in: &cancellable)
    }
    
    func filterUsersList(searchText: String) {
        if searchText.isEmpty {
            self.filteredUserList = self.userList.sorted(by: { $0.name < $1.name })
        } else {
            let list = self.userList.filter { user in
                return user.name.localizedCaseInsensitiveContains(searchText)
            }
            self.filteredUserList = list.sorted(by: { $0.name < $1.name })
        }
    }
    
    func cancelAPICall() {
        print("Cancelled the request")
        cancellable.first?.cancel()
    }
}
