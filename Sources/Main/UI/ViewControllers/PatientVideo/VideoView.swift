//
//  VideoView.swift
//  Audiometer
//
//  Created by Arun Jangid on 21/05/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit

class VideoView: UIView {
    
    
    var isToShowHide:Bool = false
    var lastLocation = CGPoint(x: 0, y: 0)
    var isHalf:Bool = false
    
    var isHalfHandler:((Bool) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    @objc func doubleTapped(_ sender:UITapGestureRecognizer){
        if isHalf{
            var x = self.frame.origin.x
            if x > (UIScreen.main.bounds.width - 300){
                x = UIScreen.main.bounds.width - 300
            }
            self.frame = CGRect(x: x, y: 16, width: 300, height: UIScreen.main.bounds.height - 150)
            self.layer.cornerRadius = 0
            isHalf = false
            isHalfHandler?(false)
        }else{
            var x = self.frame.origin.x
            if self.frame.origin.x > (UIScreen.main.bounds.width / 2){
                x =  UIScreen.main.bounds.width - 150
            }else{
                x = 0
            }
            self.frame = CGRect(x: x, y: self.frame.origin.y, width: 150 , height: 150)
            self.layer.cornerRadius = 75
            self.clipsToBounds = true
            isHalf = true
            isHalfHandler?(true)
        }
        self.setNeedsDisplay()
        
    }
    
    
    
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.superview)
        if (lastLocation.y + translation.y) > 69 && (lastLocation.y + translation.y) < (UIScreen.main.bounds.height - 55){
            self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
        }
    }
    
    func setupView(){
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(VideoView.detectPan(_:)))
        self.gestureRecognizers = [panRecognizer]
        panRecognizer.cancelsTouchesInView = false
        
        

        self.backgroundColor = .white
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
        tapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func buttonTaped(_ sender:UIButton) {
//        buttonTapped?()
    }
    
    override func touchesBegan(_ touches: (Set<UITouch>?), with event: UIEvent!) {
        // Promote the touched view
        self.superview?.bringSubviewToFront(self)
        
        // Remember original location
        lastLocation = self.center
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Promote the touched view
        self.superview?.bringSubviewToFront(self)
        if let touch = event?.allTouches?.first{
            _  = touch.location(in: self.superview)
                
            let width = (UIScreen.main.bounds.width / 2)
            let height  = UIScreen.main.bounds.height - 250
            var centerY = self.center.y
            
            if isHalf{
                var x = self.center.x
                if x > UIScreen.main.bounds.width - 75{
                    x = UIScreen.main.bounds.width - 75
                }else if x < 75 {
                    x = 75
                }
                
                if centerY > height{
                    UIView.animate(withDuration: 0.2) {
                        let diff:CGFloat = UIDevice.current.hasNotch == true ? 80 : 110
                        DispatchQueue.main.async {
                            self.center = CGPoint(x: x, y: height + diff)
                        }
                    }
                    return
                }else if centerY < 250{
                    UIView.animate(withDuration: 0.2) {
                        DispatchQueue.main.async {
                            self.center = CGPoint(x: x, y: 75)
                        }
                    }
                    return
                }
                    
            }
                        
            if self.center.y > UIScreen.main.bounds.height/2{
                  centerY = UIScreen.main.bounds.height/2
            }else if self.center.y <= self.frame.height/2{
                   centerY = self.frame.height/2
            }
            
            if self.center.x > width{
                UIView.animate(withDuration: 0.2) {
                    DispatchQueue.main.async {
                        let centerX = self.isHalf == true ? UIScreen.main.bounds.width - 75 : UIScreen.main.bounds.width - 150
                        self.center = CGPoint(x: centerX, y: centerY)
                    }
                }
            }else{
                let centerX:CGFloat = self.isHalf == true ? 75 : 150
                
                
                UIView.animate(withDuration: 0.2) {
                    DispatchQueue.main.async {
                        self.center = CGPoint(x: centerX, y:  centerY)
                    }
                        
                }
            }
        }
    }
}
extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
}
