# NETech POS Showcase

A Flutter + Firebase POS system designed for hawker centres and coffee shops in Singapore.

This repository is a public showcase extracted from a larger production-oriented POS system built with Flutter and Firebase.

The goal of this showcase is to demonstrate:
- POS workflow design
- Transaction and payment systems
- Operational software architecture
- Real-world business process thinking
- Responsive Flutter UI engineering

Production backend logic, Firestore security rules, and commercial business implementations have been removed or simplified for public viewing.

---

# Features

- Checkout workflow
- Dynamic item grid
- Cart and quantity management
- Shift-based cash drawer workflow
- Split payment system
- Receipt generation
- Refund handling
- Real-time Firestore updates
- Multi-store support
- Central kitchen ordering workflow
- Attendance enforcement

---

# Tech Stack

- Flutter
- Dart
- Firebase Auth
- Cloud Firestore
- Provider
- GoRouter

---

# Checkout System

A responsive POS checkout workflow built with Flutter.

## Highlights

- Dynamic item grid
- Cart and quantity controls
- Edit-grid mode
- Promo / daily limit display
- Responsive layout for wide and compact screens
- Real-time order panel updates

## Screenshots

![Checkout Main](screenshots/checkout-main.png)

![Checkout Cart](screenshots/checkout-cart.png)

![Grid Editor](screenshots/checkout-grid-editor.png)

## Code Sample

[View checkout page snippet](code-samples/checkout_page_snippet.dart)

---

# Payment Flow

A payment workflow designed for POS checkout operations.

## Highlights

- Multiple payment methods
- Cash received and change calculation
- Manual discount input
- Quick cash amount buttons
- Split payment support
- Remaining balance and change tracking
- Responsive payment layout

## Screenshots

![Payment Page](screenshots/payment-page.png)

![Split Payment Page](screenshots/split-payment-page.png)

## Code Sample

[View payment flow snippet](code-samples/payment_flow_snippet.dart)

---

# Architecture Notes

This showcase repository contains simplified public-safe snippets extracted from a larger production POS system.

The original system includes:
- Receipt integrity safeguards
- Shift enforcement
- Refund protection logic
- Firestore security rules
- Multi-store architecture
- Transaction validation
- Operational business workflows

Sensitive production logic and backend implementations have been intentionally omitted.

---

# Project Status

Currently in active development and production hardening.

Focus areas include:
- transaction robustness
- operational reliability
- UI/UX refinement
- real-world shop deployment workflows
- payment integrity
- shift tracking accuracy

---

# Disclaimer

This repository is intended for portfolio and technical showcase purposes only.

It does not contain the full commercial implementation of NETech POS.
