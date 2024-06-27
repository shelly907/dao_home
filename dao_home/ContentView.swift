import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
        @Query(sort: \DataItem.name) var items: [DataItem]
        @State private var isShowingItemSheet = false
        @State private var countryEdit: DataItem?
        @State private var showNewTask = false
        
        func buttonPressed() {
            print("Button pressed")
        }
        
        func editItem(_ item: DataItem) {
            countryEdit = item
        }
       
        func deleteItem(_ item: DataItem) {
            context.delete(item)
        }
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(Color(red: 227/255, green: 237/255, blue: 255/255))
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                VStack {
                    HStack {
                        Text("Odyssey")
                            .font(.system(size: 35, weight: .bold, design: .default))
                            .foregroundColor(Color(red: 28/255, green: 57/255, blue: 105/255))
                            .padding(27)
                        Spacer()
                        Button(action:{
                            buttonPressed()
                        }) {
                            Menu{
                                NavigationLink(destination: SecondView()) {
                                    Button(action: { }) {
                                        Text("Your Passport")
                                    }
                                }
                                NavigationLink(destination: FourthView()) {
                                    Button(action: { }) {
                                        Text("Your Rankings")
                                    }
                                }
                                NavigationLink(destination: FifthView()) {
                                    Button(action: { }) {
                                        Text("Travel Quiz")
                                    }
                                }
                            }
                        label: {
                            Label(
                                title: {Text("") },
                                icon: {Image(systemName: "line.3.horizontal.decrease.circle")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 27, height: 27)
                                        .foregroundColor(Color(red: 28/255, green: 57/255, blue: 105/255))
                                    .padding(20)}
                            )
                        }
                        }
                    }
                    ScrollView(showsIndicators: false){
                                                VStack(spacing: 0.1){
                                                    ForEach(items) { item in
                                                        ZStack {
                                                            (Rectangle()
                                                                .frame(width: 350, height: 275)
                                                                .foregroundColor(.white))
                                                            .cornerRadius(13)
                                                            .padding(10)
                                                            VStack {
                                                                HStack {
                                                                    Image("mountain")
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fill)
                                                                        .frame(width: 160, height: 160)
                                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                                    Image("mountain")
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fill)
                                                                        .frame(width: 160, height: 160)
                                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                                } // hstack
                                                                .padding([.top], -35)
                                                                HStack{
                                                                    Text(item.name)
                                                                        .underline(true, color: .gray)
                                                                        .font(.system(size: 25, design: .default))
                                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                                        .foregroundColor(.black)
                                                                        .padding([.leading], 34)
                                                                        .padding([.bottom], 4)
                                                                    Spacer()
                                                                    Menu {
                                                                        Button(action: {
                                                                            editItem(item)
                                                                        }) {
                                                                            Text("Edit")
                                                                                
                                                                        }
                                                                        Button(action: {
                                                                            deleteItem(item)
                                                                        }) {
                                                                            Text("Delete")
                                                                        }
                                                                    } label: {
                                                                        Image(systemName: "ellipsis")
                                                                            .renderingMode(.original)
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 20, height: 20)
                                                                            .foregroundColor(.gray)
                                                                            .padding([.trailing], 40)
                                                                    }
                                                                }
                                                                Text(item.imageID)
                                                                    .padding([.leading], 27)
                                                                    .padding([.trailing], 35)
                                                            } // vstack
                                                        }
                                                    }
                                                    .onDelete { indexSet in
                                                        for index in indexSet {
                                                            context.delete(items[index])
                                                        }
                                                    }
                                                }
                                            } //scroll
                
            }
                .overlay {
                                    if items.isEmpty {
                                        ContentUnavailableView(label: {
                                            Label("Add Your First Destination", systemImage: "plane")
                                        })
                                        .offset(y: -60)
                                    }
                                }
                .sheet(isPresented: $isShowingItemSheet) {
                                    AddDataItem()
                                    
                                }
                .sheet(item: $countryEdit) { country in
                                    UpdateDataItem(country: country)
                                }
                VStack{
                  Spacer()
                 HStack{
                  Button(action:{isShowingItemSheet = true}) {
                      Image("Plus")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(width: 80, height: 80)
                       .foregroundColor(Color(red: 28/255, green: 57/255, blue: 105/255))
                       .padding(-17)
                       
                  } // button
                 //.contentShape(Circle())
                 } // button hstack
                } //button vstack
               } // closes zstack
               } // button
              } // closes body
             } // closes struct
#Preview {
    ContentView()
}

struct AddDataItem: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var imageID: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Country Name", text: $name)
                TextField("Image ID", text: $imageID)
            }
            .navigationTitle("New Country")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let item = DataItem(name: name, imageID: imageID)
                        context.insert(item)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UpdateDataItem: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var country: DataItem
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Country Name", text: $country.name)
                TextField("Image ID", text: $country.imageID)
            }
            .navigationTitle("New Country")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
