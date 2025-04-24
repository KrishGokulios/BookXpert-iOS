//
//  PdfDisplayVC.swift
//  BookXpertProject
//
//  Created by CredoUser on 23/04/25.
//

import UIKit
import PDFKit

class PdfDisplayVC: UIViewController {
    
    @IBOutlet weak var backNaviViewOL: BackNavigationSubView!{
        didSet{
            self.backNaviViewOL.delegate = self
        }
    }
    @IBOutlet weak var pdfContainerViewOL: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backNaviViewOL.titleCommonUISetup(titleTxt: "PDF View")
//        self.pdfContainerViewOL.backgroundColor = .white
        let pdfUrl:String = "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf"
        self.setupPDFView(pdfUrl: pdfUrl)
    }
    
    private func setupPDFView(pdfUrl:String) {
        guard let pdfURL = URL(string: pdfUrl) else { return }
        
        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        pdfContainerViewOL.addSubview(pdfView)
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        } else {
            print("Failed to load PDF.")
        }
    }
}

extension PdfDisplayVC: BackNavigationSubViewDelegate{
    func backIconPressed(isPressed:Bool){
        self.navigationController?.popViewController(animated: true)
    }
}
