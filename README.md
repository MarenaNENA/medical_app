# 🩺 Flutter Medical App

## 📖 Overview

**Flutter Medical App** is a cross-platform mobile application built with **Flutter** and **Firebase** that connects **patients** and **doctors** seamlessly.  
Patients can browse medical specialties, book appointments, and receive real-time updates when doctors accept or cancel their requests.  
Doctors can manage their appointments efficiently and notify patients instantly about booking status.

---

## ✨ Features

### 👩‍⚕️ For Patients
- Register and sign in using **Firebase Authentication**  
- Browse doctors by **specialization**  
- Book or cancel appointments easily  
- View appointment status (`booked`, `accepted`, `cancelled`)  
- Get real-time notifications for appointment updates  
- Separate tab for **Doctors Accepted** list  
- Multilingual support (**English / Arabic**)

### 👨‍⚕️ For Doctors
- View all appointments related to the logged-in doctor  
- Accept or cancel bookings directly from the app  
- Automatically notify patients via Firebase when appointment status changes  
- Simple, responsive, and clean UI

---

## 🧩 Technologies Used

| Technology | Purpose |
|-------------|----------|
| **Flutter (Dart)** | Cross-platform mobile app framework |
| **Firebase Authentication** | User authentication (sign in / sign up) |
| **Cloud Firestore** | Realtime NoSQL database for users, appointments & notifications |
| **Provider** | State management |
| **AutoSizeText** | Auto-adjust text size for responsive UI |
| **StreamBuilder** | Realtime Firestore updates |
| **SnackBar** | User-friendly alerts & status messages |
| **Custom Localization (tr function)** | Multi-language support (English & Arabic) |

---

## 🖼️ Main Screens

- Login & Sign Up  
- **Patient Dashboard:** Browse doctors by category and make appointments  
- **Doctor Dashboard:** Manage and update appointment statuses  
- Notifications  
- Language Switcher & Logout  

---

## 🧱 Project Structure

lib/
│
├── main.dart
├── providers/
│ └── doctor_provider.dart
├── screens/
│ ├── doctor/
│ │ └── doctor_home_screen.dart
│ └── patient/
│ └── patient_home_screen.dart
│
├── servces/
│ ├── Extantion.dart
│ └── translate.dart
│
├── Utiles/
│ └── doctor_model.dart
│
└── assets/
└── image/
├── Cardiology.webp
├── Neurology.jpg
├── Dermatology.jpg
└── ...

---

##🌐 Localization

Supports English and Arabic.

Language switching is available via the 🌐 icon in the top bar.

All app text uses the custom translation function tr(context) for dynamic localization.
