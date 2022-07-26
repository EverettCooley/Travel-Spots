import SwiftUI
import Firebase

@main
struct Travel_SpotsApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
