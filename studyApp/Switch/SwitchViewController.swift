import UIKit

class SwitchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var isZoom = false
    var isBgOn: UIImage?
    var isBgOff: UIImage?
    
    var inputBtn = 0
    var inputSwitch = 0
    
    // pickerView 변수 추가
    let MAX_ARRAY_NUM = 8
    let PICKER_VIEW_COLUM = 1
    let PICKERVIEW_HEIGHT : CGFloat = 66
    
    var imageArray1 = [UIImage?]()
    var imageArray2 = [UIImage?]()
    
    var gromitArray = ["gromit1.jpg", "gromit2.jpg", "gromit3.jpg", "gromit4.jpg", "gromit5.jpg", "gromit6.jpg", "gromit7.jpg", "gromit8.jpg", ]
    var feathersArray = ["feathers1.jpg", "feathers2.jpg", "feathers3.jpg", "feathers4.jpg", "feathers5.jpg", "feathers6.jpg", "feathers7.jpg", "feathers8.jpg", ]
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var isAdd: UIButton!
    @IBOutlet weak var isOff: UISwitch!
    @IBOutlet weak var countBtn: UILabel!
    @IBOutlet weak var countSwitch: UILabel!
    
    @IBOutlet weak var imgPicker1: UIPickerView!
    @IBOutlet weak var imgPicker2: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<MAX_ARRAY_NUM {
            let image1 = UIImage(named: gromitArray[i])
            let image2 = UIImage(named: feathersArray[i])
            
            imageArray1.append(image1)
            imageArray2.append(image2)
        }
        
        isBgOn = UIImage(named: "imageArray1[0]")
        isBgOff = UIImage(named: "imageArray2[0]")
        
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
        if sender.isOn {
            // 스위치가 on이면 gromit picker에서 선택된 행의 이미지를 가져옴
            let selectedRow = imgPicker1.selectedRow(inComponent: 0)
            imgView.image = imageArray1[selectedRow]
            self.view.backgroundColor = UIColor.white
        } else {
            // 스위치가 off이면 feathers picker에서 선택된 행의 이미지를 가져옴
            let selectedRow = imgPicker2.selectedRow(inComponent: 0)
            imgView.image = imageArray2[selectedRow]
            self.view.backgroundColor = UIColor.black
        }
        
        inputSwitch += 1
        updateCountLabels()
    }
    
    // 피커뷰 개수 (컴포넌트 수는 동일하게 유지)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUM
    }

    // 피커뷰의 각 행 높이 설정
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return PICKERVIEW_HEIGHT
    }

    // 피커뷰 행의 개수 설정
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == imgPicker1 {
            return imageArray1.count
        } else {
            return imageArray2.count
        }
    }

    // 피커뷰의 각 행에 표시할 뷰 설정
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let image: UIImage?
        if pickerView == imgPicker1 {
            image = imageArray1[row]
        } else {
            image = imageArray2[row]
        }
        
        let pickerImageView = UIImageView(image: image)
        pickerImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return pickerImageView
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 스위치 상태에 따라, 사용자가 선택한 피커뷰의 이미지를 imgView에 업데이트
        if pickerView == imgPicker1 && isOff.isOn {
            // 스위치가 on일 때, gromit picker 선택
            imgView.image = imageArray1[row]
        } else if pickerView == imgPicker2 && !isOff.isOn {
            // 스위치가 off일 때, feathers picker 선택
            imgView.image = imageArray2[row]
        }
    }
}


