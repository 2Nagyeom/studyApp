//
//  ViewController.swift
//  TodoListApp
//
//  Created by NaGyeom Lee on 3/4/25.
//

import UIKit

class ViewController: UIViewController {
    
    // ViewModel 만들기
    let todoListViewModel = TodoViewModel()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var isTodayButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // 키보드 감지
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 데이터 불러오기
        todoListViewModel.loadTasks()
    }
    
    // 투데이 버튼 클릭시 작업
    @IBAction func isTodayButtonTapped(_ sender: Any) {
        isTodayButton.isSelected = !isTodayButton.isSelected
    }
    
    // add 버튼 클릭시 작업
    @IBAction func isAddButtonTapped(_ sender: Any) {
        guard let detail = inputTextField.text, detail.isEmpty == false else { return }
        let todo = TodoManager.shared.createTodo(detail: detail, isToday: isTodayButton.isSelected)
        todoListViewModel.addTodo(todo)
        collectionView.reloadData()
        inputTextField.text = ""
        isTodayButton.isSelected = false
    }
    
    // BG 클릭시 키보드 내려가게 하기
    
    @IBAction func tabBG(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
    
}

// 키보드 높이에 따른 인풋뷰 변경
extension ViewController {
    @objc private func adjustInputView(noti : Notification) {
        guard let userInfo = noti.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let keyboardHeight = keyboardFrame.height
        let safeAreaBottom = view.safeAreaInsets.bottom
        // 음수값이 발생하지 않도록 0 이상의 값만 사용
        let adjustmentHeight = max(keyboardHeight - safeAreaBottom, 0)
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
        
        print("---> Keyboard End Frame: \(keyboardFrame)")
    }
}

extension ViewController : UICollectionViewDataSource {
    // 섹션이 몇개인지
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return todoListViewModel.numOfSection
    }
    
    // 섹션 별로 아이템 몇개
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return todoListViewModel.todayTodos.count
        } else {
            return todoListViewModel.upcompingTodos.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoListCell", for: indexPath) as? ToDoListCell else { return UICollectionViewCell()}
        // 커스텀 셀
        var todo : Todo
        
        if indexPath.section == 0 {
            todo = todoListViewModel.todayTodos[indexPath.item]
        } else {
            todo = todoListViewModel.upcompingTodos[indexPath.item]
        }
        cell.updateUI(todo: todo)
        
        cell.donButtonHandler = { isDone in
            todo.isDone = isDone
            self.todoListViewModel.updateTodo(todo)
            self.collectionView.reloadData()
        }
        
        cell.deleteButtonHandler = {
            self.todoListViewModel.deleteTodo(todo)
            self.collectionView.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodoListHeaderView", for: indexPath) as? TodoListHeaderView else {
                return UICollectionReusableView()
            }
            
            guard let section = TodoViewModel.Section(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }
            
            header.sectionLabel.text = section.title
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 홈 실행시 홈탭이 먼저 나오게
        self.selectedIndex = 1
    }
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout, sizeForItemAt indexPath : IndexPath) -> CGSize {
        // 사이즈 계산하기
        let width : CGFloat = collectionView.bounds.width
        let height : CGFloat = 50
        return CGSize(width: width, height: height)
    }
}

class ToDoListCell : UICollectionViewCell {
  
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var strokeView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
//    @IBOutlet weak var strokeViewWidth: NSLayoutConstraint!
    
    // 클로저 Todo 객체를 업데이트 할건지 안할건지 해주는 로직
    var donButtonHandler: ((Bool) -> Void)?
    var deleteButtonHandler: (() -> Void)?
    
    // 줄 그음의 길이가 라벨의 길이만큼
//    private func showStrokeView(_ show : Bool) {
//        if show {
//            strokeViewWidth.constant = descriptionLabel.bounds.width
//        } else {
//            strokeViewWidth.constant = 0
//        }
//    }
    
    // 초기화 로직
    func reset() {
        cancelButton.isHidden = true
        descriptionLabel.alpha = 1
//        showStrokeView(false)
    }
    
    // 체크 버튼 처리
    @IBAction func checkButtonTapped(_ sender: Any) {
        checkButton.isSelected = !checkButton.isSelected
        let isDone = checkButton.isSelected
//        showStrokeView(isDone)
        descriptionLabel.alpha = isDone ? 0.2 : 1
        cancelButton.isHidden = !isDone
        donButtonHandler?(isDone)
    }
    
    // 삭제 버튼 처리
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deleteButtonHandler?()
    }
    
    
    func updateUI(todo : Todo) {
        // 셀 업데이트 하기
        checkButton.isSelected = todo.isDone
        descriptionLabel.text = todo.detail
        descriptionLabel.alpha = todo.isDone ? 0.2 : 1
        cancelButton.isHidden = todo.isDone == false
//        showStrokeView(todo.isDone)
    }
    
}

class TodoListHeaderView : UICollectionReusableView {

    @IBOutlet weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

