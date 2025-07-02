//
//  HomeModel.swift
//  BookXpertProject
//
//  Created by CredoUser on 23/04/25.
//

struct HomeListDataModel {
    let description, imageName:String?
    let listCode: HomeListCode?
    
    init(description: String?, imageName: String?, listCode: HomeListCode?) {
        self.description = description
        self.imageName = imageName
        self.listCode = listCode
    }
}


enum HomeListCode:String{
    case pdfView, gallery, mobileModel, notification
}

struct MobileModelListModel:Codable {
    let id, name:String?
    let data:MobileDataSubModel?
    
    enum CodingKeys:String, CodingKey{
        case id, name, data
    }
}

struct MobileDataSubModel: Codable {
    let dataColor, dataCapacity: String?
    let capacityGB: Int?
    let dataPrice: Double?
    let dataGeneration: String?
    let year: Int?
    let cpuModel, hardDiskSize, strapColour, caseSize: String?
    let color, description, capacity: String?
    let screenSize: Double?
    let generation, price: String?

    enum CodingKeys: String, CodingKey {
        case dataColor = "color"
        case dataCapacity = "capacity"
        case capacityGB = "capacity GB"
        case dataPrice = "price"
        case dataGeneration = "generation"
        case year
        case cpuModel = "CPU model"
        case hardDiskSize = "Hard disk size"
        case strapColour = "Strap Colour"
        case caseSize = "Case Size"
        case color = "Color"
        case description = "Description"
        case capacity = "Capacity"
        case screenSize = "Screen size"
        case generation = "Generation"
        case price = "Price"
    }
}

struct MobileModelEditModel{
    var title:String
    var description:String
    var code:EditMobileDetailCode
    
    init(title: String, description: String, code:EditMobileDetailCode) {
        self.title = title
        self.description = description
        self.code = code
    }
}

enum EditMobileDetailCode:String{
    case name,capacityGB, price, generation, capacity, descriptionData,dataColor, dataCapacity, dataPrice, dataGeneration, year, cpuModel, hardDiskSize, strapColour, caseSize, color, screenSize
}
