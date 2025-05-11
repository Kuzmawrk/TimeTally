import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.openURL) private var openURL
    @StateObject private var themeManager = ThemeManager()
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfUse = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.ttBackground)
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        Button {
                            if let url = URL(string: Constants.appStoreURL) {
                                openURL(url)
                            }
                        } label: {
                            Label("Rate This App", systemImage: "star.fill")
                        }
                        
                        Button(action: shareApp) {
                            Label("Share This App", systemImage: "square.and.arrow.up")
                        }
                    } header: {
                        Text("Support Us")
                    }
                    
                    Section {
                        Toggle(isOn: $themeManager.isDarkMode) {
                            Label("Dark Mode", systemImage: "moon.fill")
                        }
                    } header: {
                        Text("Appearance")
                    }

                    Section {
                        Button {
                            showingPrivacyPolicy = true
                        } label: {
                            Label("Privacy Policy", systemImage: "hand.raised.fill")
                        }
                        
                        Button {
                            showingTermsOfUse = true
                        } label: {
                            Label("Terms of Use", systemImage: "doc.text.fill")
                        }
                    } header: {
                        Text("Legal")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPrivacyPolicy) {
                LegalView(title: "Privacy Policy", content: Constants.privacyPolicyText)
            }
            .sheet(isPresented: $showingTermsOfUse) {
                LegalView(title: "Terms of Use", content: Constants.termsOfUseText)
            }
        }
    }
    
    private func shareApp() {
        let text = "Check out TimeTally - a great app for tracking your time and staying productive!"
        let url = URL(string: Constants.appStoreURL)!
        let activityVC = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct LegalView: View {
    let title: String
    let content: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.ttBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    Text(content)
                        .padding()
                        .foregroundColor(Color(.ttText))
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
