//
//  Report2ViewController+signature.swift
//  Audiometer
//
//  Created by Bogachov on 25.06.2018.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//
import EPSignature

extension Report2ViewController: EPSignatureDelegate {
    //TODO: add reactive way
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
        signature.image = signatureImage
        User.current?.updateSignature(image: signatureImage, completion: { (error) in
            //TODO: Handle error
        })
        
    }
    
    func epSignature(_: EPSignatureViewController, didCancel: NSError) {
        
    }
    
    @IBAction func addSignature(_ sender: Any) {
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: false)
        let nav = UINavigationController(rootViewController: signatureVC)
        present(nav, animated: true, completion: nil)
    }
}
