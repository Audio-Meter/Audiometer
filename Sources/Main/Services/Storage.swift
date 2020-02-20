//
//  Storage.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 9/2/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation
import CoreData
import os
import Apollo

class Storage {
    // MARK: - local properties
    private let storage: PersistentContainer
    private let context: NSManagedObjectContext
    var authService: AuthorizationServiceProtocol = AuthorizationService()
    
    init(storage: PersistentContainer) {
        self.storage = storage
        self.context = storage.viewContext
    }
    
    //MARK: - create
    func createUser(email:String, password:String, token:String) {
        let userType = NSEntityDescription.entity(forEntityName: "CoreDataUser",
                                                    in: context)
        let userEntity = NSManagedObject(entity: userType!, insertInto: context)
        userEntity.setValue(email, forKey: "email")
        userEntity.setValue(password, forKey: "password")
        userEntity.setValue(token, forKey: "token")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func updateUser(email:String, password:String, token:String) {
        guard let user = getUserByEmail(email) else {
            return
        }

        user.setValue(password, forKey: "password")
        user.setValue(token, forKey: "token")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func createClinic(clinic: LocalClinic) -> NSManagedObjectID? {
        if(Storage.currentUser() == nil) {
            return nil
        }
        let clinicType = NSEntityDescription.entity(forEntityName: "CoreDataLocalClinic",
                                                    in: context)

        let clinicEntity = NSManagedObject(entity: clinicType!, insertInto: context)

        clinicEntity.setValue(clinic.name, forKey: "name")
        clinicEntity.setValue(clinic.website, forKey: "website")
        clinicEntity.setValue(clinic.address, forKey: "address")
        clinicEntity.setValue(clinic.tel, forKey: "tel")
        clinicEntity.setValue(clinic.fax, forKey: "fax")
        clinicEntity.setValue(false, forKey: "sync")
        clinicEntity.setValue(clinic.signature, forKey: "signature")
        clinicEntity.setValue(getUserByEmail(Storage.currentUser()!), forKey: "user")
        clinicEntity.setValue(clinic.logo, forKey: "logo")
        do {
            try context.save()
            return clinicEntity.objectID
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return nil
    }

    func createClinician(clinician: LocalClinician) -> NSManagedObjectID? {
        if(Storage.currentUser() == nil) {
            return nil
        }

        let clinicianType = NSEntityDescription.entity(forEntityName: "CoreDataLocalClinician",
                                                       in: context)

        let clinicianEntity = NSManagedObject(entity: clinicianType!, insertInto: context)

        clinicianEntity.setValue(clinician.name, forKey: "name")
        clinicianEntity.setValue(clinician.email, forKey: "email")
        clinicianEntity.setValue(clinician.certification, forKey: "certification")
        clinicianEntity.setValue(clinician.degrees, forKey: "degrees")
        clinicianEntity.setValue(clinician.pcp, forKey: "pcp")
        clinicianEntity.setValue(clinician.signature, forKey: "signature")
        clinicianEntity.setValue(false, forKey: "sync")
        clinicianEntity.setValue(getUserByEmail(Storage.currentUser()!), forKey: "user")

        do {
            try context.save()
            return clinicianEntity.objectID
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    //MARK: - update
    
    func updateClinic(clinic: LocalClinic) -> Bool {
        if clinic.objectID == nil {
            return false
        }

        do {
            let clinicEntity = try context.existingObject(with: clinic.objectID!)

            clinicEntity.setValue(clinic.name, forKey: "name")
            clinicEntity.setValue(clinic.website, forKey: "website")
            clinicEntity.setValue(clinic.address, forKey: "address")
            clinicEntity.setValue(clinic.tel, forKey: "tel")
            clinicEntity.setValue(clinic.fax, forKey: "fax")
            clinicEntity.setValue(clinic.signature, forKey: "signature")
            clinicEntity.setValue(false, forKey: "sync")
            clinicEntity.setValue(clinic.logo, forKey: "logo")
            try context.save()
            return true
       
        } catch let error as NSError {
                print("Could not find. \(error), \(error.userInfo)")
        }
        return false
    }
    
    func updateClinician(clinician: LocalClinician) -> Bool {
        if clinician.objectID == nil {
            return false
        }
        
        do {
            let clinicianEntity = try context.existingObject(with: clinician.objectID!)
            
            clinicianEntity.setValue(clinician.name, forKey: "name")
            clinicianEntity.setValue(clinician.email, forKey: "email")
            clinicianEntity.setValue(clinician.certification, forKey: "certification")
            clinicianEntity.setValue(clinician.degrees, forKey: "degrees")
            clinicianEntity.setValue(clinician.pcp, forKey: "pcp")
            clinicianEntity.setValue(clinician.signature, forKey: "signature")
            clinicianEntity.setValue(false, forKey: "sync")
            
            try context.save()
            return true
            
        } catch let error as NSError {
            print("Could not find. \(error), \(error.userInfo)")
        }
        return false
    }
    
    //MARK: - get
    
    func getAudioData(id: String) -> NSData? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataAudio")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let result = try context.fetch(fetchRequest)
            if(result.count > 0) {
                let rd = result.first! as! NSManagedObject
                
                return rd.value(forKey: "data") as? NSData
            }
        } catch {
            return nil
        }
        return nil

    }
    
    func getClinic(id: NSManagedObjectID) -> LocalClinic? {
        do {
            let clinic = try context.existingObject(with: id)
            if(clinic != nil) {
                var rs = LocalClinic()
                rs.name = clinic.value(forKey: "name") as? String
                rs.email = clinic.value(forKey: "email") as? String
                rs.address = clinic.value(forKey: "address") as? String
                rs.fax = clinic.value(forKey: "fax") as? String
                rs.tel = clinic.value(forKey: "tel") as? String
                rs.website = clinic.value(forKey: "website") as? String
                rs.sync = clinic.value(forKey: "sync") as? Bool ?? false
                rs.objectID = clinic.objectID
                
                return rs
            }
        } catch let error as NSError {
            print("Could not find. \(error), \(error.userInfo)")
        }

        return nil
    }
    
    func getAudioById(_ id: String) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataAudio")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let result = try context.fetch(fetchRequest)
            if(result.count > 0) {
                let data = result.first! as! NSManagedObject
                return data
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func getClinicByName(_ name: String) -> NSManagedObject? {
        guard let userEmail = Storage.currentUser() else {
            return nil
        }
        guard let user = getUserByEmail(userEmail) else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataLocalClinic")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name = %@ AND user = %@", name, user)
        
        do {
            let result = try context.fetch(fetchRequest)
            if(result.count > 0) {
                let data = result.first! as! NSManagedObject
                return data
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func getClinicianByName(_ name: String) -> NSManagedObject? {
        guard let userEmail = Storage.currentUser() else {
            return nil
        }
        guard let user = getUserByEmail(userEmail) else {
            return nil
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataLocalClinician")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name = %@ AND user = %@", name, user)

        do {
            let result = try context.fetch(fetchRequest)
            if(result.count > 0) {
                let data = result.first! as! NSManagedObject
                return data
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func getClinician(id: NSManagedObjectID) -> LocalClinician? {
        do {
            let clinician = try context.existingObject(with: id)
            if(clinician != nil) {
                var rs = LocalClinician()
                rs.name = clinician.value(forKey: "name") as? String
                rs.email = clinician.value(forKey: "email") as? String
                rs.certification = clinician.value(forKey: "certification") as? String
                rs.degrees = clinician.value(forKey: "degrees") as? String
                rs.pcp = clinician.value(forKey: "pcp") as? Bool
                rs.sync = clinician.value(forKey: "sync") as? Bool ?? false
                rs.objectID = clinician.objectID
                
                return rs
            }
        } catch let error as NSError {
            print("Could not find. \(error), \(error.userInfo)")
        }

        return nil
    }
    
    func getObect(byID: NSManagedObjectID) -> NSManagedObject? {
        do {
            let obj = try context.existingObject(with: byID)
            return obj
        } catch {
            return nil
        }
    }
    
    func getUserByEmail(_ email: String) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataUser")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)
        do {
            let result = try context.fetch(fetchRequest)
            if(result.count > 0) {
                let data = result.first! as! NSManagedObject
                return data
            }
        } catch {
            return nil
        }
        return nil
    }
    
//    func getUserByName(_ name: String) -> NSManagedObject? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataUser")
//        fetchRequest.fetchLimit = 1
//        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
//        do {
//            let result = try context.fetch(fetchRequest)
//            if(result.count > 0) {
//                let data = result.first! as! NSManagedObject
//                return data
//            }
//        } catch {
//            return nil
//        }
//        return nil
//    }
    
    // MARCH - fetch
    
    func fetchClinics() -> [LocalClinic] {
        guard let userEmail = Storage.currentUser() else {
            return []
        }
        guard let user = getUserByEmail(userEmail) else {
            return []
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataLocalClinic")
        fetchRequest.predicate = NSPredicate(format: "user = %@", user)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let clinics = try context.fetch(fetchRequest)
            var rs: [LocalClinic] = []
            for clinic in clinics {
                let lc = LocalClinic()
                lc.name = clinic.value(forKey: "name") as? String
                lc.email = clinic.value(forKey: "email") as? String
                lc.address = clinic.value(forKey: "address") as? String
                lc.fax = clinic.value(forKey: "fax") as? String
                lc.tel = clinic.value(forKey: "tel") as? String
                lc.website = clinic.value(forKey: "website") as? String
                lc.sync = clinic.value(forKey: "sync") as? Bool ?? false
                lc.objectID = clinic.objectID
                lc.signature = clinic.value(forKey: "signature") as? NSData
                lc.logo = clinic.value(forKey: "logo") as? NSData
                rs.append(lc)
            }
            return rs
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }

    func fetchClinicians() -> [LocalClinician] {
        guard let userEmail = Storage.currentUser() else {
            return []
        }
        guard let user = getUserByEmail(userEmail) else {
            return []
        }


        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataLocalClinician")
        fetchRequest.predicate = NSPredicate(format: "user = %@", user)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        do {
            let clinicians = try context.fetch(fetchRequest)
            var rs: [LocalClinician] = []
            for clinician in clinicians {
                var lc = LocalClinician()
                lc.name = clinician.value(forKey: "name") as? String
                lc.email = clinician.value(forKey: "email") as? String
                lc.certification = clinician.value(forKey: "certification") as? String
                lc.degrees = clinician.value(forKey: "degrees") as? String
                lc.pcp = clinician.value(forKey: "pcp") as? Bool
                lc.sync = clinician.value(forKey: "sync") as? Bool ?? false
                lc.signature = clinician.value(forKey: "signature") as? NSData
                lc.objectID = clinician.objectID

                rs.append(lc)
            }
            return rs
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func remoteLogin(email: String, password:String,completion: @escaping (_ token: String?, _ error :Error?) -> Void) {
        let login = LoginMutation(email: email, password: password)
        ApolloClient.sharedClient.perform(mutation: login) { (result) in
            
            switch result {
            case .success(let graphQLResult):
                guard let token = graphQLResult.data?.login else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty authorizarion token"])
                    completion(nil, error)
                    return
                }
                
                completion(token, nil)
            case .failure(let error):
                completion(nil, error)
            }

//            ApolloClient.add(authorizationToken: token)
//            KeychainSwift().set(password, forKey: AuthorizationService.kAuthorizationServicePassword)
        }
    }
    
    static func currentUser() -> String? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "CurrentUser") as? String
    }
    
    static func setCurrentUser(_ email: String) -> Void {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "CurrentUser")
    }
    
//    static var currentUser: String? = nil
    func login(email: String, password:String, completion: @escaping (Error?) -> Void) {
        // Try local login
        let user = getUserByEmail(email)
        if user != nil && user!.value(forKey: "password") as! String == password {
            guard let email = user?.value(forKey: "email") as? String else {
                assert(false, "Email can not be nil");
                return
            }
            Storage.setCurrentUser(email)
            ApolloClient.add(authorizationToken: user!.value(forKey: "token") as! String)

            completion(nil)
            return
        }

        // Try remote login
        remoteLogin(email: email, password: password, completion: {(token, err) in
            if err == nil && token != nil && !token!.isEmpty {
                if self.getUserByEmail(email) != nil {
                    self.updateUser(email:email, password: password, token: token!)
                } else {
                    self.createUser(email:email, password: password, token: token!)
                }
                Storage.setCurrentUser(email)

                ApolloClient.add(authorizationToken: token!)

                completion(nil)
                return
            } else {
                if err == nil {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Login Failed."])
                    completion(error)
                } else {
                    completion(err)
                }
            }
        })
    }

    // MARK: - delete
    func deleteAudioById(id: String) -> Void {
        let obj = getAudioById(id)
        if obj != nil {
            context.delete(obj!)
        }
    }
    
    func deleteClinicByName(clinicName: String) -> Void {
        let obj = getClinicByName(clinicName)
        if obj != nil {
            context.delete(obj!)
        }
    }
    
    func deleteClinicianByName(clinicianName: String) -> Void {
        let obj = getClinicianByName(clinicianName)
        if obj != nil {
            context.delete(obj!)
        }
    }

    // MARK: - selected
    func setSelectedClinic(clinicName: String) -> Void {
        let defaults = UserDefaults.standard
        defaults.set(clinicName, forKey: "SelectedClinicName")
    }
    
    func getSelectedClinicName() -> String {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "SelectedClinicName") ?? ""
    }

    func setSelectedClinicians(clinicianNames: [String]) -> Void {
        let defaults = UserDefaults.standard
        defaults.set(clinicianNames, forKey: "SelectedClinicianNames")
    }
    
    func getSelectedClinicians() -> [String] {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: "SelectedClinicianNames") as? [String] ?? []
    }
    
    func isClinicSelected(name: String) -> Bool {
        if name.isEmpty {
            return false
        }
        
        return getSelectedClinicName() == name
    }
    
    func isClinicianSelected(name: String) -> Bool {
        return getSelectedClinicians().contains(name)
    }

    // MARK: AUDIO
    private var userAudioFolder : URL? {
        let usrAudioFolder = self.pathToAudioFolder.appendingPathComponent(Storage.currentUser()?.withoutSpecialCharacters ?? "local_user")
        
        let fileManeger = FileManager.default
        if fileManeger.fileExists(atPath: usrAudioFolder.path) == false {
            do {
                try fileManeger.createDirectory(atPath: usrAudioFolder.path,
                                               withIntermediateDirectories: false,
                                               attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
                return nil
            }
        }

        return usrAudioFolder
    }
    
    private var pathToAudioFolder: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let folderName = "Audios"
        let res = documentsDirectory.appendingPathComponent(folderName)
        let fileManeger = FileManager.default
        if fileManeger.fileExists(atPath: res.path) == false {
            do {
                try fileManeger.createDirectory(atPath: res.path,
                                                withIntermediateDirectories: false,
                                                attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        return res
    }

    func deleteAudio(_ id: NSManagedObjectID) throws {
        guard let userEmail = Storage.currentUser() else {
            return
        }
        guard getUserByEmail(userEmail) != nil else {
            return
        }
        
        guard let objToDel = getObect(byID: id) else {
            return
        }
        
        context.delete(objToDel)
        try context.save()
    }
    
    func createAudio(_ audio: LocalAudio, nsdata: NSData?) throws -> Bool {
        // Parameter check
        if(Storage.currentUser() == nil || audio.beginTimePs.count <= 0 || audio.beginTimePs.count != audio.endTimePs.count) {
            return false
        }
        
        guard let data = nsdata else {
            return false
        }

        let audioType = NSEntityDescription.entity(forEntityName: "CoreDataAudio", in: context)
        let audioEntity = NSManagedObject(entity: audioType!, insertInto: context)

        audioEntity.setValue(audio.name, forKey: "name")
        audioEntity.setValue(data, forKey: "data")
        audioEntity.setValue(getUserByEmail(Storage.currentUser()!), forKey: "user")
        audioEntity.setValue(audio.beginTimePs, forKey: "beginTimePs")
        audioEntity.setValue(audio.endTimePs, forKey: "endTimePs")
        audioEntity.setValue(audio.wordList, forKey: "wordList")
        audioEntity.setValue(audio.category, forKey: "category")
        audioEntity.setValue(audio.fileName, forKey: "fileName")
        audioEntity.setValue(audio.txtFileName, forKey: "txtFileName")

        try context.save()
        return true
    }
    
    func getAllAudio() -> [LocalAudio] {
        guard let userEmail = Storage.currentUser() else {
            return []
        }
        guard let user = getUserByEmail(userEmail) else {
            return []
        }
        guard let userFolder = self.userAudioFolder else {
            return []
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDataAudio")
        fetchRequest.predicate = NSPredicate(format: "user = %@", user)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.propertiesToFetch = ["name", "fileName", "txtFileName", "category", "beginTimePs", "endTimePs", "wordList"]
        do {
            let audios = try context.fetch(fetchRequest)
            var rs: [LocalAudio] = []
            for audio in audios {
                let la = LocalAudio()
                la.objectID = audio.objectID
                la.name = audio.value(forKey: "name") as? String
                la.fileName = audio.value(forKey: "fileName")  as? String
                la.txtFileName = audio.value(forKey: "txtFileName")  as? String
                la.category = audio.value(forKey: "category") as? String
                la.beginTimePs = audio.value(forKey: "beginTimePs") as? [Double] ?? []
                la.endTimePs = audio.value(forKey: "endTimePs") as? [Double] ?? []
                la.wordList = audio.value(forKey: "wordList") as? [String] ?? []
                la.cacheFilePath = userFolder.appendingPathComponent(la.fileName ?? "noname_file")
                if checkAudioCache(audio: la) {
                    rs.append(la)
                }
            }
            return rs
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func checkAudioCache(audio: LocalAudio) -> Bool {
        guard let _path = audio.cacheFilePath?.path else {
            return false
        }
        guard let objId = audio.objectID else {
            return false
        }

        let fileManeger = FileManager.default
        if fileManeger.fileExists(atPath: _path) == false {
            guard let obj = getObect(byID: objId) else {
                return false
            }
            guard let _data =  obj.value(forKey: "data") as? NSData else {
                return false
            }
            return fileManeger.createFile(atPath: _path, contents: Data(referencing: _data), attributes: nil)
        } else {
            return true
        }
    }
    
//    func syncClinics() -> Bool {
//        LocalClinicService.fetchLocalClinics(completion: {(rs, error) in
//            if error == nil {
//                for localClinic in rs {
//
//                }
//            }
//        })
//
//        let clinics = getClinics()
//
//        for clinic in clinics {
//            if clinic.server_id == nil {
//                LocalClinicService.createLocalClinic(clinic: clinic, completion: { (id, error) in
//                    if((error) != nil) {
//                        return
//                    }
//
//                    do {
//                        if(id != nil) {
//                            let savedClinic = try self.context.existingObject(with: clinic.objectID! )
//                            savedClinic.setValue(id, forKey: "server_id")
//                            savedClinic.setValue(true, forKey: "sync")
//                        }
//                        try self.context.save()
//                    } catch let error as NSError {
//                        print("in createLocalClinic. \(error), \(error.userInfo)")
//                        return
//                    }
//                })
//            } else if !clinic.sync {
//                LocalClinicService.updateLocalClinic(clinic: clinic, completion: { (rs, error) in
//                    if((error) != nil) {
//                        return
//                    }
//                    do {
//                        let savedClinic = try self.context.existingObject(with: clinic.objectID! )
//                        savedClinic.setValue(true, forKey: "sync")
//                        try self.context.save()
//                    } catch let error as NSError {
//                        print("in updateLocalClinic. \(error), \(error.userInfo)")
//                        return
//                    }
//                })
//            }
//        }
//
//        return true
//    }
    
    
    //        LocalClinicianService.fetchLocalClinicians(completion: {(rs, error) in
    //            if error == nil {
    //                for localClinic in rs {
    //                    self.clinicians.append(localClinic)
    //                }
    //                self.clinicianTableView.reloadData()
    //            } else {
    //                self.showAlert(title: "Error", message: error as! String, buttonTitle: "OK")
    //            }
    //        })
//
//    LocalClinicianService.updateLocalClinician(clinician: clinician, completion: { (rs, error) in
//    if((error) != nil) {
//    self.errorMessage(error.debugDescription)
//    return
//    }
//    self.clinicians[row] = clinician
//    self.clinicianTableView.reloadData()
//    self.selectListRow(self.clinicianTableView,
//    IndexPath(row: row, section: 0))
//
//    self.notiMessage("Saved!")
//    })
//    
//    LocalClinicianService.createLocalClinician(clinician: clinician, completion: { (id, error) in
//    if((error) != nil) {
//    self.errorMessage(error.debugDescription)
//    return
//    }
//    
//    if(id != nil) {
//    self.clinicians[row] = clinician
//    self.clinicians[row].objectID = id
//    self.clinicianTableView.reloadData()
//    self.selectListRow(self.clinicianTableView,
//    IndexPath(row: row, section: 0))
//    
//    self.notiMessage("Created!")
//    }
//    })
}
