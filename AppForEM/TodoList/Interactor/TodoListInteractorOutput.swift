//
//  TodoListInteractorOutput.swift
//  AppForEM
//
//  Created by Bema on 6/2/25.
//

import Foundation

protocol TodoListInteractorOutput: AnyObject {
    func didFetchTodos(_ todos: [Notes])
    func didUpdateTaskSuccessfully()
    func didDeleteOneTodo()
    func didCreate()
    func didFailWithError(_ error: Error)
    
}
