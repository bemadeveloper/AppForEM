//
//  TodoListInteractorOutput.swift
//  AppForEM
//
//  Created by Bema on 6/2/25.
//

import Foundation

protocol TodoListInteractorOutput: AnyObject {
    func didFetchTodos(_ todos: [Todo])
    
    func didFailWithError(_ error: Error)
    
}
