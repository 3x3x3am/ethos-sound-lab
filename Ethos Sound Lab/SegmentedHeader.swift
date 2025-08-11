import SwiftUI

/// Simple segmented header for RecordView. Expand as needed.
enum SegmentedHeaderSelection {
    case record
}

struct SegmentedHeader: View {
    var selected: SegmentedHeaderSelection

    var body: some View {
        Text(selected == .record ? "Record" : "")
            .font(.headline)
            .padding()
    }
}
