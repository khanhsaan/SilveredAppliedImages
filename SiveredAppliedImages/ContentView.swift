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
                        // set selectedImage to that UIImage
                        selectedImage = Image(uiImage: uiImage)
                    }
                }
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
