//
//  ProfileView.swift
//  FinTrack
//
//  Created by Rizwan N Sayyednavar on 14/09/26.
//
import SwiftUI

struct ProfileView : View {
    var body: some View {
        VStack(spacing : 10){
            Image(systemName: "person").font(.system(size: 40)).foregroundColor(.black).frame(width: 100, height: 100).background(.white).clipShape(Circle())
            Text("Rizwan N Sayyednavar").font(.title2).foregroundColor(.white)
            Text("rizwan@gmail.com").font(.title2).foregroundStyle(.white).tint(.white)
            
            VStack{
                ProfileItems()
                Spacer()
                LogoutButton()
            }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top).background(.white).clipShape(RoundedRectangle(cornerRadius: 16))
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
            .background(Color( hex: "0D182A"))
    }
}

struct ProfileItem : Hashable {
    let icon : String
    let title : String
}

struct ProfileItems : View {
    var profileItems : [ProfileItem] = [
        .init(icon: "gear", title: "Personal Information"),
        .init(icon: "bell", title: "Payment Methods"),
        .init(icon: "info.circle", title: "Categories"),
        .init(icon: "info.circle", title: "Notificaitons"),
        .init(icon: "info.circle", title: "Privacy & Security"),
        .init(icon: "info.circle", title: "Help & Support"),
        .init(icon: "info.circle", title: "About FinTrack"),
    ]
        
    var body: some View {
        VStack{
           ForEach(profileItems,id: \.self){ items in
               VStack(spacing: 0){
                   HStack{
                       Image(systemName: items.icon).foregroundColor(.gray)
                       Text(items.title).foregroundColor(.black)
                       Spacer()
                       Image(systemName: "chevron.right").foregroundColor(.gray)
                   }.padding(.vertical,16)
                   Divider()
               }
               
           }
        }.padding(16).frame(maxWidth: .infinity,)
    }
}


struct LogoutButton : View {
    var body: some View{
        HStack(){
            Image(systemName: "square.and.arrow.up.circle").foregroundColor(.red)
            Text("Logout").foregroundColor(.black)
        }.padding(16).frame(maxWidth: .infinity,alignment: .leading)
    }
}

#Preview {
    ProfileView()
}
