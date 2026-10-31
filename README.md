# 🎵 Sound Center

<div align="center">

![Sound Center Banner](assets/app.png)

### The Next-Generation Music Player & Streaming Experience for Android

[![Version](https://img.shields.io/badge/release-v1.3.0-blue.svg?style=for-the-badge)](https://github.com/Masthan008/Music/releases)
[![Platform](https://img.shields.io/badge/platform-Android-green.svg?style=for-the-badge)](https://github.com/Masthan008/Music)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B.svg?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-yellow.svg?style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0)

<br/>

**Sound Center** is a high-performance, elegant audio player and streaming hub. Featuring a **Liquid Glass UI** with frosted crystal translucency, Sound Center brings together offline music playback, live radio streaming, podcast discovery, and cloud music streaming across 13 Indian languages.

<br/>

[![Download APK](https://img.shields.io/badge/Download_APK-v1.3.0_Release-00C853?style=for-the-badge&logo=android&logoColor=white)](https://github.com/Masthan008/Music/releases)

</div>

---

## ✨ Key Highlights

### 💎 Modern Liquid Glass UI
- **Frosted Crystal Glass**: Translucent dialogs, floating mini-player, full-screen player, playlist cards, and headers powered by `liquid_glass_widgets`.
- **Dual Visual Themes**: Refined **Light Theme** (clean porcelain backdrop with cobalt blue accents) and **Dark Theme** (deep pitch-black with vibrant neon highlights).
- **Responsive Layout**: Fluid animations with orientation-aware headers and gesture navigation.

### 🎵 High-Performance Offline Music Player
- **Automatic Media Scanning**: Instantly discovers music on internal and SD card storage via Android MediaStore.
- **Smart Grouping**: Browse by Songs, Albums, Artists, Genres, Folders, and Playlists.
- **Queue Management**: Drag-and-drop playlist reordering, shuffle, repeat one/all, and instant search.
- **Filesystem Integrity**: Dual-tier deletion supporting scoped storage and direct filesystem synchronization.

### 📻 24/7 Live Radio Streams
- **Zero-Lag Playback**: Dual decoding engine supporting both **HLS (`.m3u8`)** live streams and **Progressive ICY MP3/AAC** radio broadcasts.
- **Curated Indian Stations**:
  - 🇮🇳 **AIR Vividh Bharati** (National Hindi)
  - 📻 **Bolly 92.3FM** (Non-stop Bollywood Hits)
  - 🎧 **4Lobos Bollywood Radio**
  - 🎶 **Fnf.Fm Hindi Hits**
  - 🎬 **London Telugu Radio** & **Melody Radio Telugu**
  - 🎵 **89.4 Tamil FM**
  - 🎙️ **AIR Urdu Live**
  - 🌍 **BBC World Service News**
- **Radio Browser Integration**: Access to 30,000+ free worldwide radio stations.

### 🎙️ Podcast Explorer & Hub
- **Reliable RSS Parser**: Fast feed fetching with custom browser headers to prevent CDN connection timeouts.
- **Popular Featured Shows**:
  - *The Ranveer Show (TRS)* - BeerBiceps (English & Hindi)
  - *Finshots Daily* - Daily financial analysis
  - *Raw Talks With Vamshi* - Telugu business podcast
  - *Vada Poche Tamil Podcast*
  - *Kahani Jaani Anjaani* - Hindi weekly stories
  - *TED Talks Daily* & *BBC Global News*
- **Offline Downloads**: Download podcast episodes directly for offline listening.

### ☁️ SoundCloud Cloud Streamer
- **Dedicated Language Quick-Bar**: 1-tap filtering for:
  - 🇮🇳 **Hindi (हिन्दी)**: Bollywood Hits, Hindi Romance, Arijit Singh Hits, Lo-Fi
  - 🎬 **Telugu (తెలుగు)**: Telugu Chartbusters, Tollywood Top 50, Sid Sriram
  - 🎵 **Tamil (தமிழ்)**: Kollywood Chartbusters, Anirudh Hits, Tamil Melodies
  - 🎙️ **Urdu (اردو)**: Urdu Ghazals, Coke Studio, Sufi & Melodies
  - 🌍 **English**: Global Top 50, Billboard Pop, Acoustic Chill
- **Instant Streaming**: Direct transcode extraction supporting both progressive and HLS streams.

### ⏱️ Precision Sleep Timer
- Custom countdown timer with preset shortcuts (15m, 30m, 45m, 1h, 2h).
- Smooth volume fade-out before audio pauses, preventing abrupt cutoffs while sleeping.

### 🎤 Synchronized Real-Time Lyrics
- Integrated real-time karaoke lyrics powered by the LRCLIB open-source database.
- Auto-scrolls in sync with audio playback with 1-tap time-jump seeking.

### 🇮🇳 13+ Indian Regional Languages
Tailored for Indian users with native script support:
- **English**
- **हिन्दी (Hindi)**
- **తెలుగు (Telugu)**
- **தமிழ் (Tamil)**
- **اردو (Urdu)**
- **বাংলা (Bengali)**
- **मराठी (Marathi)**
- **ગુજરાતી (Gujarati)**
- **ಕನ್ನಡ (Kannada)**
- **മലയാളം (Malayalam)**
- **ਪੰਜਾਬੀ (Punjabi)**
- **ଓଡ଼ିଆ (Odia)**
- **অসমীয়া (Assamese)**
- **فارسی (Persian)**

---

## 🏗️ Architecture & Technology Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.x / Dart 3.10+ |
| **State Management** | BLoC (flutter_bloc) pattern |
| **Audio Engine** | `just_audio` + `audio_service` + ExoPlayer |
| **Glassmorphism** | `liquid_glass_widgets` (custom shader & backdrop blur) |
| **Database** | Drift (SQLite ORM) + SharedPreferences |
| **Networking** | `http`, `dio`, `radio_browser_api`, `podcast_search` |
| **Lyrics** | LRCLIB REST API |

---

## 🚀 Building & Running Locally

### Prerequisites
- Flutter SDK 3.x (compatible with Dart 3.10+)
- Android SDK Platform 34+
- Java 17+

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Masthan008/Music.git
   cd Music
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run on connected Android device / emulator:**
   ```bash
   flutter run
   ```

4. **Build Release APK:**
   ```bash
   flutter build apk --release
   ```
   The universal release APK will be generated at:
   `build/app/outputs/flutter-apk/app-release.apk`

---

## 📦 Releases

Download the latest signed APK directly from the [GitHub Releases](https://github.com/Masthan008/Music/releases) or find Sound Center on the **Indus Appstore**.

---

## 📄 License

Sound Center is licensed under the [GNU General Public License v3.0 (GPLv3)](LICENSE).

---

<div align="center">
Crafted with ❤️ by Masthan | Designed for Music Lovers Worldwide
</div>
