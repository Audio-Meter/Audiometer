//
//  UIDocumentPickerController+RxUI.swift
//  Audiometer
//
//  Created by Bogachov on 21.06.2018.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt
import MobileCoreServices

class RxDocumentPickerController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
    let texts = PublishSubject<String>()
    let images = PublishSubject<UIImage>()
    let files = PublishSubject<String?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance(whenContainedInInstancesOf: [UIDocumentBrowserViewController.self]).tintColor = nil
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        switch url.pathExtension.lowercased() {
        case "jpg":
            do {
                let imageData = try Data(contentsOf: url)
                let image = UIImage(data: imageData)!
                files.onNext(String.base64StringForJPGApi(path: url.path))
                images.onNext(image)
                texts.onNext("")
            } catch {
                print("Error loading image : \(error)")
            }
            break
        case "pdf":
            files.onNext(String.base64StringForPDFApi(path: url.path))
            texts.onNext(url.lastPathComponent)
            break
        case "png":
            do {
                let imageData = try Data(contentsOf: url)
                images.onNext(UIImage(data: imageData)!)
                files.onNext(String.base64StringForPNGApi(path: url.path))
                texts.onNext("")
            } catch {
                print("Error loading image : \(error)")
            }
            break
        default:
            print("Error parse document")
        }
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        images.onNext(image)
        picker.dismiss(animated: true, completion: nil)
    }
}



extension Navigator {
    func takeDocument(picker: RxImagePickerController) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        picker.allowsEditing = false
        picker.delegate = picker
        picker.sourceType = UIImagePickerController.SourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        self.present(picker)
    }
    func showDocumentPicker(picker: RxDocumentPickerController) {
        picker.delegate = picker
        
//        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker)
    }
}

func ||><O: ObservableConvertibleType>(taps: O, picker: RxDocumentPickerController) -> Observable<RxDocumentPickerController> where O.E == Void {
    return taps.asObservable().mapTo(picker)
}
