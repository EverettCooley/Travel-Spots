import SwiftUI
import Firebase

struct ContentView: View {

    @ObservedObject var database = Database()
    
    @State var searchText = "Vancouver"
    
    @State var cardName = "Blind Onion Pizza"
    @State var cardCat = "Pizza"
    @State var cardType = "Restaurant"
    @State var cardPhoto = "BlindOnion"
    @State var cardStarOne = 1
    @State var cardStarTwo = 1
    
    @State private var addingMenu = false
    
    @State var inputState = ""
    @State var inputCity = ""
    @State var inputName = ""
    @State var inputType = ""
    @State var inputCategory = ""
    @State var inputPhoto = ""
    
    @State private var showingAlert = false
    
    @State var names = [String]()
    
    var body: some View {

        return Group {
            if !addingMenu {
                VStack {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {

                                HStack(spacing: 6){
                                    Text(searchText)
                                        .bold()
                                    Spacer()
                                    Image(systemName: "plus")
                                        .foregroundColor(.gray)
                                        .onTapGesture {
                                            addingMenu = true
                                        }
                                }.padding()
                                SearchBar(text: $searchText, submited: self.submited)
                            }
                            Spacer()
                        }.padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                        
                    CardView(name: $cardName, cat: $cardCat, type: $cardType, photo: $cardPhoto, starOne: $cardStarOne, starTwo: $cardStarTwo, liked: self.liked, disliked: self.disliked)
                        
                    }.padding()
                }
            }else{
                Form{
                    Image(systemName: "arrow.left")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            addingMenu = false
                        }
                        .frame(alignment: .leading)
                        .padding(6)
                    TextField("State", text: $inputState)
                    TextField("City", text: $inputCity)
                    TextField("Name", text: $inputName)
                    TextField("Type", text: $inputType)
                    TextField("Category", text: $inputCategory)
                    TextField("Photo", text: $inputPhoto)
                    Button("Save"){

                        let db = Firestore.firestore()
                        let spotsRef = db.collection("spots")
                        let docRef = spotsRef.document(inputName)
                        docRef.getDocument { (documentSnapshot, error) in
                            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                                showingAlert = true
                            }
                            else{
                                spotsRef.document(inputName).setData([
                                    "Category" : inputCategory,
                                    "City" : inputCity,
                                    "Name" : inputName,
                                    "Photo" : inputPhoto,
                                    "State" : inputState,
                                    "Type" : inputType,
                                    "Rating" : 3
                                    ])
                                print("saved")
                                addingMenu = false
                            }
                        }
                    }
                }
                .alert("Please pick another name", isPresented: $showingAlert, actions: {})
            }// END OF ELSE
        }// END OF RETURN GROUP
    }// end of some view
    
    init(){
        database.fetchData()
        print(database.list)
    }
    
    func submited(){
//        print("called submited")
        if searchText == ""{
//            print("In if")
//            let db = Firestore.firestore()
//            let spotsRef = db.collection("spots")
//            spotsRef.getDocuments { (documentsSnapshot, error) in
//                if error == nil{
//                    print("no errors")
//    //                print(snapshot?.documents[0]["Name"]!)
//                    if (documentsSnapshot != nil){
//                        print("stuff in snapshot")
//                        if documentsSnapshot?.count == nil{
//
//                        }
//                    }
//                }else{
//                    print("has errors")
//                }
//            }
        }
        else{
            let db = Firestore.firestore()
            let spotsRef = db.collection("spots")
            let docRef = spotsRef.document(searchText)
            docRef.getDocument { (documentSnapshot, error) in
                if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                    var rating = documentSnapshot["Rating"] as! Int
                    cardName = documentSnapshot["Name"]  as! String
                    cardType = documentSnapshot["Type"] as! String
                    cardCat = documentSnapshot["Category"] as! String
                    cardPhoto = documentSnapshot["Photo"] as! String
                    
                    if rating == 0{
                        cardStarOne = 1
                        cardStarTwo = 0
                    }
                    if rating > 0{
                        cardStarOne = 1
                        cardStarTwo = 1
                    }
                    else{
                        cardStarOne = 0
                        cardStarTwo = 0
                    }
                    
                }
            }
        }
        
        
    }
    
    func disliked() {
        let db = Firestore.firestore()
        let spotsRef = db.collection("spots")
        let docRef = spotsRef.document(cardName)
        docRef.getDocument { (documentSnapshot, error) in
            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                var rating = documentSnapshot["Rating"] as! Int
                rating -= 1
                docRef.updateData(["Rating" : rating])
                print(rating)
            }
        }
    }
    
    func liked() {
        let db = Firestore.firestore()
        let spotsRef = db.collection("spots")
        let docRef = spotsRef.document(cardName)
        docRef.getDocument { (documentSnapshot, error) in
            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                var rating = documentSnapshot["Rating"] as! Int
                rating += 1
                docRef.updateData(["Rating" : rating])
                print(rating)
            }
        // update cardView

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
    }
}
