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
| ![Sign In](assets/screenshots/sign_in.png) | ![Sign Up](assets/screenshots/sign_up.png) |

### 📊 Dashboard
- Displayed after login.  
- Shows the **total amount earned** by the provider since joining.  
- Includes a **job heatmap** and **average job duration** statistics.
| ![Dashboard](assets/screenshots/dashboard.png) | 

### 🛠 Jobs
- Displays all jobs, with **active jobs pinned at the top**.  
- Includes a **timer indicator** to show remaining time for active jobs.
| ![Jobs](assets/screenshots/jobs.png) | 

### 💬 Chat & Messaging
- Chat screen lists all client conversations with **unread indicators**.  
- Instant messaging powered by **sockets**.  
- Integrated with **Firebase Cloud Messaging (FCM)** so providers never miss messages or job updates.  
| ![Chats](assets/screenshots/chats.png) | ![Message](assets/screenshots/message.gif) |

### 👤 Profile & Settings
- Profile screen previews how the provider’s portfolio appears to clients.  
- Settings screen provides access to:  
  - Wallet (balance + token withdrawals).  
  - Location toggle (visible/invisible to clients).  
  - App and profile customization options.  
  | ![Profile](assets/screenshots/profile.png) | ![Sign Up](assets/screenshots/settings.png) |

---

## 🛠 Tech Stack
- **Frontend:** Flutter  
- **Backend:** Node.js  
- **Database:** MongoDB  
- **State Management:** Riverpod  
- **Messaging/Notifications:** WebSockets & Firebase Cloud Messaging  
- **Payments:** Crypto-based payments  

---
