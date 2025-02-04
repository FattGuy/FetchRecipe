# 🍽️ FetchRecipe - iOS Recipe App

## 🎥 Summary

### 🔹 **Features:**
- **🍛 Recipe List:** Displays a collection of recipes.
- **🖼️ Image Caching:** Efficient image loading with local caching to minimize network requests.
- **📡 Network Handling:** Uses async/await with error handling for API interactions.
- **📌 Pagination & Infinite Scrolling:** Dynamically loads more recipes when the user scrolls.
- **🔄 Pull-to-Refresh:** Allows users to refresh recipes at any time.
- **🚨 Edge Case Handling:** Handles malformed JSON and empty responses.

### 📸 **Screenshots & Video Demo**
https://github.com/user-attachments/assets/b8cdf36e-8e6e-49e1-86f1-af805bb9f76d

---
## 🎯 Focus Areas
### **Key Priorities & Why**
1. **Efficient Networking** - Using async/await, fetching Recipes & Images in Parallel, and work natively with SwiftUI.
2. **Image Caching** - Implementing a custom caching solution to optimize network usage and prevent redundant downloads.
3. **Pagination & Performance** - Fetching data in batches and dynamically loading additional recipes when needed.
4. **Testing & Maintainability** - Writing unit tests for API handling, caching, and ViewModel logic.

---
## ⏳ Time Spent
### **Approximate Time Breakdown:**
- **⏱️ 30% - API Integration & Error Handling**
- **⏱️ 40% - UI & Performance Optimization (Pagination, Image Caching, SwiftUI Layouts)**
- **⏱️ 20% - Unit Testing & Debugging**
- **⏱️ 10% - Documentation & Code Cleanup**

Total time spent: **~15 hours**

---
## ⚖️ Trade-offs & Decisions
### **Key Trade-offs Made:**
1. **No Third-Party Dependencies** → **Chose only Apple frameworks** to keep the project lightweight.
2. **Manual Image Caching vs. URLSession Cache** → Opted for **custom disk and memory caching** to control image expiration and avoid excessive downloads.
3. **Task Management** → Used **`Task.detached` and `Task.sleep(nanoseconds:)`** instead of traditional `DispatchQueue` to better manage Swift concurrency.
4. **Testing Focus** → Prioritized **network and ViewModel testing** over UI testing due to time constraints.
5. **Grid over simple list** to at least make the UI look more modern style.

---
## 🔻 Weakest Part of the Project
- **Animations & Transitions.**
- **More UI customization could enhance user experience.**

---
## ℹ️ Additional Information
### **If I could add more:**
- **I will add features such as search, filtering, and user authentication.**
- **Future improvements could include UI refinements, Core Data for offline support.**
