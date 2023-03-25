//
//  TodoListPresenter.swift
//  ToDoList
//
//  Created by Constantin on 18.02.2023.
//

import Foundation
import TaskManagerPackage

/// Протокол для TodoListPresenter.
protocol ITodoListPresenter {
	func present(responce: TodoListModel.Response)
}

/// Presenter для TodoList.
final class TodoListPresenter: ITodoListPresenter {

	private weak var viewController: ITodoListViewController?

	init(viewController: ITodoListViewController) {
		self.viewController = viewController
	}

	/// Предоставить ответ заданий.
	func present(responce: TodoListModel.Response) {
		var sections = [TodoListModel.ViewModel.Section]()
		for section in responce.data {
			let sectionData = TodoListModel.ViewModel.Section(
				title: section.section.title,
				tasks: mapTaskData(task: section.tasks)
			)
			sections.append(sectionData)
		}

		let viewModel = TodoListModel.ViewModel(tasksBySections: sections)
		viewController?.render(viewModel: viewModel)
	}

	private func mapTaskData(task: [Task]) -> [TodoListModel.ViewModel.Task] {
		task.map { mapTaskData(task: $0) }
	}

	private func mapTaskData(task: Task) -> TodoListModel.ViewModel.Task {
		if let task = task as? ImportantTask {
			let importantTask = TodoListModel.ViewModel.ImportantTask(
				name: task.name,
				isDone: task.isCompleted,
				isOverdue: task.deadLine < Date(),
				deadLine: "Deadline: \(task.deadLine.formatted(.iso8601 .month().day().year()))",
				priority: "\(task.taskPriority)"
			)
			return .importantTask(importantTask)
		} else {
			let reularTask = TodoListModel.ViewModel.RegularTask(name: task.name, isDone: task.isCompleted)
			return .regularTask(reularTask)
		}
	}
}

extension ImportantTask.Priority: CustomStringConvertible {

	/// Строковое представление ImportantTask.
	public var description: String {
		switch self {

		case .low:
			return "!"
		case .medium:
			return "!!"
		case .high:
			return "!!!"
		}
	}
}
