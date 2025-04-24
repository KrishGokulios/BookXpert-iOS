//
//  AppCoreDataClass.swift
//  BookXpertProject

import UIKit
import CoreData
import FirebaseAuth

typealias UserInfoUpdate_RemoveResponse = (_ success: Bool, _ message:String, _ error: NSError?) -> Void
typealias MobileModelUpdate_DeleteResponse = (_ success: Bool, _ message:String, _ error: NSError?) -> Void

class AppCoreDataClass {
    
    func updateUserInfoToCoreData(user:User, completion: @escaping UserInfoUpdate_RemoveResponse){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let userInfo = UserSignInInfo(context: context)
        userInfo.userId = user.uid
        userInfo.name = user.displayName
        userInfo.email = user.email
        userInfo.photoUrl = user.photoURL?.absoluteString
        do {
            try context.save()
            print("Saved user to Core Data")
            completion(true,"Saved Successfully", nil)
        } catch {
            print("Failed to save user: \(error)")
            completion(true,"Failed", error as? NSError)
        }
    }
    
    func removeUserInfoFromCoreData(completion: @escaping UserInfoUpdate_RemoveResponse) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserSignInInfo> = UserSignInInfo.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
            print("User info removed from Core Data")
            completion(true,"Remove Successfully", nil)
        } catch {
            print("Failed to delete user info: \(error)")
            completion(false,"Remove Failed", error as? NSError)
        }
    }
    
    func saveMobileModelsToCoreData(_ models: [MobileModelListModel], completion: @escaping MobileModelUpdate_DeleteResponse) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }

        for model in models {
            let entity = MobileModelList(context: context)
            
            entity.id = model.id
            entity.name = model.name
            entity.dataColor = model.data?.dataColor
            entity.dataCapacity = model.data?.dataCapacity
            entity.capacityGB = Int64(model.data?.capacityGB ?? 0)
            entity.dataPrice = model.data?.dataPrice ?? 0
            entity.dataGeneration = model.data?.dataGeneration
            entity.year = Int64(model.data?.year ?? 0)
            entity.cpuModel = model.data?.cpuModel
            entity.hardDiskSize = model.data?.hardDiskSize
            entity.strapColour = model.data?.strapColour
            entity.caseSize = model.data?.caseSize
            entity.color = model.data?.color
            entity.descriptionData = model.data?.description ?? ""
            entity.capacity = model.data?.capacity
            entity.screenSize = model.data?.screenSize ?? 0
            entity.generation = model.data?.generation
            entity.price = model.data?.price
        }

        do {
            try context.save()
            completion(true,"Saved Successfully", nil)
        } catch {
            print("Failed to save to Core Data:", error.localizedDescription)
            completion(false,"Update Failed", error as? NSError)
        }
    }
    
    func fetchMobileModels() -> [MobileModelList] {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return [] }

        let request: NSFetchRequest<MobileModelList> = MobileModelList.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch:", error.localizedDescription)
            return []
        }
    }
    
    func updateMobileModelData(_ model: MobileModelList, with newData: MobileModelList, completion: @escaping MobileModelUpdate_DeleteResponse) {
        model.id = newData.id
        model.name = newData.name
        model.dataColor = newData.dataColor
        model.dataCapacity = newData.dataCapacity
        model.capacityGB = newData.capacityGB
        model.dataPrice = newData.dataPrice
        model.dataGeneration = newData.dataGeneration
        model.year = newData.year
        model.cpuModel = newData.cpuModel
        model.hardDiskSize = newData.hardDiskSize
        model.strapColour = newData.strapColour
        model.caseSize = newData.caseSize
        model.color = newData.color
        model.descriptionData = newData.descriptionData
        model.capacity = newData.capacity
        model.screenSize = newData.screenSize
        model.generation = newData.generation
        model.price = newData.price
        
        do {
            try model.managedObjectContext?.save()
            completion(true,"Updated Successfully", nil)
        } catch {
            print("Failed to update:", error.localizedDescription)
            completion(false,"Update Failed", error as? NSError)
        }
    }

    
    func deleteMobileModel(_ model: MobileModelList, completion: @escaping MobileModelUpdate_DeleteResponse) {
        guard let context = model.managedObjectContext else { return }
        context.delete(model)

        do {
            try context.save()
            completion(true,"Deleted Successfully", nil)
        } catch {
            print("Failed to delete:", error.localizedDescription)
            completion(false,"Update Failed", error as? NSError)
        }
    }
    
}
