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
    var imageSupport: Bool
    
    @State private var fileDropActive: Bool = false
    @State private var selectedImage: Image?
    
    var hotkeys: [HotkeyCombination] {
        [
            HotkeyCombination(keyBase: [.command], key: .kVK_ANSI_V) {
                if let nsImage = Clipboard.shared.getImage() {
                    let image = Image(nsImage: nsImage)
                    updateSelectedImage(image)
                }
                
                if let clipboardText = Clipboard.shared.getText() {
                    prompt = clipboardText
                }
            }
        ]
    }
    
    var imageSupportMissing: some View {
        HStack {
            Text("This model does not support images. Supported models are llava and bakllava.")
                .font(.caption2)
            Spacer()
        }
        .padding(.top)
    }
    
    private func updateSelectedImage(_ image: Image) {
        selectedImage = image
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
                .focusEffectDisabled()
                .background(Color.clear)
                .focused($focused, equals: true)
                .textFieldStyle(.plain)
                .lineLimit(5, reservesSpace: false)
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
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                VortexView(.splash.makeUniqueCopy()) {
                    Circle()
                        .fill(.white)
                        .frame(width: 20, height: 20)
                        .tag("circle")
                }
            }
            .frame(height: 50)
            .background(Color.clear)
            
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
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.thinMaterial)
                    }
                    .transition(.slide)
                    .showIf(!fileDropActive)
                }
                
                imageSupportMissing
                    .showIf(!imageSupport && selectedImage != nil)
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial)
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
    PromptPanelView(onSubmit: {_,_  in}, onLayoutUpdate: {}, imageSupport: false)
}

#endif
