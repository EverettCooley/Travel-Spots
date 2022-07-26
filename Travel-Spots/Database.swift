import Foundation
import Firebase
import Combine

class Database: ObservableObject {
    
    @Published var list = [Card]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
            let db = Firestore.firestore()
            db.collection("spots").getDocuments { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot {
                        DispatchQueue.main.async {
                            self.list = snapshot.documents.map { d in
            
                                return Card(id: d.documentID,
                                            state: d["State"] as? String ?? "",
                                            city: d["City"] as? String ?? "")
                            }
                        }
                    }
                }
                else {
                }
            }
        }
}
