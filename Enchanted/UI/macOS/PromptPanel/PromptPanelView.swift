//
//  PromptPanelView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 12/02/2024.
//

#if os(macOS)
import SwiftUI
import Vortex

struct PromptPanelView: View {
    @FocusState private var focused: Bool?
    @State var prompt: String = ""
    var onSubmit: @MainActor (_ prompt: String, _ image: Image?) -> ()
    var onLayoutUpdate: () -> ()
    
    @State private var fileDropActive: Bool = false
    @State private var selectedImage: Image?
    
    var hotkeys: [HotkeyCombination] {
        [
            HotkeyCombination(keyBase: [.command], key: .kVK_ANSI_V) {
                guard let nsImage = Clipboard.shared.getImage() else { return }
                let image = Image(nsImage: nsImage)
                updateSelectedImage(image)
            }
        ]
    }
    
    func updateSelectedImage(_ image: Image) {
        withAnimation(.easeOut(duration: 0.1)) {
            selectedImage = image
        }
    }
    
    var dynamicFont: Font {
        if prompt.count <= 30 {
            return .title
        } else if prompt.count <= 100 {
            return .title2
        }
        
        return .body
    }
    
    var inputField: some View {
        HStack(spacing: 15) {
            Image("logo-nobg")
                .resizable()
                .antialiased(true)
                .scaledToFit()
                .frame(width: 20)
                .foregroundColor(.label)
            
            TextField("How can I help today?", text: $prompt, axis: .vertical)
                .font(dynamicFont)
                .minimumScaleFactor(0.4)
                .frame(minHeight: 40, maxHeight: 200)
                .focusEffectDisabled()
                .background(Color.clear)
                .focused($focused, equals: true)
                .textFieldStyle(.plain)
                .onSubmit {
                    Task { @MainActor in
                        if NSApp.currentEvent?.modifierFlags.contains(.shift) == true {
                            prompt += "\n"
                        } else {
                            onSubmit(prompt, selectedImage)
                        }
                    }
                }
            /// TextField bypasses drop area
                .allowsHitTesting(!fileDropActive)
                .layoutPriority(-1)
        }
        .animation(.none)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            //            ZStack(alignment: .top) {
            //                VortexView(.splash.makeUniqueCopy()) {
            //                    Circle()
            //                        .fill(.white)
            //                        .frame(width: 20, height: 20)
            //                        .tag("circle")
            //                }
            //            }
            //            .frame(height: 50)
            //            .background(Color.clear)
            
            VStack(alignment: .leading) {
                inputField
                    .layoutPriority(-1)
                
                DragAndDrop(cornerRadius: 10)
                    .frame(height: 150)
                    .layoutPriority(1)
                    .showIf(fileDropActive)
                
                if let image = selectedImage {
                    HStack {
                        RemovableImage(
                            image: image,
                            onClick: {selectedImage = nil},
                            height: 150
                        )
                        .layoutPriority(1)
                        .transition(.scale)
                        
                        Spacer()
                    }
                    .layoutPriority(1)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.thinMaterial)
                    }
                    .showIf(!fileDropActive)
                }
            }
            .animation(.default)
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
        }
        .frame(minWidth: 500, maxWidth: 500)
        .onAppear {
            prompt = ""
            focused = true
        }
        .onDrop(of: [.image], isTargeted: $fileDropActive, perform: { providers in
            guard let provider = providers.first else { return false }
            
            _ = provider.loadDataRepresentation(for: .image) { data, error in
                if error == nil, let data {
                    if let nsImage = NSImage(data: data) {
                        updateSelectedImage(Image(nsImage: nsImage))
                    }
                }
            }
            
            return true
        })
        .addCustomHotkeys(hotkeys)
        .onChange(of: prompt) { _, _ in
            onLayoutUpdate()
        }
        .onChange(of: fileDropActive) { _, _ in
            onLayoutUpdate()
        }
        .onChange(of: selectedImage) { _, _ in
            onLayoutUpdate()
        }
    }
}

#Preview {
    PromptPanelView(onSubmit: {_,_  in}, onLayoutUpdate: {})
}

#endif
