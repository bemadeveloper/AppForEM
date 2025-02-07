//
//  TodoListPresenterOutput.swift
//  AppForEM
//
//  Created by Bema on 6/2/25.
//

import Foundation

protocol TodoListPresenterOutput: AnyObject {
    func displayTodos(_ todos: [Todo])
    func displayError(_ message: String)
}
