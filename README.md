# 🎮 Tic Tac Toe - Flutter Edition

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web-blue?style=for-the-badge)

**A modern, feature-rich Tic Tac Toe game with AI gameplay, stunning animations, and clean architecture.**

[Features](#-features) • [Installation](#-quick-start) • [Screenshots](#-screenshots) • [Documentation](#-documentation)

</div>

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 🎯 Gameplay
- **Classic 3x3 Grid** - Traditional gameplay
- **AI Opponent** - Smart AI with strategic moves
- **Player vs Player** - Local multiplayer
- **Game History** - Track your stats
- **Score Tracking** - Persistent leaderboard

</td>
<td width="50%">

### 🎨 Experience
- **Beautiful UI** - Modern Material Design 3
- **Smooth Animations** - 60 FPS performance
- **Dark/Light Theme** - Eye-friendly modes
- **Sound Effects** - Immersive audio
- **Responsive Design** - All screen sizes

</td>
</tr>
</table>

---

## 📸 Screenshots

<div align="center">

### Light Mode

| Home Screen | Game Screen | Victory Screen |
|:---:|:---:|:---:|
| ![Home Light](https://raw.githubusercontent.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/main/screenshots/light-mode/home_screen.jpeg) | ![Game Light](https://raw.githubusercontent.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/main/screenshots/light-mode/game_screen.jpeg) | ![Victory Light](https://raw.githubusercontent.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/main/screenshots/light-mode/victory_screen.jpeg) |
| Main menu with game mode selection | Active gameplay with AI | Victory celebration screen |

### Dark Mode

| Home Screen | Game Screen | Victory Screen |
|:---:|:---:|:---:|
| ![Home Dark](https://raw.githubusercontent.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/main/screenshots/dark-mode/home_screen.jpeg) | ![Game Dark](https://raw.githubusercontent.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/main/screenshots/dark-mode/game_screen.jpeg) | ![Victory Dark](https://raw.githubusercontent.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/main/screenshots/dark-mode/victory_screen.jpeg) |
| Dark theme home screen | Gameplay with dark UI | Victory celebration animation |

### Game States

| Player's Turn | AI's Turn | Game Over |
|:---:|:---:|:---:|
| ![Player Turn](https://raw.githubusercontent.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/main/screenshots/gameplay/player_turn.jpeg) | ![AI Turn](https://raw.githubusercontent.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/main/screenshots/gameplay/ai_turn.jpeg) | ![Game Over](https://raw.githubusercontent.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/main/screenshots/gameplay/draw_screen.jpeg) |
| Waiting for player input | AI calculating best move | Draw game screen |

</div>

---

## 🚀 Quick Start

### Prerequisites
```bash
Flutter SDK ≥ 3.7.2
Dart SDK ≥ 3.0.0
Android Studio / VS Code
```

### Installation

```bash
# Clone the repository
git clone https://github.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe.git
cd digital_guruji_assignment_tic_tac_toe

# Install dependencies
flutter pub get

# Generate splash screen
flutter pub run flutter_native_splash:create

# Run the app
flutter run
```

### Build Release

```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ios --release

# Web
flutter build web --release
```

---

## 📁 Project Structure

```
lib/
├── 📄 main.dart                      # App entry point
├── 📄 app.dart                       # App configuration
├── 📁 core/                          # Core utilities
│   ├── 📁 constants/                 # App-wide constants
│   │   ├── app_colors.dart           # Color palette
│   │   ├── app_strings.dart          # Text constants
│   │   └── app_dimensions.dart       # Spacing & sizes
│   ├── 📁 theme/                     # Theme management
│   │   ├── app_theme.dart            # Light/Dark themes
│   │   └── theme_cubit.dart          # Theme state
│   ├── 📁 utils/                     # Helper utilities
│   │   ├── enum.dart                 # Enumerations
│   │   ├── game_logic.dart           # Game algorithms
│   │   └── sound_effects.dart        # Audio manager
│   └── 📁 widgets/                   # Reusable widgets
│       ├── animated_background.dart
│       ├── circular_icon_button.dart
│       └── primary_button.dart
└── 📁 features/                      # Feature modules
    ├── 📁 home/                      # Home screen
    │   └── home_screen.dart
    └── 📁 game/                      # Game feature
        ├── 📁 data/                  # Data layer
        │   ├── models/               # Data models
        │   └── repositories/         # Data sources
        ├── 📁 domain/                # Business logic
        │   ├── entities/             # Domain models
        │   └── usecases/             # Use cases
        └── 📁 presentation/          # UI layer
            ├── bloc/                 # State management
            ├── pages/                # Screens
            └── widgets/              # UI components
```

---

## 🛠️ Tech Stack

<table>
<tr>
<td>

**Framework & Language**
- Flutter 3.7.2+
- Dart 3.0.0+

**Architecture**
- Clean Architecture
- BLoC Pattern

</td>
<td>

**State Management**
- flutter_bloc
- equatable

**UI/UX**
- Material Design 3
- flutter_screenutil
- google_fonts

</td>
<td>

**Features**
- audioplayers
- shared_preferences
- flutter_native_splash

</td>
</tr>
</table>

---

## 🎮 Game Modes

### 🤝 Player vs Player (PvP)
- Traditional two-player local gameplay
- Turn-based strategic moves
- Real-time score tracking

### 🤖 Player vs AI
The AI uses intelligent strategy:
1. **Win** - Takes winning move if available
2. **Block** - Prevents opponent's win
3. **Center** - Prioritizes center position
4. **Corner** - Takes strategic corners
5. **Smart** - Analyzes best move

---

## 🎨 UI Features

### Themes
| Light Mode | Dark Mode |
|------------|-----------|
| Clean, bright interface | Eye-friendly colors |
| Perfect for daytime | Ideal for night |

### Animations
- ✨ Smooth page transitions
- 🎯 Micro-interactions on taps
- 🌊 Floating background elements
- 💫 Pulse effects for active player
- 🎭 Victory celebrations

---

## 🔊 Sound System

| Sound Type | Description |
|------------|-------------|
| **Move Sound** | Different tones for X and O |
| **Win Sound** | Victory celebration |
| **Draw Sound** | Tie game indication |
| **Background** | Looping ambient music |

---

## 📱 Platform Support

<div align="center">

| Platform | Status | Min Version |
|----------|--------|-------------|
| 🤖 Android | ✅ Supported | API 21 (5.0) |
| 🍎 iOS | ✅ Supported | iOS 11.0+ |
| 🌐 Web | ✅ Supported | Modern Browsers |
| 🪟 Windows | ✅ Supported | Windows 10+ |
| 🐧 Linux | ✅ Supported | Ubuntu 18.04+ |
| 🍏 macOS | ✅ Supported | macOS 10.14+ |

</div>

---

## 📊 Data Management

### Local Storage
- ✅ Game scores persistence
- ✅ Match history tracking
- ✅ Theme preferences
- ✅ Player statistics
- ✅ Settings configuration

---

## 🚢 Deployment

### Android (Google Play)
```bash
# Build signed AAB
flutter build appbundle --release

# Upload to Play Console
# Follow Google Play publishing guidelines
```

### iOS (App Store)
```bash
# Build release IPA
flutter build ios --release

# Archive in Xcode
# Upload to App Store Connect
```

### Web Hosting
```bash
# Build optimized web app
flutter build web --release --web-renderer canvaskit

# Deploy to Firebase/Netlify/Vercel
# Or upload build/web to any hosting service
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code quality
flutter analyze
```

---

## 🔧 Configuration

### Environment Setup

Create `.env` file:
```env
APP_NAME=Tic Tac Toe
APP_VERSION=1.0.0
ENABLE_SOUND=true
DEFAULT_THEME=system
```

### Android Config (`android/app/build.gradle`)
```gradle
android {
    compileSdk 34
    defaultConfig {
        applicationId "com.example.tic_tac_toe"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

---

## ⚡ Performance Optimization

### Build Optimization
```bash
# Enable ProGuard (Android)
flutter build apk --release --obfuscate --split-debug-info=debug-info/

# Tree shaking (Web)
flutter build web --tree-shake-icons

# Split per ABI (Android)
flutter build apk --split-per-abi
```

### Best Practices
- ✅ Use `const` constructors
- ✅ Dispose controllers properly
- ✅ Implement `RepaintBoundary` for complex widgets
- ✅ Optimize images and assets
- ✅ Minimize rebuilds with proper state management

---

## 🐛 Troubleshooting

<details>
<summary><b>Build Issues</b></summary>

```bash
# Clean project
flutter clean
flutter pub get

# Android specific
cd android && ./gradlew clean && cd ..

# iOS specific
cd ios && pod deintegrate && pod install && cd ..
```
</details>

<details>
<summary><b>Runtime Issues</b></summary>

- **Audio not playing**: Check device volume and permissions
- **Animations lagging**: Test in release mode
- **Layout problems**: Verify ScreenUtil configuration
</details>

<details>
<summary><b>Common Commands</b></summary>

```bash
flutter doctor           # Check installation
flutter analyze          # Analyze code
flutter pub deps         # Check dependencies
flutter pub upgrade      # Update packages
```
</details>

---

## 🤝 Contributing

We welcome contributions! Here's how:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** changes (`git commit -m 'Add AmazingFeature'`)
4. **Push** to branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Code Style
- Follow Dart conventions
- Write meaningful commit messages
- Add comments for complex logic
- Maintain test coverage
- Update documentation

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Developer

<div align="center">

### **Mohd Washid**

[![GitHub](https://img.shields.io/badge/GitHub-DEVILGHAZI-181717?style=for-the-badge&logo=github)](https://github.com/DEVILGHAZI)
[![Email](https://img.shields.io/badge/Email-mwashid914@gmail.com-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:mwashid914@gmail.com)
[![Phone](https://img.shields.io/badge/Phone-+91_8958618665-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)](tel:+918958618665)

**Made with ❤️ using Flutter**

</div>

---

## 🙏 Acknowledgments

- 🎯 Flutter team for the amazing framework
- 📦 BLoC team for state management architecture
- 🎨 Material Design team for design guidelines
- 🏢 Digital Guruji for the assignment opportunity
- 🌟 All contributors and testers

---

## 📞 Support

Need help? Reach out!

- 📧 **Email**: [mwashid914@gmail.com](mailto:mwashid914@gmail.com)
- 📱 **Phone**: [+91 8958618665](tel:+918958618665)
- 🐛 **Issues**: [GitHub Issues](https://github.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/DEVILGHAZI/digital_guruji_assignment_tic_tac_toe/discussions)

---

## 📈 Version History

| Version | Date | Changes |
|---------|------|---------|
| **v1.0.0** | 2025-10 | 🎉 Initial release with core features |

### What's Included in v1.0.0
- ✅ Classic Tic Tac Toe gameplay
- ✅ Intelligent AI opponent
- ✅ Beautiful animations and UI
- ✅ Sound effects and music
- ✅ Dark/Light theme support
- ✅ Game history tracking
- ✅ Native splash screen
- ✅ Cross-platform support

---

## 🎯 Roadmap

- [ ] Online multiplayer mode
- [ ] Difficulty levels for AI
- [ ] Customizable themes
- [ ] Achievements system
- [ ] Social sharing
- [ ] Tournament mode

---

<div align="center">

### ⭐ Star this repository if you like it!

**Happy Gaming! 🎮**

</div>