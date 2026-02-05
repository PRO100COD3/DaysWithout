//
//  ScreenHeaderView.swift
//  DaysWithout
//

import SwiftUI

/// Заголовок экрана: опциональная кнопка слева, заголовок по центру, опциональный view справа.
struct ScreenHeaderView<Leading: View, Trailing: View>: View {
    let title: String
    let titleFontSize: CGFloat
    let titleColor: Color
    let horizontalPadding: CGFloat
    let topPadding: CGFloat
    @ViewBuilder let leading: () -> Leading
    @ViewBuilder let trailing: () -> Trailing

    init(
        title: String,
        titleFontSize: CGFloat = Theme.storyHeaderTitleFontSize,
        titleColor: Color = Theme.storyHeaderTitleColor,
        horizontalPadding: CGFloat = Theme.storyHeaderHorizontalPadding,
        topPadding: CGFloat = Theme.storyHeaderTopPadding,
        @ViewBuilder leading: @escaping () -> Leading,
        @ViewBuilder trailing: @escaping () -> Trailing
    ) {
        self.title = title
        self.titleFontSize = titleFontSize
        self.titleColor = titleColor
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.leading = leading
        self.trailing = trailing
    }

    var body: some View {
        HStack {
            leading()
            Spacer()
            Text(title)
                .font(.custom(Theme.headingFontName, size: titleFontSize))
                .fontWeight(.bold)
                .foregroundColor(titleColor)
            Spacer()
            trailing()
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, topPadding)
    }
}

// MARK: - Convenience initializers

extension ScreenHeaderView where Leading == EmptyView, Trailing == EmptyView {
    init(
        title: String,
        titleFontSize: CGFloat = Theme.storyHeaderTitleFontSize,
        titleColor: Color = Theme.storyHeaderTitleColor,
        horizontalPadding: CGFloat = Theme.storyHeaderHorizontalPadding,
        topPadding: CGFloat = Theme.storyHeaderTopPadding
    ) {
        self.title = title
        self.titleFontSize = titleFontSize
        self.titleColor = titleColor
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.leading = { EmptyView() }
        self.trailing = { EmptyView() }
    }
}

extension ScreenHeaderView where Trailing == EmptyView {
    init(
        title: String,
        titleFontSize: CGFloat = Theme.storyHeaderTitleFontSize,
        titleColor: Color = Theme.storyHeaderTitleColor,
        horizontalPadding: CGFloat = Theme.storyHeaderHorizontalPadding,
        topPadding: CGFloat = Theme.storyHeaderTopPadding,
        @ViewBuilder leading: @escaping () -> Leading
    ) {
        self.title = title
        self.titleFontSize = titleFontSize
        self.titleColor = titleColor
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.leading = leading
        self.trailing = { EmptyView() }
    }
}

extension ScreenHeaderView where Leading == EmptyView {
    init(
        title: String,
        titleFontSize: CGFloat = Theme.storyHeaderTitleFontSize,
        titleColor: Color = Theme.storyHeaderTitleColor,
        horizontalPadding: CGFloat = Theme.storyHeaderHorizontalPadding,
        topPadding: CGFloat = Theme.storyHeaderTopPadding,
        @ViewBuilder trailing: @escaping () -> Trailing
    ) {
        self.title = title
        self.titleFontSize = titleFontSize
        self.titleColor = titleColor
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.leading = { EmptyView() }
        self.trailing = trailing
    }
}
