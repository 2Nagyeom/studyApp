//
//  Todo.swift
//  studyApp
//
//  Created by NaGyeom Lee on 3/16/25.
//

import UIKit

struct Todo : Codable, Equatable {
    let id : Int
    var isDone : Bool
    var detail : String
    var isToday : Bool
    
    // 업데이트 로직 추가
    mutating func update(isDone : Bool, detail : String, isToday : Bool) {
        self.isDone = isDone
        self.detail = detail
        self.isToday = isToday
    }
    
    // 동등 조건 추가 --> lhs = left, rhs = right
    static func == (lhs : Self, rhs : Self) -> Bool {
        return lhs.id == rhs.id
    }
}

class TodoManager {
    static let shared = TodoManager()
    static var lastId : Int = 0
    var todos : [Todo] = []
    
    // create 기능
    func createTodo(detail : String, isToday : Bool) -> Todo {
        let nextId = TodoManager.lastId + 1
        TodoManager.lastId = nextId
        return Todo(id : nextId, isDone : false, detail: detail, isToday: isToday)
    }
    // Update 기능
    func updateTodo (_ todo : Todo) {
        guard let index = todos.firstIndex(of: todo) else {return}
        todos[index].update(isDone: todo.isDone, detail: todo.detail, isToday: todo.isToday)
        saveTodo()
    }
    // Delete 기능
    func deleteTodo (_ todo : Todo) {
        // todos = todos.filter { return $0.id != todo.id }
        if let index = todos.firstIndex(of: todo) {
            todos.remove(at: index)
        }
        saveTodo()
    }
    // Add 기능
    func addTodo (_ todo : Todo) {
        todos.append(todo)
        saveTodo()
    }
    
    // 디스크에 저장하는 기능
    func saveTodo () {
        Storage.store(todos, to: .documents, as: "todos.json")
    }
    
    // 디스크에 썼던 내용을 메모리에 적재하는 기능
    func retrieveTodo () {
        todos = Storage.retrive("todos.json", from: .documents, as: [Todo].self ) ?? []
        
        let lastId = todos.last?.id ?? 0
        TodoManager.lastId = lastId
    }
}

class TodoViewModel {
    
    enum Section: Int, CaseIterable {
        case today
        case upcoming
        
        var title: String {
            switch self {
            case .today: return "Today"
            default: return "Upcoming"
            }
        }
    }
    
    private let manager = TodoManager.shared
    
    var todos: [Todo] {
        return manager.todos
    }
    
    var todayTodos: [Todo] {
        return todos.filter { $0.isToday == true }
    }
    
    var upcompingTodos: [Todo] {
        return todos.filter { $0.isToday == false }
    }
    
    var numOfSection: Int {
        return Section.allCases.count
    }
    
    func addTodo(_ todo: Todo) {
        manager.addTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo) {
        manager.deleteTodo(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        manager.updateTodo(todo)
    }
    
    func loadTasks() {
        manager.retrieveTodo()
    }
}


