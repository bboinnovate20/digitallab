# Digital Lab

A cross-platform desktop and mobile image processing application built with Flutter. Digital Lab provides a suite of tools for everyday image editing tasks — currently featuring image compression and AI-powered background removal — with a clean dashboard-driven interface designed to scale as new tools are added.

---

## Features

### Image Optimizer
Reduce image file sizes without sacrificing quality. Choose between two compression modes:

- **Percentage mode** — use an interactive slider to set the desired quality level (0–100%)
- **Target size mode** — specify an exact output file size in KB or MB

The original file details (dimensions and file size) are shown alongside a live preview before exporting.

### Background Remover
Automatically remove the background from any image using an on-device ONNX model via the `image_background_remover` package. No internet connection or external API required — processing happens entirely on the user's device.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart SDK ^3.10.0) |
| Architecture | Feature-first with MVVM (ChangeNotifier ViewModels) |
| Image processing | `image` ^4.3.0, `image_background_remover` ^1.0.0 |
| File I/O | `image_picker` ^0.8.7, `file_picker` ^10.3.7 |
| UI utilities | `loader_overlay` ^5.0.0, `toastification` ^3.0.3 |
| Installer (Windows) | Inno Setup |
| CI/CD | GitHub Actions |

## CI/CD

GitHub Actions automates the Windows release pipeline on every push or pull request to `main`/`master`. The workflow:

1. Checks out the code and sets up Flutter 3.38.3 (stable)
2. Builds the Windows release binary
3. Packages the output as a `.zip` artifact (retained 30 days)
4. Installs Inno Setup and produces a full Windows installer artifact

See [`.github/workflows/window-build.yml`](.github/workflows/window-build.yml) for the full configuration.

---

## Roadmap

The following features are scaffolded and planned for future releases:

- **Photo Editing Lab** — general-purpose photo editor
- **Passport Photo Lab** — automatic crop and sizing for passport/ID prints

---

## License

This project is proprietary software owned by **Albarika Digital**. All rights reserved.
