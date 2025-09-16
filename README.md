# Vider Provider

**Vider Provider** is a freelancer app that connects service providers with clients within their location.  
This app is used by service providers to:

1. Display their portfolio along with their current location.  
2. Exchange text messages with clients.  
3. Accept job offers.  
4. Receive payment in crypto after completing each job.  

The app is built with **Flutter** for the frontend, **Node.js** for the backend, and **MongoDB** for data storage.  

---

## 🏗 Architecture

The app follows a **Model–View–Controller (MVC)** software architecture:

- **Models**  
  Represent the data and business logic of the application.  
  Examples:  
  - `user_model` (username, lastname, etc.)  
  - `job_model` (duration, status, etc.)  

- **Views**  
  Represent the **UI elements** visible to the user.  
  Examples: Login screen, Dashboard, Job listings.  

- **Controllers**  
  Handle user input, process requests, and decide what data from the Model goes to the View.  
  Example: `transaction_controller` fetches transactions from the backend and displays transaction details in the transaction history screen using the `transaction_model`.  

👉 All **state management** logic is handled using **flutter_riverpod**.  

---

## 📱 Screenshots & Features

### 🔑 Authentication
- Sign In and Sign Up screens include all required form fields.  
- All input values are validated before submission.  
- Authentication tokens are stored securely.

<p align="center">
<img src="assets/screenshots/sign_in.png)" alt="Chats" width="220" height="500"/>
<img src="assets/screenshots/sign_up.png)" alt="Message" width="220" height="500"/>
</p>

### 📊 Dashboard
- Displayed after login.  
- Shows the **total amount earned** by the provider since joining.  
- Includes a **job heatmap** and **average job duration** statistics.

<img src="assets/screenshots/dashboard.png)" alt="Chats" width="220" height="500"/>

### 🛠 Jobs
- Displays all jobs, with **active jobs pinned at the top**.  
- Includes a **timer indicator** to show remaining time for active jobs.

<img src="assets/screenshots/jobs.png)" alt="Dashboard Screenshot" width="220" height="500"/>


### 💬 Chat & Messaging
- Chat screen lists all client conversations with **unread indicators**.  
- Instant messaging powered by **sockets**.  
- Integrated with **Firebase Cloud Messaging (FCM)** so providers never miss messages or job updates.  

<p align="center">
<img src="assets/screenshots/chats.png)" alt="Chats" width="220" height="500"/>
<img src="assets/screenshots/message.gif)" alt="Message" width="220" height="500"/>
</p>

### 👤 Profile & Settings
- Profile screen previews how the provider’s portfolio appears to clients.  
- Settings screen provides access to:  
  - Wallet (balance + token withdrawals).  
  - Location toggle (visible/invisible to clients).  
  - App and profile customization options.  

<p align="center">
<img src="assets/screenshots/profile.png)" alt="Profile" width="220" height="500"/>
<img src="assets/screenshots/settings.png)" alt="Settings" width="220" height="500"/>
</p>
---

## 🛠 Tech Stack
- **Frontend:** Flutter  
- **Backend:** Node.js  
- **Database:** MongoDB  
- **State Management:** Riverpod  
- **Messaging/Notifications:** WebSockets & Firebase Cloud Messaging  
- **Payments:** Crypto-based payments  

---
