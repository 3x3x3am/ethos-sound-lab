import SwiftUI

/// Rounded card container used across views.
public struct Panel<Content: View>: View {
    public var title: String?
    @ViewBuilder public var content: Content

    public init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title { Text(title).font(.caption).opacity(0.7) }
            content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

//   Panel.swift
//  Ethos Sound Lab
//
//  Created by Drew Maldonado on 8/10/25.
//

