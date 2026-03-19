# SpacedRep — Flutter Spaced Repetition App

Demo app Flutter quản lý task ôn tập theo lịch spaced repetition.  
Giao diện iOS-native, theme cam đậm `#FF4A00` trên nền đen.

---

## Features

- **3 tabs**: Home (dashboard), Tasks (danh sách + filter), Review (ôn tập hôm nay)
- **Blur floating tab bar** — kiểu iOS native, bo góc, translucent
- **Spaced repetition** logic: mốc ôn 1 / 3 / 7 / 14 / 30 ngày
- **Đã thuộc / Hủy thuộc** với confirm dialog (Cupertino style)
- **Bottom sheet "Hôm nay cần ôn"** — full timeline từng task
- **Filter chips** — Tất cả / Chưa thuộc / Đang theo lịch / Đến hạn hôm nay
- **Empty states** đẹp cho từng trường hợp

---

## Tech Stack

- Flutter (Dart) — Cupertino-first
- Provider — state management
- BackdropFilter / ImageFilter.blur — blur tab bar
- Không dùng package ngoài ngoài `provider`

---

## Chạy local

```bash
flutter pub get
flutter run
```

---

## Cấu trúc thư mục

```
lib/
├── main.dart
├── app.dart
├── models/
│   └── review_task.dart
├── data/
│   └── demo_tasks.dart
├── utils/
│   └── date_utils.dart
├── theme/
│   └── app_theme.dart
├── state/
│   └── task_store.dart
├── widgets/
│   ├── blur_tab_bar_shell.dart
│   ├── task_card.dart
│   ├── review_timeline.dart
│   └── empty_state.dart
├── screens/
│   ├── home_screen.dart
│   ├── tasks_screen.dart
│   └── review_screen.dart
├── sheets/
│   └── today_review_sheet.dart
└── dialogs/
    └── cancel_learned_dialog.dart
```

---

## GitHub Actions — iOS Unsigned Build

### Mục tiêu

Workflow `ios_unsigned_ipa.yml` build iOS artifact **không có code signing**.

### Hướng build

```
flutter build ios --release --no-codesign
```

Artifact được đóng gói thành `.ipa`-like file (zip chứa `Payload/Runner.app`) và upload lên GitHub Actions để tải về.

### ⚠️ Quan trọng — Giới hạn của unsigned build

> **Unsigned IPA / unsigned archive KHÔNG thể cài đặt hợp lệ lên iPhone thực.**

- Artifact này phục vụ mục đích **build verification** và **CI/CD pipeline**.
- Để phân phối hoặc cài lên thiết bị thật, cần phải **ký (code signing)** bằng Apple Developer certificate và provisioning profile hợp lệ.
- Sideload qua AltStore / Sideloadly cũng yêu cầu signing riêng của từng tool.
- Apple không cho phép cài app không ký lên iPhone production mà không có jailbreak.

### Fallback

Nếu `flutter build ios` thất bại, workflow fallback sang `xcodebuild archive` với:
```
CODE_SIGNING_ALLOWED=NO
CODE_SIGNING_REQUIRED=NO
CODE_SIGN_IDENTITY=""
```

---

## License

MIT
