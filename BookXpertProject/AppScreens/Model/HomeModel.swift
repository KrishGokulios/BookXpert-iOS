//
//  HomeModel.swift
//  BookXpertProject
//
//  Created by CredoUser on 23/04/25.
//

class HomeListDataModel {
    var description = ""
    var imageName = ""
    var listCode: HomeListCode = .pdfView
    
    init(description: String, imageName: String, listCode: HomeListCode) {
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
class a{
    var modifyMobileModelData:MobileModelList?
    
    func uiSetup(){
        var mobileListData = [MobileModelEditModel(title: "Name", description: modifyMobileModelData?.name ?? "", code: .name),
                              MobileModelEditModel(title: "CapacityGB", description: modifyMobileModelData?.dataCapacity ?? "", code: .capacityGB),
                              MobileModelEditModel(title: "Price", description: modifyMobileModelData?.price ?? "", code: .capacityGB),
                              MobileModelEditModel(title: "Generation", description: modifyMobileModelData?.generation ?? "", code: .generation),
                              MobileModelEditModel(title: "Capacity", description: modifyMobileModelData?.capacity ?? "", code: .capacity),
                              MobileModelEditModel(title: "DescriptionData", description: modifyMobileModelData?.descriptionData ?? "", code: .descriptionData),
                              MobileModelEditModel(title: "DataColor", description: modifyMobileModelData?.dataColor ?? "", code: .dataColor),
                              MobileModelEditModel(title: "DataCapacity", description: modifyMobileModelData?.dataCapacity ?? "", code: .dataCapacity),
                              MobileModelEditModel(title: "DataPrice", description: "\(modifyMobileModelData?.dataPrice ?? 0)", code: .dataPrice),
                              MobileModelEditModel(title: "DataGeneration", description: modifyMobileModelData?.dataGeneration ?? "", code: .dataGeneration),
                              MobileModelEditModel(title: "Year", description: "\(modifyMobileModelData?.year ?? 0)", code: .year),
                              MobileModelEditModel(title: "CPU Model", description: modifyMobileModelData?.cpuModel ?? "", code: .cpuModel),
                              MobileModelEditModel(title: "Hard Disk Size", description: modifyMobileModelData?.hardDiskSize ?? "", code: .hardDiskSize),
                              MobileModelEditModel(title: "Strap Colour", description: modifyMobileModelData?.strapColour ?? "", code: .strapColour),
                              MobileModelEditModel(title: "Case Size", description: modifyMobileModelData?.caseSize ?? "", code: .caseSize),
                              MobileModelEditModel(title: "Color", description: modifyMobileModelData?.color ?? "", code: .color),
                              MobileModelEditModel(title: "Screen Size", description: "\(modifyMobileModelData?.screenSize ?? 0)", code: .screenSize),
                              
                              
                            ]
        
        
        
        
    }
}
    



//enum EditMobileDetailCode:String{
//    case name,capacityGB, price   
//}
//
///*
// dataColor
// dataCapacity
// capacityGB
// dataPrice
// dataGeneration
// year
// cpuModel
// hardDiskSize
// strapColour
// caseSize
// color
// descriptionData
// capacity
// screenSize
// generation
// price
//
//
//*/

/*
 
 
 
 name
 dataColor
 dataCapacity
 capacityGB
 dataPrice
 dataGeneration
 year
 cpuModel
 hardDiskSize
 strapColour
 caseSize
 color
 descriptionData
 capacity
 screenSize
 generation
 price
 
 
 */
