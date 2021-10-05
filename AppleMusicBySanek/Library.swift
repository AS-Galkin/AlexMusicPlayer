//
//  Library.swift
//  MusicPlayer
//
//  Created by Александр Галкин on 03.10.2021.
//

import SwiftUI

struct Library: View {
    
    @State var tracks: [SearchViewModel.Cell]
    @State private var alertViewState = false
    @State private var track: SearchViewModel.Cell!
    var tabBarDelegate: MainTabBarDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.8989167809, green: 0.8961265683, blue: 0.9011060596, alpha: 1)))
                                .cornerRadius(10)
                        })
                        
                        Button(action: {
                            getTracks()
                        }, label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.8989167809, green: 0.8961265683, blue: 0.9011060596, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 70)
                
                Divider().padding(.leading).padding(.trailing)
                
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track).gesture(LongPressGesture().onEnded({ _ in
                            self.alertViewState = true
                            self.track = track
                        })).simultaneousGesture(TapGesture().onEnded({ _ in
                            self.track = track
                            self.tabBarDelegate?.maximazeDetailTrackView(viewModel: track)
                            
                            //MARK: - GET FIRST KEY WINDOW IN SCENE
                            
                            let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
                            let mainTabBar = keyWindow?.rootViewController as? MainTabBarController
                            mainTabBar?.detailTrackView.delegate = self
                            
                        }))
                    }.onDelete(perform: deleteTrack(at:))
                }
            }
            .actionSheet(isPresented: $alertViewState, content: {
                ActionSheet(title: Text("Deleting"), message: Text("Are you shure, you whant to delete track?"), buttons: [.destructive(Text("Delete"), action: {
                    deleteTrack(track: self.track)
                }), .cancel()])
            })
            .navigationTitle("Library")
        }
    }
    
    private func deleteTrack(at offset: IndexSet) {
        self.tracks.remove(atOffsets: offset)
        SearchInteractor.deleteTrack(at: offset)
    }
    
    private func deleteTrack(track: SearchViewModel.Cell) {
        guard let index = (tracks.firstIndex {
            return $0.artistName == track.artistName && $0.trackName == track.trackName
        }) else {
            return
        }
        
        self.tracks.remove(at: index)
        
        SearchInteractor.deleteTrack(at: IndexSet(arrayLiteral: index))
    }
    
    private func getTracks() {
        SearchInteractor.loadTracks { tracks in
            if tracks != nil {
                self.tracks = tracks!
            }
        }
    }
}

struct LibraryCell: View {
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            
            if let urlImage = cell.trackImageUrl,
               let url = URL(string: urlImage),
               let data =  try? Data(contentsOf: url),
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage).resizable().frame(width: 60, height: 60).cornerRadius(5)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("\(cell.trackName ?? "")").fontWeight(.bold)
                Text("\(cell.artistName ?? "")")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library(tracks: [SearchViewModel.Cell.init()])
    }
}


extension Library: TrackMovingDelegate {
    func move(seek: Int) -> SearchViewModel.Cell? {
        guard let currentIndex = (tracks.firstIndex {
            return $0.artistName == track.artistName && $0.trackName == track.trackName
        }) else {
            return SearchViewModel.Cell()
        }
        
        var nextIndex = currentIndex + seek
        print(nextIndex)
        if nextIndex > tracks.count - 1 {
            nextIndex = 0
        } else if nextIndex < 0 {
            nextIndex = tracks.count - 1
        }

        self.track = tracks[nextIndex]
        
        return track
    }
}
