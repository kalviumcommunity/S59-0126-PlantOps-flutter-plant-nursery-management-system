# PlantOps - Sprint #2 Project Plan (Person C - Care & Reminders Lead)

## Team Information
- **Team Name**: PlantOps Development Team
- **Sprint Duration**: 20 Days (4 Weeks)
- **My Role**: Care Tasks & Notifications Lead
- **Team Members**:
  - Person A: Authentication, User Management, Core Setup
  - Person B: Plants Catalog, QR System, Data Management
  - Person C (Me): Care Tasks, Reminders, Notifications

---

## 1. Problem Statement & Solution Overview

### Problem
Home gardeners struggle to remember plant care schedules:
- Forget watering frequency for each plant
- Miss fertilizing schedules
- Don't check for pests regularly
- Plants die from neglect or over-care
- No reminders for different plants with different needs

This leads to:
- Dead plants (frustration + money wasted)
- Guessing when to water (over/under watering)
- Reactive pest control (damage already done)

### Solution
**PlantOps** provides **automatic, intelligent care reminders**:

**My Focus: The Smart Reminder System**
- When a plant is added (via QR scan), the app **automatically** creates care tasks
- Tasks include: Watering, Fertilizing, Pest Checks
- Each task has a frequency based on the plant type
- Users get **push notifications** at the right time
- When marked as "done", task automatically reschedules for next cycle

**Example Flow:**
1. User scans Monstera QR code
2. App creates:
   - 💧 Water every 7 days
   - 🧪 Fertilize every 30 days
   - 🐛 Pest check every 14 days
3. User gets notification: "Time to water your Monstera!"
4. User taps "Mark as Done"
5. Task reschedules for 7 days from now
6. Repeat forever!

### Why This Matters
The care reminder system is the **core value proposition**. Without it:
- App is just a plant database (not useful)
- Users still forget to care for plants
- Problem remains unsolved

My work directly solves the user's pain point.

### My Specific Focus Areas
As the **Care & Notifications Lead**, I'm responsible for:
- Care task data model & logic
- Automatic task creation when plants are added
- Recurring task scheduling
- Task completion & rescheduling
- Push notification integration (FCM)
- Upcoming care screen (calendar view)
- Task filtering (overdue, today, upcoming)
- Notification preferences

---

## 2. Scope & Boundaries

### ✅ In Scope (What I'm Building)

**Care Task System:**
- Automatic task creation when plant added
- Three task types: Watering, Fertilizing, Pest Check
- Each task has: Plant name, type, due date, frequency
- Task status tracking (pending, completed)
- Task rescheduling after completion

**Upcoming Care Screen:**
- List of all upcoming care tasks
- Grouped by date (Overdue, Today, Tomorrow, Upcoming)
- Filter chips (All, Today, Overdue, Upcoming)
- Visual indicators (red for overdue, orange for today)
- "Mark as Done" button per task

**Push Notifications:**
- Firebase Cloud Messaging (FCM) integration
- Local notifications for scheduled tasks
- Notification scheduling based on task due dates
- Notification when task is due (9 AM on due date)
- Toggle notifications on/off in settings

**Data Models:**
- Care task model with all fields
- Reminder model (legacy, for manual reminders)
- Recurring logic for task rescheduling

**Services:**
- Care task service (CRUD operations)
- Notification service (FCM + local notifications)
- Task scheduling logic

### ❌ Out of Scope
- User authentication (Person A)
- Plant database & QR scanning (Person B)
- Image uploads (Person B)
- Profile & settings UI (Person A)
- Analytics & tracking

---

## 3. Roles & Responsibilities

| Role | Team Member | Key Responsibilities |
|------|-------------|---------------------|
| **Auth & Setup Lead** | Person A | Firebase Auth, user flows, onboarding, routing, theme |
| **Plants & Data Lead** | Person B | Plant catalog, QR system, database, images, seeding |
| **Care & Notifications Lead** | Person C (Me) | Care tasks, reminders, notifications, scheduling, FCM |

### My Specific Deliverables
- 7 care/reminder feature files
- 2 data models (care_task, reminder)
- 2 core services (care_task_service, notification_service)
- Upcoming care screen with filters
- Notification system fully functional
- 20 working PRs
- 20 video explanations (3-5 min each)

---

## 4. Sprint Timeline (4 Weeks)

### Week 1: Foundation (Days 1-5)
**Focus**: Data models, basic services

**Milestones**:
- Day 1: MVP document, care task model
- Day 2: Notification service setup
- Day 3: Care task service (CRUD)
- Day 4: Upcoming care screen UI
- Day 5: Reminder model & repository

**Deliverables**:
- Care task model defined
- Notification service can send test notifications
- Basic care screen displays

---

### Week 2: Core Features (Days 6-10)
**Focus**: Task creation, scheduling, display

**Milestones**:
- Day 6: Automatic task creation logic
- Day 7: Notification scheduling
- Day 8: Task completion & rescheduling
- Day 9: Reminder card widget
- Day 10: Task filtering (overdue, today, upcoming)

**Deliverables**:
- Tasks auto-create when plant added
- Notifications schedule correctly
- Mark as done → task reschedules
- Filter chips work

---

### Week 3: Integration & Polish (Days 11-15)
**Focus**: Real-time updates, error handling

**Milestones**:
- Day 11: Real-time task updates
- Day 12: Notification preferences in settings
- Day 13: Firestore security rules for care_tasks
- Day 14: Responsive care screen
- Day 15: Loading & error states

**Deliverables**:
- Tasks update in real-time
- Notifications can be toggled
- Secure data access
- Smooth UX

---

### Week 4: Testing & Optimization (Days 16-20)
**Focus**: Bug fixes, complete integration

**Milestones**:
- Day 16: Test complete flow (QR scan → tasks → notify)
- Day 17: Notification optimization
- Day 18: UI animations
- Day 19: Build & test care system
- Day 20: Complete care demo

**Deliverables**:
- End-to-end flow works perfectly
- Notifications reliable
- Beautiful animations
- Complete video documentation

---

## 5. MVP (Minimum Viable Product)

### Essential Features (Must Have by Day 20)

#### Automatic Task Creation ✅
- When plant added to My Garden:
  - System reads plant care frequencies
  - Creates 3 tasks: Watering, Fertilizing, Pest Check
  - Each task has due date (today + frequency)
  - Saves to Firestore `care_tasks` collection

#### Upcoming Care Screen ✅
- Display all user's care tasks
- Grouped by date category:
  - Overdue (past due date, red)
  - Today (due today, orange)
  - Tomorrow (due tomorrow)
  - Upcoming (future dates)
- Each task shows:
  - Icon (💧 🧪 🐛)
  - Plant name
  - Task type
  - Due date (exact date + relative time)
  - "Mark as Done" button

#### Task Completion ✅
- User taps "Mark as Done"
- System:
  - Marks current task complete
  - Calculates next due date (current + frequency)
  - Creates new task for next cycle
  - Schedules notification for new task
- UI updates immediately

#### Push Notifications ✅
- User gets notification at 9 AM on due date
- Notification shows: "💧 Water your Monstera"
- Tapping notification opens app to Care tab
- Works even when app is closed

#### Filtering ✅
- Filter chips: All, Today, Overdue, Upcoming
- Tap to filter task list
- Count badge shows number per filter

### Success Criteria
- [ ] Tasks auto-create when plant scanned
- [ ] Care screen shows all tasks correctly
- [ ] Mark as done → task reschedules
- [ ] Notifications appear at scheduled time
- [ ] Filters work correctly
- [ ] No duplicate tasks
- [ ] Real-time updates work

---

## 6. Functional Requirements

### FR-1: Automatic Task Creation
**Trigger**: User adds plant to My Garden (via QR scan or manual)
**Process**:
1. System retrieves plant data
2. Reads care frequencies (wateringFrequencyDays, fertilizingFrequencyDays, pestCheckFrequencyDays)
3. Creates 3 care task documents:
   - Type: watering, due date: today + wateringFrequencyDays
   - Type: fertilizing, due date: today + fertilizingFrequencyDays
   - Type: pest_check, due date: today + pestCheckFrequencyDays
4. Schedules notifications for each task
5. Shows success message

### FR-2: Display Care Tasks
**Trigger**: User opens Care tab
**Process**:
1. System queries care_tasks where userId = currentUser
2. Filters active tasks only
3. Sorts by due date (earliest first)
4. Groups into categories (Overdue, Today, Tomorrow, Upcoming)
5. Displays in list with icons, dates, buttons

### FR-3: Mark Task Complete
**Trigger**: User taps "Mark as Done" on a task
**Process**:
1. System marks task as completed
2. Calculates next due date (completedAt + frequency)
3. Creates new task for next cycle
4. Cancels old notification
5. Schedules new notification
6. Updates UI (task disappears or moves)
7. Shows success message

### FR-4: Schedule Notifications
**Trigger**: Task created or rescheduled
**Process**:
1. System calculates notification time (due date at 9 AM)
2. Creates local notification with:
   - ID: task_id hash
   - Title: "💧 Water your [Plant Name]"
   - Body: "Time to take care of your plant!"
   - Scheduled time: due date at 9 AM
3. Saves notification ID for later cancellation

### FR-5: Filter Tasks
**Trigger**: User taps filter chip
**Process**:
1. System filters task list:
   - All: show all active tasks
   - Today: dueDate = today
   - Overdue: dueDate < today
   - Upcoming: dueDate > today
2. Updates UI with filtered tasks
3. Highlights selected chip

---

## 7. Non-Functional Requirements

### Performance
- Task list loads in < 2 seconds
- Mark as done completes in < 1 second
- Notifications deliver within 5 minutes of scheduled time
- Real-time updates appear in < 3 seconds

### Reliability
- Notifications never lost (persistent scheduling)
- Tasks never duplicated
- Rescheduling logic always correct
- No missed due dates

### Usability
- Clear visual indicators (overdue = red)
- One-tap task completion
- Intuitive grouping by date
- Helpful empty states

### Scalability
- Support 100+ tasks per user
- Efficient Firestore queries
- Batch operations for performance
- Proper indexing

---

## 8. Tech Stack & Tools

### My Key Technologies
- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Database**: Cloud Firestore
- **Notifications**: Firebase Cloud Messaging (FCM) + flutter_local_notifications
- **Date/Time**: Dart DateTime, intl package

### My Key Dependencies
```yaml
dependencies:
  cloud_firestore: ^4.x
  provider: ^6.x
  firebase_messaging: ^14.x
  flutter_local_notifications: ^17.x
  intl: ^0.18.x
  timezone: ^0.9.x
```

---

## 9. Database Structure (Firestore)

### `care_tasks` Collection
```javascript
{
  id: "auto-generated",
  userId: "user_id",
  plantId: "plant_id",
  plantName: "Monstera Deliciosa",
  taskType: "watering", // or "fertilizing", "pest_check"
  title: "💧 Water Monstera Deliciosa",
  description: "Water when top 2 inches are dry",
  frequencyDays: 7,
  nextDueDate: Timestamp,
  lastCompletedDate: Timestamp (nullable),
  isCompleted: false,
  isActive: true,
  createdAt: Timestamp,
  updatedAt: Timestamp (nullable)
}
```

### `reminders` Collection (Legacy)
```javascript
{
  id: "auto-generated",
  userId: "user_id",
  plantId: "plant_id",
  title: "Water Monstera",
  description: "Check soil moisture",
  reminderDate: Timestamp,
  isCompleted: false,
  createdAt: Timestamp
}
```

---

## 10. Care Task Logic

### Task Creation Algorithm
```dart
When plant added:
  FOR EACH care type (watering, fertilizing, pest_check):
    IF plant has frequency for this type:
      nextDueDate = today + frequency
      CREATE task with:
        - userId
        - plantId
        - taskType
        - nextDueDate
        - frequencyDays
      SCHEDULE notification for nextDueDate at 9 AM
```

### Task Completion Algorithm
```dart
When user marks done:
  completedAt = now
  nextDueDate = completedAt + frequency
  
  UPDATE old task:
    - isCompleted = true
    - lastCompletedDate = completedAt
  
  CREATE new task:
    - Same plant, type, frequency
    - nextDueDate = calculated above
    - isCompleted = false
  
  CANCEL old notification
  SCHEDULE new notification
```

### Overdue Detection
```dart
isOverdue = (nextDueDate < today) AND NOT isCompleted
isDueToday = (nextDueDate.day == today.day) AND NOT isCompleted
```

---

## 11. Deployment and Testing Plan

### Testing Strategy

**Unit Tests** (Days 16-18):
- Task creation logic
- Rescheduling calculations
- Date comparison functions
- Notification scheduling

**Widget Tests** (Days 18-19):
- Care screen renders
- Task cards display
- Filter chips work
- Mark as done button

**Integration Tests** (Day 19):
- Complete flow: Add plant → Tasks created → Mark done → Reschedules
- Notification scheduling
- Real-time updates

**Manual UAT** (Day 20):
- Test on physical device
- Wait for notification to arrive
- Verify notification time (9 AM)
- Test mark as done flow
- Test all filters

### Deployment
- Firebase FCM configured
- Notification permissions requested on first launch
- Android notification channels set up
- iOS notification settings configured

---

## 12. Success Metrics

### Sprint Success Criteria
- ✅ 20 PRs merged on time
- ✅ All care features functional
- ✅ Notifications working on device
- ✅ Zero task duplication
- ✅ 20 videos uploaded
- ✅ Zero critical bugs

### Quality Metrics
- Task creation success rate: 100%
- Notification delivery rate: > 95%
- Mark as done success rate: 100%
- Real-time update delay: < 3 seconds

### User Experience Metrics
- Task completion rate: > 80%
- Notification open rate: > 50%
- Filter usage: > 60% of users
- App crash rate: < 0.1%

---

## 13. Risks & Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Notification permission denied | High | Medium | Show clear explanation, graceful degradation |
| Tasks not rescheduling | Critical | Low | Extensive testing, logging, error handling |
| Duplicate tasks created | High | Medium | Check for existing tasks before creating |
| Notification not delivered | High | Medium | Use both FCM and local notifications |
| Time zone issues | Medium | Medium | Use user's local time consistently |

---

## 14. Daily Workflow

### Morning (5 minutes)
1. Pull latest: `git pull origin main`
2. Create branch: `git checkout -b day-X-feature`
3. Check today's milestone

### Work (10 minutes)
1. Implement today's file/feature
2. Test locally: `flutter run`
3. Verify milestone criteria met

### Evening (5 minutes)
1. Commit: `git commit -m "[Day X] Assignment 2.X: Description"`
2. Push: `git push origin day-X-feature`
3. Create PR
4. Record video (3-5 min)
5. Link video in PR

---

## 15. Video Content Plan

### Video Topics

**Days 1-5: Foundation**
- Care task data model design
- Firebase Cloud Messaging setup
- Firestore queries for care tasks
- ListView with custom widgets
- Date formatting with intl

**Days 6-10: Core Features**
- Automatic task creation logic
- Notification scheduling
- Task completion & rescheduling
- Widget composition (cards)
- Filtering logic

**Days 11-15: Integration**
- Real-time Firestore listeners
- Provider state management
- Security rules for care_tasks
- Responsive layouts
- Error handling patterns

**Days 16-20: Testing**
- Integration testing
- Notification testing
- Performance optimization
- Final polish
- Complete system demo

---

## 16. Dependencies & Blockers

### I Provide To Team
- Care task service (used when plants are added)
- Notification service (can be used app-wide)
- Bottom navigation (used by all tabs)

### I Depend On
- Person A: Firebase setup, authentication, routing
- Person B: Plant data (need care frequencies)

### Potential Blockers
- Waiting for Person B's plant data (Day 3)
- FCM configuration issues
- Android notification permissions
- Time zone handling complexity

---

## 17. Notification Strategy

### Android Setup
- Request POST_NOTIFICATIONS permission (Android 13+)
- Create notification channel
- Handle notification icons
- Test on physical device

### iOS Setup
- Request notification permissions
- Configure APNs certificates
- Test on physical device

### Scheduling
- Use flutter_local_notifications for local scheduling
- Use Firebase Cloud Messaging for remote push
- Schedule at 9 AM local time
- Cancel old notifications when rescheduling

---

## 18. Learning Outcomes

### Technical Skills Gained
- Firebase Cloud Messaging mastery
- Local notification scheduling
- Complex recurring logic
- Real-time data synchronization
- State management at scale

### Domain Knowledge
- Plant care automation
- Reminder systems design
- Notification best practices
- User engagement strategies

---

## Conclusion

The care reminder system is the **core value** of PlantOps. Without it, the app is just a plant encyclopedia. With it, we solve the real problem: helping people keep their plants alive through timely, automated reminders.

By Day 20, users will:
- Scan a QR code
- Automatically get care tasks created
- Receive push notifications at the right time
- Mark tasks as done with one tap
- Never kill a plant from neglect again!

**My work makes PlantOps actually useful.** 🌱📅🔔

---

**Next Steps:**
1. Review daily workflow document
2. Set up FCM in Firebase Console
3. Test notification permissions on device
4. Start Day 1: MVP + Care task model

**Contact**: [Your Email]
**Sprint Start**: [Date]
**Sprint End**: [Date + 20 days]
