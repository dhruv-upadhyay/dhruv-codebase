//
//  DashboardViewModel.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation
import CoreData

class DashboardViewModel {
    private let context = AppDelegate.shared.persistentContainer.viewContext
    var isShow: Bool = false
    var allUsers: [Users] = []
    var allContacts: [UserContacts] = []
    var contactList: [ContactListModel] = []
    
    func saveUser(_ completion: @escaping () -> Void) {
        let group = DispatchGroup()
        let userQueue = DispatchQueue(label: "userRecord")
        group.enter()
        let uuid: UUID = UUID()
        userQueue.async { [weak self] in
            guard let self = self else { return }
            
            let params: [String: Any] = ["userId": uuid, "username":"dhruv-upadhyay", "email":"dhruv.upadhyay8458@gmail.com", "firstName":"Dhruv", "lastName":"Upadhyay", "createdAt":Date()]
            
            Database.shared.saveRecord("Users", attributes: params, context: self.context) { (result: Result<Users, Error>) in
                switch result {
                case .success(let user):
                    // Handle success
                    print("Successfully saved person with name: \(user.firstName ?? "")")
                    group.leave()
                case .failure(let error):
                    // Handle error
                    print("Failed to save person: \(error.localizedDescription)")
                    group.leave()
                }
            }
        }
        
        group.enter()
        
        userQueue.async { [weak self] in
            guard let self = self else { return }
            
            let params: [String: Any] = ["id":UUID(), "userId": uuid, "number": "+91 96871 32957", "type": "1"]
            
            Database.shared.saveRecord("UserContacts", attributes: params, context: self.context) { (result: Result<UserContacts, Error>) in
                switch result {
                case .success(let contact):
                    // Handle success
                    print("Successfully saved contact: \(contact.number ?? "")")
                    group.leave()
                case .failure(let error):
                    // Handle error
                    print("Failed to save person: \(error.localizedDescription)")
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("Successfully Done!")
            completion()
        }
    }
    
    func fetchUsersAndContacts(completion: @escaping () -> Void) {
        allContacts = []
        contactList = []
        let group = DispatchGroup()
        var fetchError: Error?
        
        group.enter()
        Database.shared.fetchRecords("Users", context: context) { [weak self] (result: Result<[Users], Error>) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let users):
                strongSelf.allUsers = users
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        group.enter()
        Database.shared.fetchRecords("UserContacts", context: context) { [weak self] (result: Result<[UserContacts], Error>) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let contacts):
                strongSelf.allContacts = contacts
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            if fetchError != nil {
                completion()
            } else {
                strongSelf.mapUserData()
                completion()
            }
        }
    }
    
    private func mapUserData() {
        // Map allUsers and allContacts to ContactListModel
        isShow = allUsers.count > 0
        
        for user in allUsers {
            let userContacts = allContacts.filter { $0.userId == user.userId }
            for contact in userContacts {
                var firstName = ""
                var lastName = ""
                if let value = user.firstName {
                    firstName = value
                }
                
                if let value = user.lastName {
                    lastName = value
                }
                
                let contactModel = ContactListModel(name: firstName + " " + lastName, number: contact.number ?? "", userProfile: "")
                contactList.append(contactModel)
            }
        }
    }
    
    
    func getUser(index: Int) -> ContactListModel {
        return contactList.at(index: index) ?? ContactListModel()
    }
    
    func getUserCount() -> Int {
        return contactList.count
    }
}
