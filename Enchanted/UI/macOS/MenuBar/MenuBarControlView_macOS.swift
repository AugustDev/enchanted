//
//  MenuBarControlView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

#if os(macOS)
import SwiftUI

struct MenuBarControlView: View {
    var body: some View {
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                HStack {
                    ControlView(icon: "checkmark.circle", title: "Ollama", subtitle: "Online")
                    ControlView(icon: "x.circle", title: "Enchanted", subtitle: "Online")
                }
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func ControlView(icon: String, title: String, subtitle: String? = nil) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.largeTitle)
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(.gray)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.callout)
                    .foregroundStyle(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(Color.grayCustom)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension MenuBarControlView {
    static var icon: Image = {
        let image: NSImage = {
            let ratio = $0.size.height / $0.size.width
            $0.size.height = 18
            $0.size.width = 18 / ratio
            return $0
        }(NSImage(named: "logo-nobg")!)
        
        return Image(nsImage: image)
    }()
}

#Preview {
    MenuBarControlView()
}
#endif
