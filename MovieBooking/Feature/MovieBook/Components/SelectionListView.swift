//
//  SelectionListView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import SwiftUI

struct SelectionListView<Item: Identifiable>: View where Item.ID: Equatable {
  let title: String
  let items: [Item]
  let selectedItem: Item?
  let onSelect: (Item) -> Void
  let placeholder: String?
  let displayText: (Item) -> String

  init(
    title: String,
    items: [Item],
    selectedItem: Item?,
    onSelect: @escaping (Item) -> Void,
    placeholder: String? = nil,
    displayText: @escaping (Item) -> String,
  ) {
    self.title = title
    self.items = items
    self.selectedItem = selectedItem
    self.onSelect = onSelect
    self.displayText = displayText
    self.placeholder = placeholder
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.system(size: 16, weight: .semibold))

      selectionMenu
    }
  }

  private var selectionMenu: some View {
    Menu {
      ForEach(items) { item in
        Button {
          onSelect(item)
        } label: {
          HStack {
            Text(displayText(item))
            if selectedItem?.id == item.id {
              Spacer()
              Image(systemName: "checkmark")
                .foregroundColor(.basicPurple)
            }
          }
        }
      }
    } label: {
      HStack {
        if let selected = selectedItem {
          Text(displayText(selected))
            .foregroundColor(.primary)
            .font(.system(size: 16))
        } else {
          Text(placeholder ?? "선택해주세요")
            .foregroundColor(.secondary)
            .font(.system(size: 16))
        }

        Spacer()

        Image(systemName: "chevron.down")
          .font(.system(size: 14))
          .foregroundColor(.secondary)
      }
      .padding(14)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 14))
      .overlay(
        RoundedRectangle(cornerRadius: 14)
          .stroke(Color.gray.opacity(0.2), lineWidth: 1)
      )
    }
  }
}

// MARK: - Preview Support
#Preview {
  SelectionListViewPreview()
}

private struct PreviewItem: Identifiable, Hashable {
  let id: Int
  let name: String
}

private struct SelectionListViewPreview: View {
  @State var selectedItem: PreviewItem? = nil
  
  let items = [
    PreviewItem(id: 1, name: "CGV 강남"),
    PreviewItem(id: 2, name: "메가박스 코엑스"),
    PreviewItem(id: 3, name: "롯데시네마 월드타워"),
    PreviewItem(id: 4, name: "CGV 용산")
  ]

  var body: some View {
    VStack(spacing: 20) {
      // 정상 상태
      SelectionListView(
        title: "극장",
        items: items,
        selectedItem: selectedItem,
        onSelect: { selectedItem = $0 },
        displayText: { $0.name }
      )
    }
    .padding()
  }
}
