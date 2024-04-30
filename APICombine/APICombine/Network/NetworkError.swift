
import Foundation

enum NetworkError: Error {
    case inValidURLError
    case dataNotFoundError
    case parsingError
    case responseError
}

extension NetworkError: LocalizedError, Equatable {
    var errorDescription: String? {
        switch self {
        case .inValidURLError:
            return NSLocalizedString("API Endpoint was wrong", comment: "inValidURLError")
        case .dataNotFoundError:
            return NSLocalizedString("API failed to give response", comment: "dataNotFoundError")
        case .parsingError:
            return NSLocalizedString("Failed to parse the received response", comment: "parsingError")
        case .responseError:
            return NSLocalizedString("Got invalid status code", comment: "responseError")
        }
    }
}
