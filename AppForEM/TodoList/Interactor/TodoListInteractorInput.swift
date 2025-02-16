//
//  TodoListInteractorInput.swift
//  AppForEM
//
//  Created by Bema on 6/2/25.
//

import Foundation

protocol TodoListInteractorInput {
    func fetchTodos()
    func update(taskId: Int64, newDescription: String, newData: Data, newTodoTask: String)
    
    func deleteAllTodos()
}
