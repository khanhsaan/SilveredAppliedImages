# SiveredAppliedImages

An iOS application that protects images from DeepFake AI manipulation by applying imperceptible adversarial perturbations.

## Overview

SiveredAppliedImages is a SwiftUI-based iOS app that adds subtle noise to your photos to make them resistant to AI-based manipulation and deepfake generation. The modifications are invisible to the human eye but can disrupt AI model processing.

## Features

- 📸 **Photo Selection** - Choose images directly from your photo library
- 🛡️ **AI Protection** - Apply adversarial noise to protect against deepfake models

## How It Works

The app applies a technique called "adversarial perturbation" by:

1. Loading the selected image into a pixel buffer
2. Adding random noise (±3) to each RGB channel of every pixel
3. The noise is small enough to be imperceptible to humans
4. But significant enough to disrupt AI model feature extraction

This makes the image resistant to being used as training data or input for deepfake generation models.

## Requirements

- iOS 16.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd SiveredAppliedImages
```

2. Open the project in Xcode:
```bash
open SiveredAppliedImages.xcodeproj
```

3. Build and run the project on your device or simulator

## Usage

1. Launch the app
2. Tap **"Select Photo"** to choose an image from your library
3. Once the image is loaded, tap **"Apply Anti-DeepFake Protection"**
4. Wait for processing to complete (progress bar will show status)
5. The protected image will be displayed

## Technical Details

### Algorithm

The protection is applied at the pixel level:

```swift
// For each pixel's RGB channels:
let noise = Int8.random(in: -3...3)
R = clamp(R + noise, 0, 255)
G = clamp(G + noise, 0, 255)
B = clamp(B + noise, 0, 255)
```

### Performance

- Processing is done asynchronously to maintain UI responsiveness
- Progress updates occur every ~10% completion
- Uses Core Graphics for efficient pixel manipulation

## Project Structure

```
SiveredAppliedImages/
├── SiveredAppliedImages/
│   ├── ContentView.swift              # Main UI and processing logic
│   ├── SiveredAppliedImagesApp.swift  # App entry point
│   └── Assets.xcassets/               # App assets
├── SiveredAppliedImagesTests/         # Unit tests
└── SiveredAppliedImagesUITests/       # UI tests
```

## Privacy

This app:
- ✅ Processes images locally on your device
- ✅ Does not send any data to external servers
- ✅ Does not store images without permission
- ✅ Respects iOS photo library permissions

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Author

Created by Anthony Tran

