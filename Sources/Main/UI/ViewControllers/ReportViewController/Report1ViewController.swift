//
//  Report1ViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/15/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import MobileCoreServices

class Report1ViewController: BaseViewController {
    @IBOutlet var complaintType: UISegmentedControl!
    @IBOutlet var complaints: UITableView!
    @IBOutlet var recommendationCodes: UITableView!
    @IBOutlet var recommendationText: UITextView!
    @IBOutlet var nextPage: UIBarButtonItem!
    @IBOutlet var takePhoto: UIButton!
//    @IBOutlet var referral: UIImageView!
    @IBOutlet weak var rptfiles: UIStackView!
    @IBOutlet weak var rptfileScroll: UIScrollView!
    
    var complaintsProvider: CodeTableProvider!
    var recommendationsProvider: CodeTableProvider!

    let photoPicker = RxImagePickerController()
    let documentPicker = RxDocumentPickerController(documentTypes: [String(kUTTypePDF), String(kUTTypePNG), String(kUTTypeJPEG)], in: .import)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // we will set the auto-layout constraints
        rptfileScroll.translatesAutoresizingMaskIntoConstraints = false
        rptfiles.translatesAutoresizingMaskIntoConstraints = false
        
        rptfiles.leadingAnchor.constraint(equalTo: rptfileScroll.leadingAnchor, constant: 0.0).isActive = true
        rptfiles.topAnchor.constraint(equalTo: rptfileScroll.topAnchor, constant: 0.0).isActive = true
        rptfiles.trailingAnchor.constraint(equalTo: rptfileScroll.trailingAnchor, constant: 0.0).isActive = true
        rptfiles.bottomAnchor.constraint(equalTo: rptfileScroll.bottomAnchor, constant: 0.0).isActive = true
    }
    
    func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage? {
        
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension Report1ViewController: Bindable {
    func bind(model: Report1Page) {
        nextPage.rx.tap ||> model.store ||> model.report ||> disposeBag
        let nextPages = nextPage.rx.tap ||> model.nextPage
        nextPages ||> navigator.push ||> disposeBag
        nextPages ||> model.store ||> model.report ||> disposeBag

        complaintType.rx.value <||> model.complaintType ||> disposeBag
        complaintsProvider = CodeTableProvider(table: complaints, cells: model.complaintRows, report: model.report.value)
        complaintsProvider ||> disposeBag

        recommendationsProvider = CodeTableProvider(table: recommendationCodes, cells: model.recommendationRows, report: model.report.value)
        recommendationsProvider ||> disposeBag
        recommendationText.rx.value <||> model.recommendationText ||> disposeBag
        
//        documentTitle.rx.observe(String.self, "text")
//            .subscribe(onNext: { [weak self] text in
//                if let isHiden = text?.isEmpty {
//                    self?.takePhoto.imageView?.isHidden = !isHiden
//                    self?.referral.isHidden = !isHiden
//                }
//            })
//            .disposed(by: disposeBag)

        takePhoto.rx.tap ||> photoPicker ||> navigator.takePhoto ||> disposeBag

        photoPicker.files.subscribe { content in
            model.report.value.rptfiles.append(content.element ?? "")
//            model.files.value.append(content.element ?? "")
        } ||> disposeBag

        photoPicker.images.subscribe { image in
            if image.element != nil {
                let img = self.resizeImage(image: image.element!, newHeight: 200)
                var view = UIImageView(image: img)
                view.sizeToFit()
                view.contentMode = .scaleAspectFit
                view.translatesAutoresizingMaskIntoConstraints = false

                // set image scaling as desired
//                view.contentMode = .scaleToFill
                
                self.rptfiles.addArrangedSubview(view)
                
                self.rptfileScroll.contentSize.width = CGFloat(200 * self.rptfiles.subviews.count)
                
//                view.widthAnchor.constraint(equalTo: self.rptfileScroll.widthAnchor, multiplier: 1.0).isActive = true
//                view.heightAnchor.constraint(equalTo: self.rptfileScroll.heightAnchor, multiplier: 1.0).isActive = true

//                self.rptfiles.addSubview(view)
            }
        } ||> disposeBag
        
//        documentPicker.images ||> referral.rx.image ||> disposeBag
//        documentPicker.texts ||> documentTitle.rx.text ||> disposeBag
//        documentPicker.files ||> model.file ||> disposeBag
//        model.referral ||> referral.rx.image ||> disposeBag
//        documentTitle.gestureRecognizers = takePhoto.gestureRecognizers
    }
}

extension Report1Page: PageViewModel {
    func createController(router: Router) -> UIViewController {
        return router.createController(page: self) as Report1ViewController
    }
}
