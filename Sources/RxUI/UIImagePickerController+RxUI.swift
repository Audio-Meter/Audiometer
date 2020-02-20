//
//  UIImagePickerController+RxUI.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/20/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt

class RxImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let images = PublishSubject<UIImage>()
    let files = PublishSubject<String>()

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        images.onNext(image)

        let jpeg = UIImageJPEGRepresentation(image, 1)
        let f = jpeg!.base64EncodedString()
        files.onNext(f)

        picker.dismiss(animated: true, completion: nil)
    }
}

extension Navigator {
    func takePhoto(picker: RxImagePickerController) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
//        picker.allowsEditing = false
        picker.delegate = picker
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        picker.cameraCaptureMode = .photo
//        picker.modalPresentationStyle = .fullScreen
        present(picker)
    }
}

func ||><O: ObservableConvertibleType>(taps: O, picker: RxImagePickerController) -> Observable<RxImagePickerController> where O.E == Void {
    return taps.asObservable().mapTo(picker)
}


