//
//  DataBaseManager.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 06/03/23.
//

import Foundation
import RealmSwift

class DBManager{
    private var database:Realm
    static let sharedInstance = DBManager()
    
    private init(){
        database = try! Realm()
    }
    
    func getDataFromDB() ->   Results<Country> {
        let results: Results<Country> =   database.objects(Country.self)
        return results
    }
    
    
    func getunSyncedDataFromDB() ->   Results<Country> {
        let results: Results<Country> = database.objects(Country.self).filter("countryId == %@", false)
        
        return results
    }
    
    func addData(object: Country)   {
        try! database.write {
            database.add(object, update: .all)
        }
    }
    
    func deleteAllDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDb(object: Country) {
        try! database.write {
            database.delete(object)
        }
    }
    
    func updateObject(object:Country, value:Bool) {
        try! database.write {
            database.add(object, update: .modified)
        }
    }
    
}
