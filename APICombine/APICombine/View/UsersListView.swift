
import SwiftUI

struct UsersListView: View {
    @ObservedObject var viewModel = UserListViewModel(networkManager: NetworkManager())
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Cancel the API request") {
                    viewModel.cancelAPICall()
                }
                List(viewModel.filteredUserList) { user in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("UserName: \(user.username)")
                        Text("Name: \(user.name)")
                        Text("Email: \(user.email)")
                    }
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { newValue in
                print(newValue)
                viewModel.filterUsersList(searchText: newValue)
            })
            .onAppear {
                viewModel.fetchUsersFromAPI(urlString: APIEndPoint.UserEndPoint)
            }
        }
    }
}

#Preview {
    UsersListView()
}
