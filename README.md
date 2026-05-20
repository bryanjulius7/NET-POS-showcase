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
- Split payment system
- Transaction and receipt management
- Refund handling
- Void workflows
- Receipt reprint workflow
- Real-time Firestore updates
- Multi-store support
- Central kitchen ordering
- Attendance enforcement
- Shift-based cash drawer system

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

# Transaction & Receipt Details

A transaction management workflow designed for operational receipt tracking and audit visibility.

## Highlights

- Receipt history lookup
- Receipt detail breakdown
- Void and refund actions
- Transaction timestamps
- Payment summaries
- Receipt reprint workflow
- Responsive master-detail layout
- Refund status indicators

## Screenshots

![Transaction Details](screenshots/transaction-details.png)

## Code Sample

[View transaction & receipt snippet](code-samples/transaction_receipt_snippet.dart)

---

# Shift & Cash Drawer Management

A shift-based cash drawer workflow designed for real-world retail and F&B operations.

## Highlights

- Opening cash workflow
- Expected cash reconciliation
- Pay in / pay out tracking
- Drawer lifecycle management
- Shift close reporting
- Z-report support
- Drawer history lookup
- Real-time cash calculations

## Screenshots

![Shift Open](screenshots/shift-open.png)

![Active Drawer](screenshots/shift-active.png)

![Shift Close Report](screenshots/shift-close-report.png)

![Drawer History](screenshots/drawer-history.png)

## Code Sample

[View shift management snippet](code-samples/shift_management_snippet.dart)

---

# Central Kitchen Ordering

An internal ordering workflow that allows outlets to request supplies from the central kitchen.

## Highlights

- Item selection workflow
- Quantity stepper controls
- Selected item and total quantity tracking
- Order confirmation screen
- Requested order history
- Order status tracking
- Confirmed / Requested / Rejected status indicators

## Screenshots

![Central Kitchen Order](screenshots/central-kitchen-order.png)

![Central Kitchen Confirm](screenshots/central-kitchen-confirm.png)

![Central Kitchen Requested](screenshots/central-kitchen-requested.png)

![Central Kitchen Detail](screenshots/central-kitchen-detail.png)

## Code Sample

[View central kitchen snippet](code-samples/central_kitchen_snippet.dart)



---

# Item Management & Grid Editor

A POS item management and grid customization workflow for configuring how items appear on the checkout screen.

## Highlights

- Active item list
- Searchable item management view
- Item image / color display
- Price and discount display
- Editable POS grid
- Assign item to grid slot
- Multi-page checkout layout
- Drag-and-drop grid rearrangement

## Screenshots

![Item Assignment](screenshots/item-assign.png)

![Items List](screenshots/items.png)

## Code Sample

[View checkout page snippet](code-samples/checkout_page_snippet.dart)


---

# Attendance Workflow

A staff attendance workflow designed for clock-in and clock-out tracking in a POS environment.

## Highlights

- Device session display
- Open clock-in session list
- Staff clock-in workflow
- Staff clock-out workflow
- 4-digit PIN verification
- Attendance confirmation screen
- Optional camera/photo capture in production flow

## Screenshots

![Attendance Dashboard](screenshots/attendance.png)

![Clock In PIN](screenshots/attendance-clock-in.png)

![Clock Out PIN](screenshots/attendance-clock-out.png)

## Code Sample

[View attendance snippet](code-samples/attendance_snippet.dart)

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
- Cash drawer reconciliation
- Attendance tracking workflows

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
- receipt integrity safeguards

---

# Disclaimer

This repository is intended for portfolio and technical showcase purposes only.

It does not contain the full commercial implementation of NETech POS.
