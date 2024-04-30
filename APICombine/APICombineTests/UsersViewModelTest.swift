
import Combine
import Foundation
@testable import APICombine
import XCTest


final class UsersViewModelTest: XCTestCase {
    var userViewModel: UserListViewModel!
    
    override func setUpWithError() throws {
        userViewModel = UserListViewModel(networkManager: MockNetworkManager())
    }

    override func tearDownWithError() throws {
            userViewModel =  nil
        }

        func testAPICallForWhenEveryThingGoesCorrect() throws {
            userViewModel.fetchUsersFromAPI(urlString: "UsersMockTest")
            
            let expectation = XCTestExpectation(description: "Fetching USers list")
            let waitDuration = 3.0
            
            DispatchQueue.main.async {
                XCTAssertNotNil(self.userViewModel)
                XCTAssertEqual(self.userViewModel.userList.count, 10)
                XCTAssertNil(self.userViewModel.customError)
                expectation.fulfill()
            }
           wait(for: [expectation],timeout: waitDuration)

            
        }

        func testAPICallWhenAPIFails() throws {
            userViewModel.fetchUsersFromAPI(urlString: "asfd")
            
            let expectation = XCTestExpectation(description: "Fetching USers list")
            let waitDuration = 3.0
            
            DispatchQueue.main.async {
                XCTAssertNotNil(self.userViewModel)
                XCTAssertEqual(self.userViewModel.userList.count, 0)
                XCTAssertNotNil(self.userViewModel.customError)
                expectation.fulfill()
            }
           wait(for: [expectation],timeout: waitDuration)

            
        }
        func testPerformanceExample() throws {
            // This is an example of a performance test case.
            self.measure {
                // Put the code you want to measure the time of here.
            }
        }

    }

final class MockNetworkManager: Networkable {
    func fetchDataFromAPI<T>(urlRequest: URLRequest, type: T.Type) -> AnyPublisher<T, any Error> where T : Decodable {
        let bundle = Bundle(for: MockNetworkManager.self)
        let urlString = urlRequest.url?.absoluteString
        guard let url = bundle.url(forResource: urlString, withExtension: "json") else 
        { 
            return Fail(error: NetworkError.inValidURLError).eraseToAnyPublisher()
        }
        do {
            let data = try Data(contentsOf: url)
            let userList = try JSONDecoder().decode(type.self, from: data)
            return Just(userList)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            print(error.localizedDescription)
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
