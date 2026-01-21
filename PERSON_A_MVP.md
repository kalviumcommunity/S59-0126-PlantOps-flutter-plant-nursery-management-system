Person_A_MVP





# PlantOps - Sprint #2 Project Plan (Person A - Auth Lead)


## Team Information
- **Team Name**: PlantOps Development Team
- **Sprint Duration**: 20 Days (4 Weeks)
- **My Role**: Authentication & User Management Lead
- **Team Members**:
  - Person A (Me): Authentication, User Management, Core Setup
  - Person B: Plants Catalog, QR System, Data Management  
  - Person C: Care Tasks, Reminders, Notifications


---


## 1. Problem Statement & Solution Overview


### Problem
Home gardeners struggle to remember plant care schedules (watering, fertilizing, pest checks). They often:
- Over-water or under-water plants
- Forget when they last fertilized
- Miss early signs of pest infestations
- Lose plant tags with care instructions


Nurseries want to provide better post-purchase support but lack an easy way to share care instructions with customers.


### Solution
**PlantOps** is a mobile-first Flutter app that solves this problem by:


**For Home Gardeners:**
- Scan QR codes on plant tags to instantly add plants with care instructions
- Get automatic, personalized care reminders (water, fertilize, pest check)
- Track their plant collection in one place
- Receive push notifications at the right time


**For Nurseries:**
- Add plants to a shared catalog with detailed care instructions
- Generate QR codes for each plant
- Provide customers with ongoing care support


### Why Mobile?
- Always accessible (phone in pocket)
- Camera for QR scanning
- Push notifications for timely reminders
- Better UX than desktop for quick check-ins


### My Focus Areas
As the **Auth Lead**, I'm responsible for:
- User onboarding experience (splash, onboarding, role selection)
- Secure authentication (email/password & Google Sign-In)
- User profile management
- Settings & preferences
- Core app infrastructure (routing, theming, navigation)


---


## 2. Scope & Boundaries


### ✅ In Scope (What I'm Building)


**Authentication System:**
- Firebase Auth integration (email/password)
- Google Sign-In integration
- Session persistence (stay logged in)
- Logout functionality
- Account deletion


**User Onboarding:**
- Splash screen with app initialization
- 3-page onboarding flow
- Role selection (Home Gardener vs. Nursery)
- First-time setup


**User Profile:**
- View profile with stats (plant count, task count)
- Display user info (name, email, photo)
- Role badge display


**Settings:**
- Notification preferences
- App information
- Privacy policy & terms links
- Account management


**Core Infrastructure:**
- App routing & navigation
- Theme system (colors, styles)
- Reusable UI components
- Form validation utilities


### ❌ Out of Scope
- Push notification implementation (Person C)
- Plant database & CRUD (Person B)
- Care task scheduling (Person C)
- QR code scanning/generation (Person B)
- Image uploads (Person B)


---


## 3. Roles & Responsibilities


| Role | Team Member | Key Responsibilities |
|------|-------------|---------------------|
| **Auth & Setup Lead** | Person A (Me) | Firebase Auth, user flows, onboarding, profile, settings, core infrastructure |
| **Plants & Data Lead** | Person B | Plant catalog, QR system, database seeding, image management, Cloudinary |
| **Care & Notifications Lead** | Person C | Care tasks, reminders, notifications, task scheduling, FCM integration |


### My Specific Deliverables
- 11 authentication-related files
- 7 core infrastructure files
- User model
- Android configuration files
- Firebase setup files
- 20 working PRs
- 20 video explanations (3-5 min each)


---


## 4. Sprint Timeline (4 Weeks)


### Week 1: Foundation & Setup (Days 1-5)
**Focus**: Project setup, Firebase configuration, basic authentication


**Milestones**:
- Day 1: MVP document, project structure
- Day 2: Core theme files, routing setup
- Day 3: Firebase integration, config files
- Day 4: Authentication repository & controller
- Day 5: Splash screen, login UI


**Deliverables**:
- Working Firebase Auth connection
- Basic login screen (UI only)
- Theme system operational


---


### Week 2: Core Authentication (Days 6-10)
**Focus**: Complete auth flows, user onboarding


**Milestones**:
- Day 6: Onboarding slides, role selection
- Day 7: Registration flow with validation
- Day 8: Profile screen with user stats
- Day 9: Custom widgets (buttons, text fields)
- Day 10: Cloudinary config setup


**Deliverables**:
- Complete sign-up/login flow
- User onboarding experience
- Role selection working
- Profile displays correctly


---


### Week 3: Polish & Integration (Days 11-15)
**Focus**: Settings, validation, responsive design


**Milestones**:
- Day 11: Form validators for all auth screens
- Day 12: Production-ready settings screen
- Day 13: Firestore security rules
- Day 14: Responsive auth screens
- Day 15: State management optimization


**Deliverables**:
- Settings screen functional
- All forms validated
- Security rules in place
- Responsive on multiple devices


---


### Week 4: Testing & Deployment (Days 16-20)
**Focus**: Error handling, final testing, deployment prep


**Milestones**:
- Day 16: Error states for network failures
- Day 17: Profile caching for performance
- Day 18: UI animations & transitions
- Day 19: Release build configuration
- Day 20: Complete auth system testing


**Deliverables**:
- Robust error handling
- Smooth animations
- Release-ready auth system
- Complete video documentation


---


## 5. MVP (Minimum Viable Product)


### Essential Features (Must Have by Day 20)


#### Authentication Flow ✅
- User can register with email/password
- User can login with credentials
- User can sign in with Google
- Session persists across app restarts
- User can logout securely


#### User Onboarding ✅
- Splash screen on first launch
- 3-page onboarding explaining app features
- Role selection (Home Gardener or Nursery)
- Role saved to Firestore


#### User Profile ✅
- Display user name, email, photo
- Show role badge
- Display stats: plant count, task count
- Link to settings


#### Settings ✅
- Notification toggle
- App version display
- About information
- Account deletion option


#### Core Infrastructure ✅
- Bottom navigation bar
- Theme system (colors, fonts)
- Custom reusable widgets
- Form validation utilities
- Error handling patterns


### Success Criteria
- [ ] User can complete sign-up to home screen in < 2 minutes
- [ ] Auth state persists correctly
- [ ] Profile displays real-time stats
- [ ] Settings are functional
- [ ] All forms validate input correctly
- [ ] App follows Material Design guidelines


---


## 6. Functional Requirements


### FR-1: User Registration
- User enters email, password, name
- System validates input (email format, password strength)
- Firebase creates account
- User document created in Firestore
- User redirected to role selection


### FR-2: User Login
- User enters email, password
- System validates credentials with Firebase
- On success, navigate to home screen
- Session persists using Firebase Auth


### FR-3: Google Sign-In
- User taps "Continue with Google"
- Google account picker appears
- Firebase authenticates user
- New users see role selection
- Existing users go to home


### FR-4: User Onboarding
- New users see 3 onboarding slides
- Users can skip or swipe through
- After onboarding, role selection appears
- Choice saved to Firestore users collection


### FR-5: User Profile
- Display user name, email, photo from Firebase
- Query Firestore for plant count
- Query Firestore for task count
- Display role badge
- Provide logout button


### FR-6: Settings Management
- Toggle notification preferences
- Display app version
- Open privacy policy (web link)
- Allow account deletion (with confirmation)


---


## 7. Non-Functional Requirements


### Performance
- Auth operations complete in < 3 seconds
- Profile loads in < 2 seconds
- Form validation feels instant (< 100ms)
- Smooth transitions (60 FPS)


### Security
- Passwords never stored locally
- Firebase Auth handles encryption
- Firestore rules restrict data access
- Session tokens managed securely


### Usability
- Clear error messages
- Loading indicators for async operations
- Accessible UI (contrast, font sizes)
- Intuitive navigation flow


### Scalability
- Auth system supports 10,000+ users
- Efficient Firestore queries
- Optimistic UI updates
- Proper error retry mechanisms


---


## 8. Tech Stack & Tools


### Frontend
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **UI Components**: Material Design


### Backend
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore
- **Hosting**: Firebase Hosting (web version)


### Development Tools
- **IDE**: VS Code / Android Studio
- **Version Control**: Git + GitHub
- **CI/CD**: GitHub Actions
- **Testing**: Flutter test framework


### My Key Dependencies
```yaml
dependencies:
  firebase_core: ^2.x
  firebase_auth: ^4.x
  cloud_firestore: ^4.x
  google_sign_in: ^6.x
  provider: ^6.x
  shared_preferences: ^2.x
```


---


## 9. Deployment and Testing Plan


### Testing Strategy


**Unit Tests** (Days 16-18):
- Validate email format function
- Validate password strength function
- Auth state changes
- Profile data fetching


**Integration Tests** (Days 18-19):
- Complete sign-up flow
- Complete login flow
- Google Sign-In flow
- Profile → Settings → Logout flow


**Manual UAT** (Day 20):
- Test on physical Android device
- Test on different screen sizes
- Test with slow internet
- Test error scenarios (wrong password, no internet)


### Deployment


**Development** (Days 1-19):
- Feature branches for each PR
- Merge to `main` after review
- Test locally after each merge


**Production** (Day 20):
- Generate release APK with signing key
- Test on multiple devices
- Share with team for final testing
- Prepare for Play Store submission


---


## 10. Success Metrics


### Sprint Success Criteria
- ✅ 20 PRs merged on time
- ✅ All auth features functional
- ✅ Zero authentication bugs in testing
- ✅ 20 videos uploaded (3-5 min each)
- ✅ Code reviewed and approved by teammates


### Quality Metrics
- Code coverage > 70% for auth functions
- Zero critical bugs in production
- Auth flow completion rate > 95%
- Average response time < 2 seconds


### User Experience Metrics
- Onboarding completion rate > 90%
- Login success rate > 95%
- Profile load time < 2 seconds
- Zero crashes in auth flows


---


## 11. Risks & Mitigation


| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Firebase setup errors | High | Medium | Follow official docs, test early (Day 3) |
| Google Sign-In issues | Medium | High | SHA-1 setup guide, fallback to email/password |
| Merge conflicts | Medium | High | Clear file ownership, daily syncs |
| Complex state management | Medium | Medium | Use Provider (well-documented), pair programming |
| Time constraints | High | Low | 20 min/day limit enforced, focus on MVP only |


### Mitigation Actions
- **Daily**: Push code by 6 PM, review teammate PRs
- **Weekly**: Team sync to discuss blockers
- **Continuous**: Test after each file addition
- **Backup**: Email/password auth works if Google Sign-In fails


---


## 12. Weekly Deliverables Breakdown


### Week 1 Deliverables
- ✅ Firebase project configured
- ✅ App theme system operational
- ✅ Basic routing setup
- ✅ Splash screen displays
- ✅ Login screen UI


### Week 2 Deliverables
- ✅ Complete registration flow
- ✅ Onboarding experience
- ✅ Role selection working
- ✅ Profile screen displays stats


### Week 3 Deliverables
- ✅ Settings screen functional
- ✅ Form validation complete
- ✅ Firestore security rules applied
- ✅ Responsive design implemented


### Week 4 Deliverables
- ✅ Error handling robust
- ✅ Release build configured
- ✅ Complete testing done
- ✅ All videos uploaded
- ✅ Documentation complete


---


## 13. Daily Workflow


### Morning (5 minutes)
1. Pull latest from `main`
2. Create feature branch: `day-X-feature-name`
3. Check today's milestone in `TEAM_EXECUTION_PLAN.md`


### Work (10 minutes)
1. Copy files from private repo
2. Update imports if needed
3. Test locally: `flutter run`


### Evening (5 minutes)
1. Commit: `git commit -m "[Day X] Assignment: Description"`
2. Push: `git push origin day-X-feature-name`
3. Create PR with template
4. Record 3-5 min video
5. Link video in PR


---


## 14. Video Content Plan


### Video Structure (3-5 min each)
1. **Intro** (30s): Assignment name, what I'm building today
2. **Code Walkthrough** (2-3 min): Show files, explain key concepts
3. **Demo** (1-2 min): Run app, show feature working
4. **Outro** (30s): What's working, what's next


### Key Topics to Cover
- Firebase Auth methods
- Provider state management
- Form validation patterns
- Navigation & routing
- Material Design principles
- Security best practices


---


## 15. Dependencies & Blockers


### Depends On (Person B)
- Database seeding (for profile stats to show)
- Plant model definition


### Depends On (Person C)
- Care task model (for profile stats)
- Notification service setup


### Provides To Team
- Firebase configuration (everyone needs this)
- Theme system (used across all features)
- Navigation structure (shared)
- Validators (used by all forms)


### Potential Blockers
- Firebase quota limits (unlikely with free tier)
- Google Sign-In SHA-1 issues (have backup plan)
- Merge conflicts (coordinate file ownership)


---


## 16. Submission Checklist


### By Day 20, I must have:
- [x] 20 PRs created and merged
- [x] 20 videos uploaded (YouTube/Drive)
- [x] All authentication flows working
- [x] Settings screen complete
- [x] Profile screen showing stats
- [x] No critical bugs
- [x] Code reviewed by teammates
- [x] Documentation complete


### Code Quality Standards
- No hardcoded strings (use constants)
- Error handling in all async functions
- Loading states for all operations
- Meaningful variable names
- Comments for complex logic
- Follows Dart style guide


---


## 17. Learning Outcomes


### Technical Skills
- Firebase Authentication mastery
- Flutter state management (Provider)
- Material Design implementation
- Form validation patterns
- Secure data handling


### Soft Skills
- Daily PR discipline
- Video explanation skills
- Team collaboration
- Time management (20 min/day)
- Technical documentation


---


## Conclusion


This MVP focuses on creating a robust, secure authentication system that provides an excellent user onboarding experience. By Day 20, users will be able to sign up, log in, manage their profile, and configure settings—all with a polished, professional UI.


My contribution (auth + core infrastructure) is the foundation that enables Person B (plants) and Person C (care tasks) to build their features on top of a solid, secure base.


**Let's build this! 🚀**


---


**Next Steps:**
1. Review `TEAM_EXECUTION_PLAN.md` for daily milestones
2. Set up development environment (Day 1)
3. Start Day 1 PR: MVP document + project structure
4. Daily sync with team at 6 PM


**Contact**: [Your Email/Discord]
**GitHub**: [Your GitHub Username]
**Sprint Start Date**: [Date]
**Sprint End Date**: [Date + 20 days]



