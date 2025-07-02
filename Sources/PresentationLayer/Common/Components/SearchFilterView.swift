import SwiftUI
import DomainLayer

public struct SearchFilterView: View {
    @Binding var currentSearchMode: SearchMode
    @Binding var sortType: SortType?
    @Binding var orderType: OrderType
    
    let onSearchModeChange: (SearchMode) async -> Void
    
    public init(
        currentSearchMode: Binding<SearchMode>,
        sortType: Binding<SortType?>,
        orderType: Binding<OrderType>,
        onSearchModeChange: @escaping (SearchMode) async -> Void
    ) {
        self._currentSearchMode = currentSearchMode
        self._sortType = sortType
        self._orderType = orderType
        self.onSearchModeChange = onSearchModeChange
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            // 검색 모드 선택
            Picker("검색 모드", selection: $currentSearchMode) {
                ForEach(SearchMode.allCases, id: \.self) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: currentSearchMode) { _, newValue in
                Task {
                    await onSearchModeChange(newValue)
                }
            }
            
            // API 검색일 때만 정렬 옵션 표시
            if currentSearchMode == .api {
                HStack {
                    // 정렬 기준
                    Menu {
                        Button("정렬 없음") {
                            sortType = nil
                        }
                        
                        ForEach(SortType.allCases, id: \.self) { sort in
                            Button(sort.displayName) {
                                sortType = sort
                            }
                        }
                    } label: {
                        HStack {
                            Text("정렬: \(sortType?.displayName ?? "없음")")
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // 정렬 순서
                    if sortType != nil {
                        Menu {
                            ForEach(OrderType.allCases, id: \.self) { order in
                                Button(order.displayName) {
                                    orderType = order
                                }
                            }
                        } label: {
                            HStack {
                                Text(orderType.displayName)
                                Image(systemName: "chevron.down")
                            }
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @State var searchMode: SearchMode = .api
    @Previewable @State var sortType: SortType? = nil
    @Previewable @State var orderType: OrderType = .desc
    
    return SearchFilterView(
        currentSearchMode: $searchMode,
        sortType: $sortType,
        orderType: $orderType,
        onSearchModeChange: { _ in }
    )
} 
