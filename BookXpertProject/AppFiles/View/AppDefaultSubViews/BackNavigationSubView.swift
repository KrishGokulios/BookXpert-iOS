//
//  BackNavigationSubView.swift
//  BookXpertProject
//
//  Created by CredoUser on 23/04/25.
//

import UIKit

protocol BackNavigationSubViewDelegate{
    func backIconPressed(isPressed:Bool)
}

class BackNavigationSubView: UIView {
    private static let nib_Name = "BackNavigationSubView"
    
    @IBOutlet weak var mainViewOL: UIView!
    @IBOutlet weak var backActionViewOL: UIControl!
    @IBOutlet weak var backImgViewOL: UIImageView!
    @IBOutlet weak var titleLblOL: UILabel!
    
    var delegate:BackNavigationSubViewDelegate?
    
    override func awakeFromNib() {
        initWithNib()
    }
    
    func initWithNib() {
        Bundle.main.loadNibNamed(BackNavigationSubView.nib_Name, owner: self, options: nil)
        mainViewOL.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainViewOL)
        setupLayout()
        if let backImg = UIImage(systemName: "arrow.left"){
            self.backImgViewOL.image = backImg
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                mainViewOL.topAnchor.constraint(equalTo: topAnchor),
                mainViewOL.leadingAnchor.constraint(equalTo: leadingAnchor),
                mainViewOL.bottomAnchor.constraint(equalTo: bottomAnchor),
                mainViewOL.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        )
    }
    
    @IBAction func didTapControlView(_ sender: UIControl) {
        if let delegate = self.delegate{
            delegate.backIconPressed(isPressed: true)
        }
    }
    
    func titleCommonUISetup(titleTxt:String){
        self.titleLblOL.text = titleTxt
        if let backImg = UIImage(systemName: "arrow.left"){
            self.backImgViewOL.image = backImg
//            self.backImgViewOL.tintColor = ColorHelper.getInstance().getBlackColor()
        }
    }

}
