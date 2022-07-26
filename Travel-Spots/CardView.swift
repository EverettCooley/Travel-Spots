import SwiftUI

struct CardView: View {
    
    @Binding var name: String
    @Binding var cat: String
    @Binding var type: String
    @Binding var photo: String
    @Binding var starOne: Int
    @Binding var starTwo: Int
    var liked : () -> ()
    var disliked : () -> ()
    
    let starList = ["star", "star.fill"]
    
    @State var refresh = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Image(photo)
                    .resizable()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.6) // 3
                
                HStack {
                    Image(systemName: "hand.thumbsdown.fill")
                        .foregroundColor(.gray)
                        .onTapGesture() {
                            self.disliked()
                        }
                    
                    Spacer()
                    VStack(alignment: .center, spacing: 6) {
                        Text(name)
                            .font(.title)
                            .bold()
                        Text(cat)
                            .font(.subheadline)
                            .bold()
                        Text(type)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.gray)
                        .onTapGesture() {
                            self.liked()
                        }
                    
                }.padding(.horizontal)
                HStack(alignment: .center){
                    Image(systemName: starList[starOne])
                        .foregroundColor(.yellow)
                    Image(systemName: starList[starTwo])
                        .foregroundColor(.yellow)
                }
            }
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}
