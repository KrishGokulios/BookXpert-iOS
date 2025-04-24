//
//  HomeListTableCell.swift
//  BookXpertProject
//
//  Created by CredoUser on 23/04/25.
//

import UIKit

class HomeListTableCell: UITableViewCell {
    class var identifier: String{return String(describing: self)}
    class var nibName: UINib{ return UINib(nibName: identifier, bundle: nil)}

    @IBOutlet weak var cellLblOL: UILabel!
    @IBOutlet weak var cellImgOL: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func homeListCellConfig(configData: HomeListDataModel){
        self.cellLblOL.text = configData.description
        if let cellImg = UIImage(named: configData.imageName){
            self.cellImgOL.image = cellImg
        }
    }
    
    func mobileModelListCellConfig(data: MobileModelListModel){
        self.cellLblOL.text = data.name
    }
    
}
