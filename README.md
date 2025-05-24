# tracker-app
A Swift based iOS application that tracks the user's location every 10 seconds, stores it locally using SwiftData, and syncs it to a backend server in chunks. If syncing fails, the app retries every 10 minutes. Authentication is handled via the OAuth2 Client Credentials flow.

## Technologies Used
- **Language:** swift
- **local storage:** SwiftData
- **UI:**  SwiftUI
- **concurrency:** async/await

## Architecture

This project follows the MVVM pattern:

- **Model**: Data layer 
- **ViewModel**: Handles business logic (`TrackingViewModelImpl`)
- **View**: SwiftUI view layer (`TrackingView.swift`)

Services are injected into the ViewModel to keep logic modular.

### Additional Notes
- Data is synced in chunks of 100 entries.
- If syncing fails, the app waits 10 minutes before retrying.
- Token expiry is handled automatically, with new tokens fetched as needed.