//
//  MobileModelEditTableCell.swift
//  BookXpertProject
//
//  Created by CredoUser on 24/04/25.
//

import UIKit

protocol MobileModelEditTableCellDelegate{
    func didChangeText(code: EditMobileDetailCode,indexPos:Int, text:String)
}

class MobileModelEditTableCell: UITableViewCell {
    class var identifier: String{return String(describing: self)}
    class var nibName: UINib{ return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var nameLblOL: UILabel!
    @IBOutlet weak var enterTxtOL: UITextField!{
        didSet{
            self.enterTxtOL.delegate = self
        }
    }
    
    var delegate:MobileModelEditTableCellDelegate?
    var editFieldCode:EditMobileDetailCode?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func editDetailsCellConfig(allowEdit:Bool, title:String, code:EditMobileDetailCode, txtDisp:String){
        self.editFieldCode = code
        self.enterTxtOL.isUserInteractionEnabled = allowEdit
        self.nameLblOL.text = title
        self.enterTxtOL.text = txtDisp
    }
    
}

extension MobileModelEditTableCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = self.delegate, let code = self.editFieldCode{
            delegate.didChangeText(code: code, indexPos: textField.tag, text: textField.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 🔑 Dismiss the keyboard
        return true
    }
}
