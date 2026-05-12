---
date: '2026-02-08'
description: 'Detailed workstation specifications and hardware setup'
published: true
title: 'Hardware'
---

My development workstation specifications, peripheral choices, and hardware philosophy. The physical tools that enable efficient development.

## Current Workstation (2024)

### Primary Development Machine

**Desktop Build (Custom)**
- **CPU:** AMD Ryzen 7 7700X (8 cores, 16 threads, 4.5GHz boost)
- **Motherboard:** ASUS ROG Strix B650E-F Gaming WiFi
- **Memory:** 32GB DDR5-6000 CL30 (2x16GB dual channel)
- **Storage:** 
  - 1TB Samsung 980 Pro NVMe SSD (OS and applications)
  - 2TB Samsung 970 EVO Plus NVMe SSD (projects and data)
  - 4TB Seagate Barracuda HDD (backups and archives)
- **GPU:** NVIDIA RTX 4060 Ti (8GB VRAM)
- **Power Supply:** Corsair RM850x 850W 80+ Gold
- **Case:** Fractal Design Meshify C (tempered glass, airflow focused)
- **CPU Cooler:** Noctua NH-D15 air cooling
- **Operating System:** Ubuntu 24.04 LTS

**Why These Choices:**
- **AMD CPU:** Better value for core count, excellent single-thread performance for compilation
- **DDR5 6000MHz:** Sweet spot for Ryzen 7000 series performance/price
- **Air cooling:** Quiet, reliable, no liquid maintenance concerns
- **NVMe storage:** Essential for fast compilation and IDE responsiveness
- **NVIDIA GPU:** CUDA support for ML, good driver support on Linux

### Display Setup

**Primary Monitor:** Dell U2723QE 27" 4K IPS
- Resolution: 3840x2160 @ 60Hz
- Panel: IPS with 99% sRGB, 95% DCI-P3
- Connectivity: USB-C (90W power delivery), DisplayPort, HDMI
- Features: Height adjustable, pivot, VESA mount

**Secondary Monitor:** LG 27GP850-B 27" QHD 165Hz
- Resolution: 2560x1440 @ 165Hz
- Panel: IPS with 1ms response time
- Usage: Gaming, testing high-refresh applications
- Mount: VESA arm for flexible positioning

**Third Monitor:** ASUS ProArt PA248Q 24" 1920x1200
- Resolution: 1920x1200 @ 60Hz  
- Usage: Terminal applications, documentation, reference
- Orientation: Vertical orientation for code review

### Input Devices

**Keyboard:** Keychron K2 (V2) - 75% Mechanical
- Switches: Gateron Brown (tactile, quiet)
- Layout: ANSI with Mac/Windows toggle
- Connectivity: USB-C wired + Bluetooth 5.1
- Backlight: White LED, adjustable brightness
- Why 75%: Function row + navigation keys, compact footprint

**Mouse:** Logitech MX Master 3S
- Sensor: 4000 DPI Darkfield
- Buttons: 7 customizable buttons
- Scroll: MagSpeed electromagnetic
- Battery: USB-C rechargeable (70 days)
- Why: Precision for GUI tasks, excellent for IDE navigation

**Trackpad:** Logitech K400 Plus (occasional use)
- Wireless keyboard with integrated trackpad
- Usage: Sofa coding, presentations
- Battery: Long life AA batteries

### Audio

**Headphones:** Beyerdynamic DT 770 PRO 80Ω
- Type: Closed-back, over-ear
- Impedance: 80Ω (easy to drive)
- Usage: Music while coding, video calls
- Cable: Detachable 3m coiled cable

**Microphone:** Blue Yeti Nano
- Type: USB condenser microphone
- Pattern: Cardioid pickup
- Usage: Video calls, streaming
- Mount: Adjustable boom arm

**Speakers:** Audioengine A2+ (Wireless)
- Type: Powered bookshelf speakers
- Connectivity: Bluetooth aptX, USB, RCA
- Usage: Music, video content
- Subwoofer: Audioengine S8 (optional)

### Network

**Primary Connection:** Ethernet (1Gbps)
- **Router:** TP-Link Archer AX6000
- **Switch:** Netgear GS308 8-port unmanaged
- **Cabling:** Cat6 for all devices

**Wireless:** Intel AX211 WiFi 6E
- Usage: Backup connection, mobile devices
- Speed: Up to 2.4Gbps on 6GHz band

### Peripherals

**Webcam:** Razer Kiyo Pro
- Resolution: 1080p @ 60fps
- Sensor: Sony STARVIS sensor
- Features: Adjustable field of view

**Dock:** CalDigit TS3 Plus (Thunderbolt 3)
- Ports: 15 total including USB-A, USB-C, DisplayPort, Ethernet
- Power: 85W charging for laptop
- Usage: When working from laptop

**Desk:** IKEA BEKANT (180x80cm) with adjustable height
- Surface: White laminate
- Features: Motorized height adjustment
- Storage: Cable management integrated

**Lighting:** Philips Hue Play & Gradient Lightstrip
- Bias lighting behind monitors
- Adjustable color temperature (2700K-6500K)
- Sync with screen content

## Philosophy Behind Hardware Choices

### Performance vs Price Optimization

**CPU Selection:**
- Not flagship Threadripper (overkill for most development)
- Not entry-level Ryzen (compilation bottlenecks)
- Sweet spot: Ryzen 7 - excellent single-thread for IDE, good multi-thread for builds

**Memory Strategy:**
- 32GB DDR5: Enough for IDEs, containers, virtual machines
- Dual channel: Maximizes bandwidth for Ryzen performance
- DDR5: Future-proofing, compatible with current platform

**Storage Hierarchy:**
- NVMe for active projects (speed matters)
- Secondary NVMe for larger projects/games
- HDD for backups (cost-effective bulk storage)

### Productivity-Focused Display Setup

**Why Three Monitors:**
- **Primary (4K):** Code editing, design work, video content
- **Secondary (QHD 144Hz):** Testing, debugging, gaming  
- **Tertiary (1200p vertical):** Documentation, reference, video calls

**Display Characteristics:**
- **High DPI:** Text rendering clarity for long coding sessions
- **Color Accuracy:** Important for web development and design
- **Ergonomics:** Height adjustment, eye-level positioning

### Input Philosophy

**Keyboard Selection Criteria:**
- **Mechanical switches:** Better tactile feedback, longer life
- **75% layout:** Essential keys + compact footprint
- **Brown switches:** Tactile but quiet for office environments
- **Programmability:** Custom keymaps for development efficiency

**Mouse Considerations:**
- **Precision sensor:** Important for IDE navigation and design work
- **Ergonomic design:** Long usage sessions without discomfort
- **Custom buttons:** Window management, application switching

## Alternative Setups

### Laptop Configuration

**When Away from Office:**
- **Primary:** Framework Laptop 13 (DIY edition)
- **CPU:** Intel Core i7-1260P
- **Memory:** 32GB DDR4
- **Storage:** 1TB NVMe
- **Display:** 13.5" 3:2 2256x1504
- **Reasoning:** Repairable, upgradeable, Linux compatibility

**Complementary Peripherals:**
- Portable monitor: ASUS ZenScreen 15.6" 1080p
- Keyboard: Foldable Bluetooth keyboard
- Mouse: Logitech MX Anywhere 3

### Server/Infrastructure

**Home Server:**
- **CPU:** Intel N100 (low power, efficient)
- **Memory:** 16GB DDR4
- **Storage:** 4TB NAS HDD array
- **OS:** Ubuntu Server 24.04 LTS
- **Purpose:** CI/CD, backups, home automation

### Mobile Development

**Testing Devices:**
- **Android:** Google Pixel 7a (stock Android, good Linux compatibility)
- **iOS:** Older iPhone for web compatibility testing
- **Cross-platform:** BrowserStack for comprehensive testing

## Maintenance and Upgrades

### Regular Maintenance

**System Cleaning:**
- Monthly dust cleaning with compressed air
- Quarterly deep cleaning with isopropyl alcohol
- Annual cable management review

**Software Maintenance:**
- Weekly system updates
- Monthly driver updates
- Quarterly configuration backup

### Upgrade Strategy

**Planned Upgrades (2024-2025):**
- **Storage:** Additional 4TB NVMe for game library
- **Memory:** Upgrade to 48GB if needed for VMs
- **GPU:** Potential RTX 5060 Ti when available
- **Monitors:** Consider ultrawide when 4K 144Hz becomes affordable

**Upgrade Philosophy:**
- **When it breaks:** Replace with current equivalent
- **When it bottlenecks:** Upgrade specific components
- **Every 4-5 years:** Major platform refresh
- **Keep compatibility:** Ensure new components work with existing

## Ergonomics and Health

### Physical Setup

**Desk Ergonomics:**
- Monitor height: Top of screen at eye level
- Keyboard: Elbow height, neutral wrist position
- Mouse: Same height as keyboard
- Chair: Lumbar support, feet flat on floor

**Lighting:**
- Bias lighting: Reduces eye strain
- Ambient lighting: 6500K neutral white
- Task lighting: Adjustable for documentation review

**Break Schedule:**
- Every 25 minutes: Stand and stretch
- Every 2 hours: 15-minute walk
- Every 4 hours: Longer break away from screens

### Health Monitoring

**Software Tools:**
- Workrave: Regular break reminders
- PomoDone: Time management with breaks
- f.lux: Blue light filtering by time of day

**Physical Considerations:**
- Standing desk usage: 2-3 hours per day
- Wrist exercises: Prevent repetitive strain
- Eye exercises: Reduce digital eye strain

## Budget Breakdown

### Current System Cost (2024)

| Component | Cost | Notes |
|-----------|------|-------|
| CPU (Ryzen 7 7700X) | $350 | Sweet spot performance |
| Motherboard | $280 | B650E with good features |
| Memory (32GB DDR5) | $180 | 6000MHz CL30 |
| Storage (3TB NVMe) | $350 | 1TB + 2TB drives |
| GPU (RTX 4060 Ti) | $400 | Good Linux drivers |
| Power Supply | $130 | 850W 80+ Gold |
| Case | $130 | Meshify C, good airflow |
| CPU Cooler | $100 | Noctua NH-D15 |
| **Total Computer** | **$1,920** |  |

| Component | Cost | Notes |
|-----------|------|-------|
| Primary Monitor (4K) | $500 | Dell U2723QE |
| Secondary Monitor (QHD) | $350 | LG 27GP850-B |
| Third Monitor (1200p) | $300 | ASUS ProArt PA248Q |
| Keyboard | $100 | Keychron K2 |
| Mouse | $70 | Logitech MX Master 3S |
| Audio Setup | $250 | Headphones + mic |
| Desk | $200 | IKEA BEKANT |
| **Total Peripherals** | **$1,770** |  |

| Category | Cost | Notes |
|-----------|------|-------|
| **Computer** | $1,920 | Core development machine |
| **Peripherals** | $1,770 | Input/output devices |
| **Monitors** | $1,150 | Display setup |
| **Furniture** | $200 | Desk and chair |
| **Total Investment** | **$5,040** |  |

### Cost-Benefit Analysis

**Productivity Gains:**
- Fast compile times: ~2 hours saved per week
- Multiple monitors: ~30% productivity increase
- Mechanical keyboard: ~15% typing comfort
- Ergonomic setup: Reduced health issues

**ROI Calculation:**
- Investment: $5,040 over 3-4 years
- Productivity gain: ~10 hours saved per week
- Value at $100/hour: $1,000/week
- Payback period: ~3 months

## Future Considerations

### Technology Trends

**Impact on Hardware Needs:**
- **AI-assisted development:** May increase GPU requirements
- **Remote work:** Network reliability becomes critical
- **Containerization:** Memory demands increase
- **Cross-platform development:** Multi-OS testing environments

### Environmental Impact

**Sustainability Considerations:**
- Power consumption monitoring
- Component recycling programs
- Repair vs replace decisions
- Energy-efficient components

### Long-term Planning

**5-Year Hardware Roadmap:**
- **2025:** GPU upgrade, monitor refresh
- **2026:** Memory/storage expansion
- **2027:** Complete platform refresh
- **2028:** Evaluate emerging technologies

## See Also

![[ evolution ]]

![[ philosophy ]]

![embed](https://github.com/topics/hardware)