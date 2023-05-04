//
//  StoreExtensions.swift
//  ComposableUIKit
//
//  Created by Loyi Hsu on 2023/5/4.
//

import ComposableArchitecture
import UIKit

public extension Store where State: Equatable {
    /// A helper to allow dequeuing of a `ComposableTableViewCell<State, Action>` from a store.
    ///
    /// An example usage may be like:
    ///
    /// ```swift
    /// let cell = store.makeTableViewCell(
    ///     from: tableView,
    ///     withIdentifier: "\(CounterItemListCell.self)",
    ///     for: indexPath
    /// )
    /// ```
    ///
    func makeTableViewCell(
        from tableView: UITableView,
        withIdentifier identifier: String,
        for indexPath: IndexPath
    ) -> ComposableTableViewCell<State, Action>? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ComposableTableViewCell<State, Action> else { return nil }
        cell.setup(with: self)
        return cell
    }

    /// A helper to allow dequeuing of a `ComposableTableViewCell<State, Action>` from a store.
    ///
    /// An example usage may be like:
    ///
    /// ```swift
    /// let cell = store.makeTableViewCell(
    ///     from: tableView,
    ///     for: indexPath,
    ///     cellType: CounterItemListCell.self
    /// )
    /// ```
    ///
    func makeTableViewCell(
        from tableView: UITableView,
        for indexPath: IndexPath,
        cellType: ComposableTableViewCell<State, Action>.Type
    ) -> ComposableTableViewCell<State, Action>? {
        makeTableViewCell(
            from: tableView,
            withIdentifier: "\(cellType)",
            for: indexPath
        )
    }
}
