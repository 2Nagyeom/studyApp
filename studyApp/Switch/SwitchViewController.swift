//
//  PlayViewController.swift
//  studyApp
//
//  Created by NaGyeom Lee on 3/18/25.
//

import UIKit

class SwitchViewController: UIViewController {
    var isZoom = false
    var isBgOn: UIImage?
    var isBgOff: UIImage?
    
    var inputBtn = 0
    var inputSwitch = 0
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var isAdd: UIButton!
    @IBOutlet weak var isOff: UISwitch!
    @IBOutlet weak var countBtn: UILabel!
    @IBOutlet weak var countSwitch: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isBgOn = UIImage(named: "gromitBg2.jpg")
        isBgOff = UIImage(named: "gromitnotBg2.jpg")
        
        imgView.image = isBgOn
        updateCountLabels()
    }
    
    private func updateCountLabels() {
        countBtn.text = "\(inputBtn)"
        countSwitch.text = "\(inputSwitch)"
    }
    
    @IBAction func isAddImage(_ sender: UIButton) {
        // 확대/축소에 따라 적용할 transform과 버튼 타이틀을 결정
        let newTransform: CGAffineTransform = isZoom ? .identity : CGAffineTransform(scaleX: 2.0, y: 2.0)
        let newTitle = isZoom ? "확대" : "축소"
        
        UIView.animate(withDuration: 0.3) {
            self.imgView.transform = newTransform
//            self.imgView.center = self.view.center
        }
        isAdd.setTitle(newTitle, for: .normal)
        isZoom.toggle()
        
        inputBtn += 1
        updateCountLabels()
    }
    
    @IBAction func isOffImage(_ sender: UISwitch) {
        // 삼항 연산자로 이미지 설정을 간결하게 처리
        imgView.image = sender.isOn ? isBgOn : isBgOff
        inputSwitch += 1
        updateCountLabels()
    }
}

