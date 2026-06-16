
import SwiftUI

struct CardContainer<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct NumberedPin: View {
    let number: Int

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 30, height: 30)
                .shadow(radius: 2)
            Text("\(number)")
                .font(.footnote.bold())
                .foregroundStyle(.white)
        }
        .overlay(
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 10))
                .foregroundStyle(Color.accentColor)
                .offset(y: 18)
        )
    }
}

struct TipCardView: View {
    let tip: Tip

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: tip.icon)
                .font(.title3)
                .foregroundStyle(Color.accentColor)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(tip.category.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(tip.text)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}
