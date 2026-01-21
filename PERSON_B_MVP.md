# PlantOps - Sprint #2 Project Plan (Person B - Plants Lead)


## Team Information
- **Team Name**: PlantOps Development Team
- **Sprint Duration**: 20 Days (4 Weeks)
- **My Role**: Plants Catalog & Data Management Lead
- **Team Members**:
  - Person A: Authentication, User Management, Core Setup
  - Person B (Me): Plants Catalog, QR System, Data Management
  - Person C: Care Tasks, Reminders, Notifications


---


## 1. Problem Statement & Solution Overview


### Problem
Home gardeners struggle to:
- Remember which plants they own and their specific care needs
- Find reliable, plant-specific care instructions
- Keep track of when they last performed care tasks
- Access care information after losing plant tags


Nurseries want to:
- Provide detailed care instructions with each plant sale
- Offer ongoing support to customers
- Build customer loyalty through better service


### Solution
**PlantOps** solves this by creating a **shared plant database** that connects nurseries and home gardeners:


**My Focus: The Plant Catalog System**
- **Nurseries** add plants with detailed care instructions (watering, fertilizing, pest control)
- Each plant gets a **unique QR code**
- **Home Gardeners** scan QR codes to add plants to their collection
- Plant data includes care frequencies that automatically create reminders


### Why This Matters
The plant catalog is the **foundation** of the entire app. Without accurate plant data:
- Care reminders can't be created
- Users don't know how to care for their plants
- The app provides no value


My work directly enables Person C (care tasks) to function.


### My Specific Focus Areas
As the **Plants Lead**, I'm responsible for:
- Plant data model & database structure
- Plant catalog UI (list, detail, search)
- QR code generation & scanning
- My Garden (user's personal collection)
- Image handling (Cloudinary integration)
- Database seeding with 50 real plants
- Add plant functionality (for nurseries)


---


## 2. Scope & Boundaries


### ✅ In Scope (What I'm Building)


**Plant Catalog System:**
- View all plants in a scrollable grid
- Search plants by name
- Filter plants by category
- View detailed plant information
- Plant card with image, name, category


**Plant Details:**
- Full plant information screen
- Display QR code for each plant
- Show care instructions
- Display care frequencies


**QR Code System:**
- Generate unique QR codes for each plant
- QR code scanner using device camera
- Scan-to-add functionality


**My Garden:**
- User's personal plant collection
- Add plants from catalog or QR scan
- Remove plants from collection
- Clear entire garden


**Data Management:**
- Plant data model with all required fields
- Firestore CRUD operations
- Database seeding script (50 real plants)
- Real plant images from Pexels
- Repository pattern for clean architecture


**Add Plant (Nursery Feature):**
- Form to add new plants to catalog
- Image upload to Cloudinary
- QR code auto-generation
- Form validation


### ❌ Out of Scope
- User authentication (Person A)
- Care task creation logic (Person C)
- Push notifications (Person C)
- Settings screen (Person A)
- Analytics & tracking


---


## 3. Roles & Responsibilities


| Role | Team Member | Key Responsibilities |
|------|-------------|---------------------|
| **Auth & Setup Lead** | Person A | Firebase Auth, user flows, onboarding, core infrastructure |
| **Plants & Data Lead** | Person B (Me) | Plant catalog, QR system, database, images, seeding |
| **Care & Notifications Lead** | Person C | Care tasks, reminders, notifications, task scheduling |


### My Specific Deliverables
- 10 plant feature files
- Plant model
- Database seeding with 50 real plants
- QR scanner & generator
- My Garden feature
- Cloudinary integration
- 20 working PRs
- 20 video explanations (3-5 min each)


---


## 4. Sprint Timeline (4 Weeks)


### Week 1: Data Foundation (Days 1-5)
**Focus**: Plant model, database structure, basic UI


**Milestones**:
- Day 1: MVP document, plant model definition
- Day 2: Plant repository with Firestore queries
- Day 3: Plant controller with state management
- Day 4: Plant list screen with grid view
- Day 5: Plant detail screen with images


**Deliverables**:
- Plant data model complete
- Can read plants from Firestore
- Basic plant catalog UI displays


---


### Week 2: Core Features (Days 6-10)
**Focus**: My Garden, search, QR system


**Milestones**:
- Day 6: My Garden screen showing user's plants
- Day 7: Add plant screen for nurseries
- Day 8: Plant search & filter functionality
- Day 9: QR code scanner with camera
- Day 10: Cloudinary image upload


**Deliverables**:
- My Garden functional
- Search works
- QR scanner opens camera
- Images upload successfully


---


### Week 3: Polish & Data (Days 11-15)
**Focus**: Real data, QR generation, optimization


**Milestones**:
- Day 11: Database seeding with 50 real plants
- Day 12: Clear My Garden feature
- Day 13: QR code display on plant details
- Day 14: Responsive plant screens
- Day 15: Loading states & error handling


**Deliverables**:
- 50 real plants in database
- QR codes generate correctly
- Responsive on all devices
- Smooth UX with loading indicators


---


### Week 4: Testing & Optimization (Days 16-20)
**Focus**: Bug fixes, performance, final testing


**Milestones**:
- Day 16: QR scan-to-add complete flow
- Day 17: Plant catalog performance optimization
- Day 18: UI polish & animations
- Day 19: Build & test plants module
- Day 20: Complete plants demo


**Deliverables**:
- QR scan → add → care tasks works
- Fast, smooth scrolling
- Beautiful UI
- Complete video documentation


---


## 5. MVP (Minimum Viable Product)


### Essential Features (Must Have by Day 20)


#### Plant Catalog ✅
- Display 50 real plants in grid layout
- Show plant image, name, category
- Search by plant name
- Filter by category (Indoor, Outdoor, Succulents)
- Tap to view details


#### Plant Details ✅
- Full-screen plant information
- Display QR code
- Show care instructions
- Display care frequencies (watering, fertilizing, pest check)
- Add to My Garden button


#### QR Code System ✅
- Generate unique QR for each plant
- QR scanner opens device camera
- Scan QR → automatically add plant to My Garden
- QR data format: `plantops://plant/{plantId}`


#### My Garden ✅
- Display user's plant collection
- Grid layout similar to catalog
- Remove individual plants
- Clear entire garden (with confirmation)
- Empty state when no plants


#### Data Management ✅
- 50 real plants with:
  - Real common & scientific names
  - Accurate care instructions
  - Real images from Pexels
  - Care frequencies (days)
- Firestore CRUD operations
- Repository pattern


#### Add Plant (Nursery) ✅
- Form with all plant fields
- Image upload to Cloudinary
- Form validation
- QR auto-generated on save


### Success Criteria
- [ ] Catalog displays 50 plants smoothly
- [ ] Search returns results instantly
- [ ] QR scanner recognizes codes
- [ ] My Garden updates in real-time
- [ ] Images load without delays
- [ ] No duplicate plants in user collection


---


## 6. Functional Requirements


### FR-1: View Plant Catalog
- User opens app → sees Plants tab
- System loads plants from Firestore
- Plants display in grid (2 columns)
- Each card shows image, name, category
- User can scroll smoothly


### FR-2: Search Plants
- User types in search bar
- System filters plants by name (case-insensitive)
- Results update in real-time
- Clear search button resets


### FR-3: View Plant Details
- User taps plant card
- System navigates to detail screen
- Display full information:
  - Large image
  - Common & scientific names
  - Description
  - Care instructions (sunlight, water, soil)
  - Care frequencies
  - QR code
- User can add to My Garden


### FR-4: Scan QR Code
- User taps QR scanner icon
- System requests camera permission
- Camera opens with scanning overlay
- When QR detected:
  - Parse plant ID
  - Fetch plant from Firestore
  - Show confirmation dialog
  - Add to My Garden
  - Create care tasks (Person C's code)
  - Show success message


### FR-5: My Garden
- User opens My Garden tab
- System queries user_plants collection
- Display user's plants in grid
- User can:
  - View plant details
  - Remove individual plants
  - Clear entire garden


### FR-6: Add Plant (Nursery)
- Nursery user taps Add Plant button
- Form with fields:
  - Name, scientific name, category
  - Description
  - Care instructions
  - Watering/fertilizing/pest check frequencies
  - Image upload
- System validates input
- System uploads image to Cloudinary
- System creates plant in Firestore
- System generates QR code
- Show success message


---


## 7. Non-Functional Requirements


### Performance
- Plant catalog loads in < 2 seconds
- Search results appear in < 500ms
- QR scanner opens camera in < 1 second
- Images cached for instant repeat views
- Smooth 60 FPS scrolling


### Data Quality
- 50 real plants with accurate information
- High-quality images (640x960px minimum)
- Verified care instructions
- Correct scientific names
- Working QR codes


### Usability
- Intuitive grid layout
- Clear plant photos
- Easy-to-read care instructions
- Simple QR scanning process
- Helpful empty states


### Scalability
- Support 100+ plants in catalog
- Handle 10,000+ user_plants documents
- Efficient Firestore queries
- Image CDN for fast loads


---


## 8. Tech Stack & Tools


### My Key Technologies
- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Database**: Cloud Firestore
- **Image Storage**: Cloudinary
- **QR Generation**: qr_flutter package
- **QR Scanning**: qr_code_scanner package


### My Key Dependencies
```yaml
dependencies:
  cloud_firestore: ^4.x
  provider: ^6.x
  cached_network_image: ^3.x
  qr_flutter: ^4.x
  qr_code_scanner: ^1.x
  image_picker: ^1.x
  cloudinary_public: ^0.x
```


---


## 9. Database Structure (Firestore)


### `plants` Collection
```javascript
{
  id: "auto-generated",
  name: "Monstera Deliciosa",
  scientificName: "Monstera deliciosa",
  category: "Indoor",
  description: "Popular houseplant...",
  imageUrl: "https://images.pexels.com/...",
  wateringFrequencyDays: 7,
  fertilizingFrequencyDays: 30,
  pestCheckFrequencyDays: 14,
  sunlight: "Bright indirect light",
  wateringInstructions: "Water when top 2 inches dry",
  fertilizingSchedule: "Feed monthly during growing season",
  commonPests: "Spider mites, mealybugs",
  soilType: "Well-draining potting mix",
  difficulty: "Easy",
  qrCode: "plantops://plant/{id}",
  nurseryId: "demo_nursery",
  nurseryName: "PlantOps Demo Nursery",
  isActive: true,
  createdAt: Timestamp,
  viewCount: 0
}
```


### `user_plants` Collection
```javascript
{
  id: "auto-generated",
  userId: "user_id",
  plantId: "plant_id",
  addedAt: Timestamp,
  healthStatus: "healthy"
}
```


---


## 10. Deployment and Testing Plan


### Testing Strategy


**Unit Tests** (Days 16-18):
- Plant model serialization
- Repository query functions
- Search/filter logic
- QR code generation


**Widget Tests** (Days 18-19):
- Plant card displays correctly
- Search bar filters
- QR scanner opens
- My Garden grid renders


**Integration Tests** (Day 19):
- Add plant → appears in catalog
- Scan QR → adds to My Garden
- Remove plant → updates collection
- Complete flow: catalog → detail → QR → My Garden


**Manual UAT** (Day 20):
- Test on physical device
- Scan real QR codes
- Test image loading
- Test with 50+ plants


### Deployment
- Database seeded on Day 11
- Images via Pexels CDN (no upload needed)
- Cloudinary configured for future uploads
- QR codes generated dynamically


---


## 11. Success Metrics


### Sprint Success Criteria
- ✅ 20 PRs merged on time
- ✅ All plant features functional
- ✅ 50 real plants in database
- ✅ QR system works end-to-end
- ✅ 20 videos uploaded
- ✅ Zero critical bugs


### Quality Metrics
- Image load time < 1 second
- QR scan success rate > 95%
- Search response time < 500ms
- App rating > 4.5 stars


### Data Quality Metrics
- 50 plants with verified info
- 100% of plants have images
- 100% of plants have care frequencies
- 100% of QR codes work


---


## 12. Risks & Mitigation


| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Finding 50 real plant images | High | Low | Use Pexels (free, high-quality) |
| Cloudinary quota limits | Medium | Low | Use Pexels URLs, only upload user images |
| QR scanner permission issues | Medium | Medium | Clear permission prompts, handle denial gracefully |
| Large images slow app | High | Medium | Use cached_network_image, compress images |
| Merge conflicts with Person A | Medium | High | Clear file ownership, sync daily |


---


## 13. Daily Workflow


### Morning (5 minutes)
1. Pull latest: `git pull origin main`
2. Create branch: `git checkout -b day-X-feature`
3. Check milestone in `TEAM_EXECUTION_PLAN.md`


### Work (10 minutes)
1. Copy files from PlantOpsPrivate
2. Update imports if needed
3. Test: `flutter run`
4. Verify feature works


### Evening (5 minutes)
1. Commit: `git commit -m "[Day X] Assignment: What I did"`
2. Push: `git push origin day-X-feature`
3. Create PR with template
4. Record video (3-5 min)
5. Link video in PR


---


## 14. Video Content Plan


### Video Topics


**Days 1-5: Foundation**
- Plant data model explained
- Repository pattern in Flutter
- GridView & custom cards
- Navigation & route passing
- Image caching strategies


**Days 6-10: Features**
- State management with Provider
- Firestore real-time queries
- Camera permissions & QR scanning
- Image upload to Cloudinary
- Form validation patterns


**Days 11-15: Data & Polish**
- Database seeding process
- Batch operations in Firestore
- QR code generation
- Responsive GridView
- Loading & error states


**Days 16-20: Integration**
- Complete QR flow demo
- Performance optimization
- UI animations
- Final testing
- Complete plant system demo


---


## 15. Dependencies & Blockers


### I Provide To Team
- Plant model (used by Person C for care tasks)
- Database seeding (everyone needs this)
- QR system (core feature)


### I Depend On
- Person A: Firebase setup, authentication, routing
- Person C: Care task creation when plant added


### Potential Blockers
- Waiting for Person A's Firebase config (Day 3)
- QR scanner issues on certain devices
- Image upload failures


---


## 16. Real Data Sources


### Plant Information
- The Spruce: https://www.thespruce.com/houseplants-4127819
- Gardening Know How: https://www.gardeningknowhow.com/houseplants/
- Wikipedia (scientific names)


### Plant Images
- **Primary**: Pexels (free, commercial use)
  - https://www.pexels.com/search/plants/
  - Top quality, no attribution required
- **Backup**: Pixabay
- **Avoid**: Google Images (copyright issues)


### Care Instructions
- Verified from multiple sources
- Cross-referenced with nursery guides
- Realistic frequency ranges


---


## 17. Learning Outcomes


### Technical Skills Gained
- Firestore queries & optimization
- Camera/permission handling
- QR code generation/scanning
- Image caching & optimization
- State management at scale


### Domain Knowledge
- Plant care basics
- Database design for hierarchical data
- UX for visual catalogs
- Mobile app performance


---


## Conclusion


The plant catalog is the **heart of PlantOps**. My work directly enables:
- Users to discover and learn about plants
- Automated care reminders (Person C's work depends on my data)
- A professional, polished app experience


By Day 20, users will be able to browse 50 real plants, scan QR codes to add them, and maintain their personal garden collection—all with a smooth, beautiful UI.


**Let's build the best plant catalog! 🌱**


---


**Next Steps:**
1. Review `TEAM_EXECUTION_PLAN.md`
2. Review `REAL_DATA_GENERATION.md`
3. Set up Pexels account (Day 2)
4. Start Day 1: MVP + Plant model


**Contact**: [gourii.a004@gmail.com]




