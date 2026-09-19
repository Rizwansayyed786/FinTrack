//
//  HomeRoute.swift
//  FinTrack
//

enum HomeRoute: Hashable {
    /// Every quick action currently lands on the same placeholder screen; the
    /// item is carried so the destination can branch once real screens exist.
    case quickAction(QuickActionItem)
}
