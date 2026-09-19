//
//  AppColors.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 05/09/26.
//
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)

        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255

        self.init(
            red: red,
            green: green,
            blue: blue
        )
    }

    static let appPrimary = Color(hex: "#0D1B3A")
    static let appSecondary = Color(hex: "#415A77")

    static let appBackground = Color(hex: "#F8FAFC")
    static let appCardBackground = Color(hex: "#FFFFFF")

    static let appSuccess = Color(hex: "#16C784")
    static let appError = Color(hex: "#EF4444")
    static let appWarning = Color(hex: "#FF9F1C")

    static let appTextPrimary = Color(hex: "#0F172A")
    static let appTextSecondary = Color(hex: "#64748B")
}
