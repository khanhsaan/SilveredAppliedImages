//
//  ContentView.swift
//  SiveredAppliedImages
//
//  Created by Anthony Tran on 16/11/2025.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var originalUIImage: UIImage?
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 20) {
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("No photo selected")
                    .foregroundStyle(.secondary)
            }
            // "Select Photo" blue button
            PhotosPicker(selection: $selectedItem, matching: .images){
                // $selectedItem: bind the picker's selection to State variable
                // Only show images
                Text("Select Photo")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                .cornerRadius(10)
            }
            // When selectedItem is changed
            // This applies to when the 1st image is picked
                // At first: selectedItem = nil
                // Use presses PhotoPicker button -> selectedItem = nil -> selectedItem = PhotosPickerItem
                // -> .onChange()
            .onChange(of: selectedItem, {
                // Start a new async task
                _, newItem in Task{
                    // Load the selected image as its raw bytes (data)
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       // Convert to UIImage
                       let uiImage = UIImage(data: data){
                        
                        originalUIImage = uiImage
                        
                        // set selectedImage to that UIImage
                        selectedImage = Image(uiImage: uiImage)
                    }
                }
            })
            if originalUIImage != nil {
                Button("Apply Anti-DeepFake Protection"){
                    applyImmnunisation()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .disabled(isProcessing)
            }
        }
        .padding()s
    }
    
    private func applyImmnunisation(){
        guard let original = originalUIImage else {return}
        isProcessing = true
        
        Task{
            if let protected = await addAdversarialPerturbation(to: original){
                selectedImage = Image(uiImage: protected)
                originalUIImage = protected
            }
            isProcessing = false
        }
    }
    
    private func addAdversarialPerturbation(to image: UIImage) async -> UIImage? {
            guard let cgImage = image.cgImage else { return nil }
            
            let width = cgImage.width
            let height = cgImage.height
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bytesPerPixel = 4
            let bytesPerRow = bytesPerPixel * width
            let bitsPerComponent = 8
            
            var pixelData = [UInt8](repeating: 0, count: height * width * bytesPerPixel)
            
            guard let context = CGContext(
                data: &pixelData,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else { return nil }
            
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            
            // Apply subtle adversarial noise (imperceptible to humans, disruptive to AI)
            for i in stride(from: 0, to: pixelData.count, by: bytesPerPixel) {
                let noise = Int8.random(in: -3...3)
                pixelData[i] = UInt8(max(0, min(255, Int(pixelData[i]) + Int(noise))))     // R
                pixelData[i + 1] = UInt8(max(0, min(255, Int(pixelData[i + 1]) + Int(noise)))) // G
                pixelData[i + 2] = UInt8(max(0, min(255, Int(pixelData[i + 2]) + Int(noise)))) // B
            }
            
            guard let newCGImage = context.makeImage() else { return nil }
            return UIImage(cgImage: newCGImage)
        }
    }

#Preview {
    ContentView()
}
