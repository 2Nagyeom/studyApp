//
//  CalenderViewController.swift
//  studyApp
//
//  Created by NaGyeom Lee on 3/19/25.
//

import UIKit

class CalenderViewController: UIViewController {

    @IBOutlet weak var curTimer: UILabel!
    @IBOutlet weak var picTimer: UILabel!
    
    // 선택한 날짜를 저장할 변수
    var pickedDate: Date?
    // 현재 시간을 주기적으로 업데이트할 타이머
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 타이머를 이용해 매초 현재 시간을 업데이트
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateCurrentTime),
                                     userInfo: nil,
                                     repeats: true)
        updateCurrentTime() // 초기 업데이트
    }
    
    // DatePicker 액션: 선택한 날짜를 저장하고 레이블 업데이트
    @IBAction func datePicker(_ sender: UIDatePicker) {
        pickedDate = sender.date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분 EEE요일"
        picTimer.text = "픽한시간 : " + formatter.string(from: sender.date)
        
        // 선택 후 즉시 현재 시간과 비교해 배경색 변경
        checkTimeAndUpdateBackground()
    }
    
    // 현재 시간을 업데이트하는 메서드 (타이머가 호출)
    @objc func updateCurrentTime() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분 EEE요일"
        curTimer.text = "현재시간 : " + formatter.string(from: now)
        
        // 업데이트 될 때마다 선택한 시간과 비교
        checkTimeAndUpdateBackground()
    }
    
    // 현재 시간과 선택한 시간이 같은지 비교하여 배경색을 변경하는 메서드
    func checkTimeAndUpdateBackground() {
        // 선택한 시간이 없으면 기본 배경색 유지
        guard let picked = pickedDate else {
            self.view.backgroundColor = UIColor.white
            return
        }
        
        let now = Date()
        let calendar = Calendar.current
        // 분 단위로 비교 (초단위까지 비교하면 거의 매번 달라짐)
        if calendar.compare(now, to: picked, toGranularity: .minute) == .orderedSame {
            // 현재 시간과 선택한 시간이 같은 경우, 배경색 변경
            self.view.backgroundColor = UIColor.green
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

