# ForgeAI Plugin - Complete How-to-Use Guide

## Table of Contents
1. [Installation](#installation)
2. [Getting Started](#getting-started)
3. [Interface Overview](#interface-overview)
4. [Layout Generator](#layout-generator)
5. [Asset Placement](#asset-placement)
6. [Performance Analysis](#performance-analysis)
7. [NPC Pathfinding](#npc-pathfinding)
8. [Script Generation](#script-generation)
9. [Theme Intelligence](#theme-intelligence)
10. [UI/UX Analysis](#uiux-analysis)
11. [Tips & Tricks](#tips--tricks)
12. [Troubleshooting](#troubleshooting)

---

## Installation

### Step 1: Locate Roblox Studio Plugins Folder

**On Windows:**
```
C:\Users\[YourUsername]\AppData\Local\Roblox\Plugins\
```

**On Mac:**
```
~/Library/Application Support/Roblox/Plugins/
```

**On Linux:**
```
~/.config/Roblox/Plugins/
```

### Step 2: Place ForgeAI Folder
1. Copy the entire `/ForgeAI` folder into your plugins directory
2. The folder structure should be:
   ```
   Plugins/
   └── ForgeAI/
       ├── PluginMain.lua
       ├── UI/
       ├── Core/
       ├── Utils/
       └── Data/
   ```

### Step 3: Start Roblox Studio
1. Open Roblox Studio
2. Create a new place or open an existing one
3. Look for the **ForgeAI** toolbar button (top-left area of Studio)
4. Click the button to open ForgeAI

### Step 4: Enable Plugin
If you see a security prompt:
1. Click **Allow** to enable the plugin
2. The ForgeAI window will appear on the right side of the screen

---

## Getting Started

### First Launch

When you open ForgeAI for the first time, you'll see:

1. **Main Window** (right side of Studio)
   - Dark theme interface with professional layout
   - Navigation panel on the left
   - Tool panels in the center
   - 3D preview viewport on the right

2. **Navigation Menu** (left sidebar)
   - 7 main tools available
   - Click any tool to switch to it
   - Current tool is highlighted

3. **Status Bar** (bottom)
   - Shows current operation status
   - Displays file/object count
   - Shows optimization suggestions

### Basic Workflow

1. **Select a tool** from the left navigation
2. **Configure settings** in the center panel
3. **Review preview** on the right side
4. **Apply changes** using the Generate/Apply button
5. **Use Undo** if needed (Ctrl+Z in Studio)

---

## Interface Overview

### Main Window Components

#### Left Sidebar (Navigation Panel)
- **Layout Gen** - Generate room/area layouts
- **Asset Place** - Place decorative and structural items
- **Performance** - Analyze and optimize game performance
- **NPC Paths** - Create NPC patrol routes and behaviors
- **Script Gen** - Generate starter scripts
- **Theme AI** - Analyze and apply visual themes
- **UI Analyzer** - Check UI accessibility and design

#### Center Panel (Tool Settings)
- Configuration options for selected tool
- Type-specific settings and controls
- Preview of generated content
- Generate/Apply buttons

#### Right Panel (3D Preview)
- Real-time 3D preview of your workspace
- Shows generated layouts and placements
- Camera controls for inspection
- Zoom and pan capabilities

#### Top Bar (Menu)
- File operations
- Preferences
- Help documentation

#### Bottom Bar (Status)
- Current operation feedback
- Statistics and metrics
- Progress indicators

---

## Layout Generator

The Layout Generator helps you create organized room and area layouts automatically.

### How to Use Layout Generator

#### Step 1: Select Layout Generator
- Click **"Layout Gen"** in the left navigation panel
- The Layout Settings panel appears in the center

#### Step 2: Configure Layout Type

In the "Layout Type" dropdown, choose:

**Grid Layout**
- Organized grid pattern
- Best for: warehouses, storage areas, markets
- Spacing: automatic grid alignment
- Use when: you need organized, uniform spacing

**Organic Layout**
- Natural, flowing arrangement
- Best for: parks, gardens, villages
- Spacing: varied, natural spacing
- Use when: you want natural-looking placement

**Modular Layout**
- Repeating module pattern
- Best for: residential buildings, game studios
- Spacing: consistent modular distance
- Use when: you need repeating structural units

#### Step 3: Configure Dimensions

**Grid Size** (1-100)
- Size of each grid cell in studs
- Default: 50
- Smaller = tighter layout
- Larger = more spaced out

**Density** (0-100%)
- How much of the grid gets filled
- 50% = half the grid gets items
- 100% = completely filled grid
- Use lower for sparse, upper for dense areas

#### Step 4: Set Dimensions

**Width** (10-1000 studs)
- Horizontal extent of the layout
- Default: 200 studs

**Height** (10-1000 studs)
- Vertical extent of the layout
- Default: 200 studs

#### Step 5: Configure Advanced Options

**Collision Detection** - Toggle ON
- Prevents overlapping objects
- Slightly slower but more reliable

**Path Generation** - Toggle ON
- Creates walking paths between items
- Good for navigable spaces

**Seed** (optional number)
- Same seed = same layout every time
- Leave blank for random results
- Use seeds to recreate layouts

#### Step 6: Preview and Generate

1. **See Preview** - 3D preview updates on the right
2. **Review Layout** - Inspect the generated layout
3. **Click Generate Layout** - Creates layout in workspace
4. **Use Undo** (Ctrl+Z) if you don't like the result

### Layout Generator Tips

- **Start small** - Create a 100x100 layout first to test
- **Use grid for markets** - Markets work best with grid layouts
- **Use organic for nature** - Gardens and parks use organic
- **Adjust density gradually** - Start at 50%, adjust up/down
- **Enable collision detection** - Prevents overlapping objects
- **Higher seed number = different layout** - Change seed to get variation

### Example: Creating a Market

1. Select **Layout Gen**
2. Choose **Grid Layout**
3. Set Grid Size to 40
4. Set Density to 75%
5. Set Width/Height to 300
6. Enable Collision Detection
7. Click Generate Layout
8. Review and adjust with Asset Placement tool

---

## Asset Placement

Asset Placement allows you to intelligently place decorative and structural items in your scene.

### How to Use Asset Placement

#### Step 1: Select Asset Placement
- Click **"Asset Place"** in the left navigation
- Asset Placement settings appear

#### Step 2: Choose Asset Type

**Decorations**
- Visual embellishments
- Doesn't block movement
- Examples: trees, statues, signs

**Structures**
- Physical buildings/walls
- Blocks movement
- Examples: buildings, walls, barriers

**Props**
- Interactive items
- Can have scripts
- Examples: doors, chests, furniture

#### Step 3: Select Zone Type

**Market Zone**
- Commercial areas with shops
- Good for: marketplace, shopping areas
- Spacing: 30-50 studs between items

**Residential Zone**
- Housing and living areas
- Good for: villages, neighborhoods
- Spacing: 40-60 studs between items

**Industrial Zone**
- Factory and production areas
- Good for: factories, warehouses
- Spacing: 50-80 studs between items

**Natural Zone**
- Outdoor natural areas
- Good for: parks, forests, gardens
- Spacing: 20-40 studs between items

#### Step 4: Adjust Placement Parameters

**Density** (10-100%)
- How densely to place items
- 30% = sparse placement
- 70% = dense placement
- Default: 50%

**Spacing** (1-30 studs)
- Minimum distance between items
- Higher = more spread out
- Lower = closer together
- Adjusted by zone type

#### Step 5: Enable Constraints (if needed)

**Height Constraint** - Prevents placement above certain height
**Slope Constraint** - Avoids steep slopes
**Water Avoidance** - Doesn't place on water

#### Step 6: Generate and Apply

1. **Preview Generation** - See placement on right panel
2. **Review Positions** - Check if spacing looks good
3. **Click Place Assets** - Adds assets to workspace
4. **Fine-tune** - Manually move any misplaced items

### Asset Placement Tips

- **Use natural zones for forests** - Spreads items naturally
- **Use market zones for cities** - Creates organized shopping areas
- **Adjust spacing if too crowded** - Increase spacing value
- **Mix asset types** - Combine decorations + structures for variety
- **Preview before applying** - Always check preview first
- **Lower density for open spaces** - Leave room to move around

### Example: Populating a Market Area

1. First, generate layout with Layout Generator
2. Select Asset Placement
3. Choose "Decorations" type
4. Select "Market Zone"
5. Set Density to 60%
6. Set Spacing to 35
7. Click Preview
8. If good, click Place Assets

---

## Performance Analysis

The Performance Analysis tool helps identify and fix performance issues in your game.

### How to Use Performance Analysis

#### Step 1: Select Performance Analyzer
- Click **"Performance"** in the left navigation
- Performance Metrics dashboard appears

#### Step 2: Understand the Metrics

**Complexity Score** (0-100)
- 0-25: Simple, very fast
- 25-50: Moderate, good performance
- 50-75: Complex, watch performance
- 75-100: Very complex, needs optimization

**Memory Usage**
- Shows estimated memory in MB
- Lower is better
- Aim for < 100 MB per area

**Physics Complexity**
- Number of physics-enabled parts
- Higher = slower physics
- Reduce with optimization

**Render Cost**
- How much GPU power needed
- High = needs optimization
- Reduce with LOD or part merging

**Device Impact**
- Mobile: Impact on mobile devices
- PC: Impact on high-end PCs
- Device Impact shows which devices are affected

#### Step 3: View Recommendations

The Performance panel shows:
- **Top Bottlenecks** - What's causing slowness
- **Quick Fixes** - Easy optimizations to try first
- **Advanced Options** - More complex optimizations

#### Step 4: Run Analysis

1. **Select Region** - Choose area to analyze
2. **Click Analyze** - Scans the region
3. **Review Results** - See metrics and recommendations
4. **Note Issues** - Write down what needs fixing

#### Step 5: Apply Optimizations

**Optimization Types Available:**

**Disable Shadows** - Turn off shadow rendering
- Performance gain: High (20-40%)
- Quality loss: Moderate
- Use for: background objects

**Disable Physics** - Remove physics from decorations
- Performance gain: Medium (10-20%)
- Quality loss: None (if pure decoration)
- Use for: non-interactive objects

**Merge Parts** - Combine nearby parts
- Performance gain: High (15-30%)
- Quality loss: None
- Use for: static scenery

**Enable LOD** - Use Level of Detail
- Performance gain: Medium (15-25%)
- Quality loss: Very low
- Use for: distant objects

#### Step 6: Compare Before/After

1. **Note metrics before optimization**
2. **Apply one optimization**
3. **Re-analyze**
4. **Compare results**
5. **Decide if worth it**

### Performance Analysis Tips

- **Analyze regularly** - Check performance after major changes
- **Start with shadows** - Usually biggest performance impact
- **Use LOD for distant objects** - Nearly invisible quality loss
- **Merge static parts** - Big performance gain for decoration
- **Keep one optimization at a time** - See what actually helps
- **Target mobile first** - If it's fast on mobile, it's fast everywhere
- **Complexity score matters most** - Keep it under 60 for good performance

### Example: Optimizing a Complex Scene

1. Select Performance Analyzer
2. Click Analyze Current Region
3. Note complexity score (say it's 82)
4. See recommendations: "Disable shadows" suggested
5. Enable "Disable Shadows" checkbox
6. Click Preview
7. Re-analyze
8. Complexity drops to 65 (much better!)
9. Click Apply

---

## NPC Pathfinding

The NPC Pathfinding tool creates patrol routes, cover points, and interaction zones for NPCs.

### How to Use NPC Pathfinding

#### Step 1: Select NPC Pathfinding
- Click **"NPC Paths"** in the left navigation
- NPC Settings panel appears

#### Step 2: Configure Patrol Type

**Linear Patrol**
- NPC walks back and forth between two points
- Use for: guards, sentries
- Waypoints: 2-5
- Speed: 16-32 studs/sec

**Loop Patrol**
- NPC walks in a circle/loop pattern
- Use for: guards, explorers
- Waypoints: 3-10
- Speed: 10-25 studs/sec

**Coverage Patrol**
- NPC covers a region thoroughly
- Use for: security, exploration
- Waypoints: 5-20
- Speed: 8-16 studs/sec

#### Step 3: Set Patrol Parameters

**Waypoint Count** (2-20)
- Number of points NPC visits
- More = longer patrol route
- Default: 5

**Patrol Speed** (5-50 studs/sec)
- Movement speed of NPC
- 16 = walking speed
- 32 = running speed
- 50 = sprinting

**Waypoint Spacing** (10-100 studs)
- Distance between waypoints
- Larger = longer paths
- Smaller = tighter control

**Wait Duration** (0-10 seconds)
- How long to wait at each waypoint
- 0 = no waiting
- 5 = stop for 5 seconds
- Use for: looking around behavior

#### Step 4: Configure Cover Points (Optional)

**Generate Cover Points** - Toggle ON
- Creates places for NPC to take cover
- Useful for: combat scenarios
- Spacing: auto-calculated

**Cover Point Density** (10-100%)
- How many cover points to create
- 50% = moderate cover points
- 100% = maximum coverage

#### Step 5: Create Interaction Zones

**Zone Type:**
- Dialogue Zone: NPC talks to players
- Trade Zone: NPC trades items
- Quest Zone: NPC gives quests

**Zone Radius** (5-50 studs)
- How far from NPC to trigger
- Smaller = must be closer
- Larger = can interact from far away

#### Step 6: Generate Patrol Routes

1. **Select NPC** - Click the NPC in workspace (or auto-detect)
2. **Click Generate Path** - Creates patrol route
3. **Review in preview** - See the patrol route visualization
4. **Adjust if needed** - Edit waypoint spacing/count
5. **Click Apply** - Creates path in workspace

#### Step 7: Connect to NPC Script

Once paths are generated:

1. In workspace, find your NPC folder
2. Find the newly created "PatrolPath" folder
3. Create a script in your NPC with code like:

```lua
local patrolPath = script.Parent:WaitForChild("PatrolPath")
local waypoints = patrolPath:GetChildren()

-- Make NPC walk to each waypoint
for _, waypoint in ipairs(waypoints) do
    -- Move NPC to waypoint position
    script.Parent:MoveTo(waypoint.Position)
    wait(2) -- Wait 2 seconds before next waypoint
end
```

### NPC Pathfinding Tips

- **Use linear patrol for narrow areas** - Back-and-forth is simpler
- **Use loop patrol for open areas** - Circles look more natural
- **Add wait duration for standing guard** - Makes NPCs feel alive
- **Create cover points for combat games** - Gives NPCs strategic positions
- **Test patrol path visually** - Make sure no walls block the route
- **Adjust speed realistically** - 16 studs/sec is normal walking

### Example: Creating a Guard Patrol

1. Select NPC Pathfinding
2. Choose "Linear Patrol"
3. Set Waypoint Count to 4
4. Set Patrol Speed to 16 (walking)
5. Set Wait Duration to 3 (looks around)
6. Click Generate Path
7. Review in preview
8. Click Apply
9. Add script to NPC to follow the path

---

## Script Generation

The Script Generation tool creates starter scripts for common game behaviors.

### How to Use Script Generation

#### Step 1: Select Script Generator
- Click **"Script Gen"** in the left navigation
- Script Generation panel appears

#### Step 2: Choose Script Type

**Server Script**
- Runs on server (game logic)
- Everyone sees the results
- Use for: game mechanics, data
- Example: collect coins

**Client Script**
- Runs on player's computer
- Only that player sees effects
- Use for: UI, animations
- Example: camera effects

**Module Script**
- Reusable code library
- Other scripts can use it
- Use for: shared functions
- Example: math utilities

**GUI Script**
- Controls UI elements
- Runs on client
- Use for: buttons, menus
- Example: pause menu

#### Step 3: Select Script Template

**Common Server Scripts:**
- Health System - Player health management
- Damage Dealer - Weapon/attack system
- Item Collector - Pick up items
- Spawner - Spawn enemies/items
- Checkpoint - Save progress points

**Common Client Scripts:**
- Camera Control - First/third person camera
- Input Handler - Keyboard/mouse input
- Animation Player - Character animation
- GUI Manager - Menu UI control
- Particle Effect - Visual effects

**Common Module Scripts:**
- Math Library - Vector/number utilities
- Config Table - Store game settings
- Utility Functions - Common functions
- Enum Manager - Define game enums

**Common GUI Scripts:**
- Button Handler - Click response
- Text Input - Text box handling
- Menu Manager - Navigation
- Settings Panel - Configuration UI

#### Step 4: Configure Script Settings

**Script Name** (text field)
- What to call the script
- Example: "PlayerHealth"
- Use clear, descriptive names

**Target Location** (dropdown)
- Where to place the script
- Server: ServerScriptService
- Client: StarterPlayer > StarterCharacterScripts
- Shared: ServerStorage

**Include Comments** (toggle)
- ON = detailed comments in code
- OFF = clean code only
- Default: ON (good for learning)

**Code Framework** (dropdown)
- Standard Lua
- OOP (Object-Oriented)
- Functional
- Choose based on preference

#### Step 5: Generate and Review

1. **Click Generate Script**
2. **Code appears in preview**
3. **Review the generated code**
4. **Copy the code**
5. **Paste in Studio**

#### Step 6: Customize the Script

The generated scripts have:
- TODO comments marking areas to edit
- Clear function structure
- Error checking examples
- Usage comments

Find "TODO" in code and fill in:

```lua
-- TODO: Change this function to your game logic
function onPlayerTouched(otherPart)
    -- EDIT THIS: Add your custom behavior
    print("Player touched something!")
end
```

### Common Generated Scripts

#### Health System
```lua
-- Tracks player health
-- Decreases when damaged
-- Dies at 0 health
```

**Where to use:**
- Player character
- Enemies
- Bosses

**Customize by:**
- Changing health values
- Adding health pickup items
- Adding death behavior

#### Input Handler
```lua
-- Listens for keyboard input
-- Triggers actions on key press
-- Works with WASD and mouse
```

**Where to use:**
- Player character
- Vehicle control
- Menu navigation

**Customize by:**
- Adding new key bindings
- Changing input behavior
- Adding input validation

#### Damage Dealer
```lua
-- Deals damage to characters
-- Handles hit detection
-- Shows damage numbers
```

**Where to use:**
- Weapons
- Environmental hazards
- Abilities

**Customize by:**
- Changing damage amount
- Adding knockback
- Adding special effects

### Script Generation Tips

- **Start with templates** - Modify existing code rather than writing from scratch
- **Read the comments** - They explain what each section does
- **Replace TODO sections** - These mark areas you need to customize
- **Test incrementally** - Add one function at a time
- **Use modules for shared code** - Reduces code duplication
- **Keep scripts organized** - Use folders and clear naming

### Example: Creating a Coin Collector

1. Select Script Generator
2. Choose Server Script
3. Select "Item Collector" template
4. Name it "CoinCollector"
5. Enable comments
6. Click Generate Script
7. Copy the code
8. Paste in ServerScriptService
9. Edit TODO sections for coins
10. Test in game

---

## Theme Intelligence

The Theme Intelligence tool analyzes and applies visual themes to your game.

### How to Use Theme Intelligence

#### Step 1: Select Theme Intelligence
- Click **"Theme AI"** in the left navigation
- Theme Analysis panel appears

#### Step 2: Analyze Current Theme

**Click "Analyze Theme"**

This scans your workspace and detects:
- Materials used (plastic, metal, wood, etc.)
- Colors used (RGB values)
- Lighting (brightness, color temperature)
- Overall visual style

**Results show:**
- Detected theme (e.g., "Urban", "Fantasy", "Nature")
- Primary colors found
- Material breakdown (%) 
- Lighting profile

#### Step 3: View Theme Classification

**Detected themes include:**

**Urban Theme**
- Modern, cityscape
- Materials: metal, glass, concrete
- Colors: gray, black, bright accents
- Lighting: bright, blue-white

**Fantasy Theme**
- Medieval, magical
- Materials: wood, stone, leather
- Colors: earthy, gold, purples
- Lighting: warm, torch-like

**Nature Theme**
- Organic, outdoor
- Materials: wood, leaves, stone
- Colors: greens, browns, earth tones
- Lighting: warm, dappled

**Tech Theme**
- Futuristic, sci-fi
- Materials: metal, plastic, neon
- Colors: electric blues, cyans, blacks
- Lighting: cool, bright

**Dark Theme**
- Spooky, horror
- Materials: stone, metal, decaying
- Colors: blacks, reds, grays
- Lighting: dim, flickering

#### Step 4: View Color Palette

The theme analysis shows:
- **Primary Color** - Main color used (30%)
- **Secondary Color** - Supporting color (20%)
- **Accent Color** - Highlight color (10%)
- **Neutral Color** - Balance color (40%)

Each shows RGB values and hex codes.

#### Step 5: Apply Theme Presets

**Click "Apply Preset"** to choose from:

**Preset Options:**
- Keep Current - Use detected theme
- Urban Modern - Apply city theme
- Dark Fantasy - Apply fantasy
- Nature Bright - Apply nature
- Neon Cyber - Apply tech

Applying a preset:
1. **Selects** all objects in region
2. **Changes** materials to match theme
3. **Recolors** parts to theme palette
4. **Adjusts** lighting to match

#### Step 6: Customize Colors

**Manual Color Adjustment:**

1. **Primary Color** - Hex input field
2. **Secondary Color** - Hex input field  
3. **Accent Color** - Hex input field
4. **Click Update** - Changes colors in workspace

#### Step 7: Generate Palette Suggestions

**Click "Generate Suggestions"**

Creates a custom color palette for your theme:
- 5 coordinated colors
- Based on primary color
- Ready to use for parts
- Downloadable as reference

### Theme Intelligence Tips

- **Analyze before customizing** - Know what you have first
- **Use presets as starting point** - Modify rather than create from scratch
- **Keep 3-4 main colors** - Too many colors looks cluttered
- **Use accents sparingly** - Only on important objects
- **Match lighting to theme** - Warm colors need warm light
- **Test on different devices** - Colors may look different

### Theme Color Values

**Urban Colors:**
- Primary: #808080 (gray)
- Secondary: #000000 (black)
- Accent: #00CCFF (cyan)

**Fantasy Colors:**
- Primary: #8B4513 (brown)
- Secondary: #A0826D (tan)
- Accent: #FFD700 (gold)

**Nature Colors:**
- Primary: #228B22 (forest green)
- Secondary: #8B4513 (brown)
- Accent: #FF6347 (tomato red)

**Tech Colors:**
- Primary: #000000 (black)
- Secondary: #1E90FF (blue)
- Accent: #00FF00 (lime green)

### Example: Applying Urban Theme

1. Select Theme Intelligence
2. Click Analyze Theme
3. Current theme shows detected colors
4. Click Apply Preset
5. Choose "Urban Modern"
6. Review changes in workspace
7. Adjust accent color if desired
8. Click Finalize

---

## UI/UX Analysis

The UI/UX Analysis tool checks your GUI elements for accessibility and design best practices.

### How to Use UI/UX Analysis

#### Step 1: Select UI Analyzer
- Click **"UI Analyzer"** in the left navigation
- UI Analysis panel appears

#### Step 2: Select Analysis Mode

**Full Scan**
- Analyzes everything
- Most thorough
- Takes longer
- Shows all issues

**Layout Only**
- Checks positioning
- Checks spacing
- Quick analysis
- Ignores colors

**Contrast Only**
- Checks text readability
- Checks color contrast
- Fast analysis
- Only color issues

#### Step 3: Set Target Device

**Mobile**
- Assumes touch controls
- Checks for 48px touch targets
- Verifies mobile layout
- Tests portrait orientation

**Tablet**
- Assumes touch + stylus
- Checks 40px touch targets
- Verifies responsive layout
- Tests landscape orientation

**Desktop**
- Assumes mouse + keyboard
- Checks 32px target size
- Verifies scrolling layout
- Tests windowed interface

#### Step 4: Configure Suggestions

**Auto Fix** - Toggle ON
- Automatically fixes issues found
- Applies padding, recolors, resizes
- You can undo if you don't like

**Report Only** - Toggle ON
- Just shows issues
- You fix manually
- Good for learning

#### Step 5: Run Analysis

1. **Click "Analyze UI"**
2. **Scanner checks all ScreenGuis**
3. **Results appear in list:**
   - Buttons too small
   - Text not readable
   - Elements misaligned
   - Spacing issues

#### Step 6: Review Issues Found

**Issue Types:**

**Button Size Issues**
- Severity: High
- Fix: Increase button to 48x48 px (mobile)
- Why: Hard to tap on small buttons

**Contrast Issues**
- Severity: High
- Fix: Make text darker or background lighter
- Why: Hard to read low-contrast text

**Alignment Issues**
- Severity: Medium
- Fix: Align elements to grid
- Why: Misaligned UI looks unprofessional

**Spacing Issues**
- Severity: Medium
- Fix: Add padding around elements
- Why: Crowded UI is hard to use

**Missing Labels**
- Severity: Medium
- Fix: Add text labels to buttons
- Why: Users don't know what buttons do

**Mobile Compatibility Issues**
- Severity: High
- Fix: Scale UI for mobile screens
- Why: Text/buttons too small on mobile

#### Step 7: Apply Fixes

For each issue, you can:
1. **Auto-fix** - Let analyzer fix it
2. **Manual fix** - Fix it yourself
3. **Ignore** - Skip this issue

#### Step 8: Verify Results

1. Test in different devices
2. Check that fixes look good
3. Use Undo if unhappy
4. Re-run analysis to confirm

### UI/UX Analysis Tips

- **Analyze early in development** - Easier to fix early
- **Test on actual devices** - Simulators aren't accurate
- **Mobile first approach** - If mobile works, desktop works
- **Keep margins** - 8-16px between elements
- **Large touch targets** - 48px minimum for mobile
- **High contrast text** - Use contrasting colors

### Accessibility Checklist

✅ **Color Contrast**
- Text has 4.5:1 contrast ratio
- White on black: ✅
- Black on white: ✅
- Gray on gray: ❌

✅ **Button Size**
- Mobile: 48x48 px minimum
- Desktop: 32x32 px minimum
- Touch-friendly: larger is better

✅ **Text Size**
- Mobile: 18px minimum
- Desktop: 14px minimum
- Headings: 20px+

✅ **Spacing**
- Between elements: 8px minimum
- Around edge: 16px minimum
- Between sections: 24px+

✅ **Labels**
- All buttons have text
- All inputs have labels
- Icon buttons have tooltips

### Example: Fixing a Mobile UI

1. Select UI Analyzer
2. Set Target Device to "Mobile"
3. Choose "Full Scan"
4. Enable "Auto Fix"
5. Click Analyze UI
6. Issues found:
   - Buttons too small (24x24)
   - Text too small (12px)
   - Text contrast low
7. Click "Apply Fixes"
8. Buttons now 48x48, text 18px
9. Test on mobile device

---

## Tips & Tricks

### Workflow Optimization

**Quick Generate to Undo Cycle**
1. Generate a layout
2. Don't like it? Ctrl+Z to undo
3. Change one setting
4. Generate again
5. Repeat until satisfied

**Combining Multiple Tools**
1. Use Layout Generator to create structure
2. Use Asset Placement to populate
3. Use Performance Analyzer to optimize
4. Use Theme Intelligence for visual consistency
5. Use UI Analyzer for polish

**Working with Large Scenes**
- Analyze regions at a time (not whole workspace)
- Save frequently with Studio's save button
- Use folders to organize generated objects
- Name generated objects for easy finding

**Creating Variations**
- Layout Generator: Change seed number for different layouts
- Asset Placement: Adjust density for variation
- Theme Intelligence: Try different presets
- Script Generation: Copy and modify templates

### Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Undo | Ctrl+Z |
| Redo | Ctrl+Y |
| Save | Ctrl+S |
| Switch tool | Alt + tool number |
| Focus preview | Alt+P |

### Common Mistakes to Avoid

❌ **Too High Density**
- Creates overcrowded scenes
- Performance suffers
- Hard to navigate
- **Fix:** Use 50-60% density instead of 100%

❌ **Ignoring Performance**
- Game lags on mobile
- Players get frustrated
- Optimization harder later
- **Fix:** Analyze often, optimize early

❌ **Not Using Undo**
- Stuck with bad generation
- Have to start over
- Wastes time
- **Fix:** Use Ctrl+Z freely, experiment!

❌ **Wrong Asset Types**
- Structures placed in decorative spots
- Decorations where structures needed
- Clipping through terrain
- **Fix:** Choose correct asset type before generating

❌ **No Preview Review**
- Apply bad generation to workspace
- Cluttered with junk
- Have to clean up manually
- **Fix:** Always review preview before applying!

### Pro Tips

**Tip 1: Use Seeds for Consistency**
When you find a layout you like, write down the seed number. You can recreate it anytime by using the same seed.

**Tip 2: Optimize as You Go**
Don't wait until the end to optimize. Check performance regularly. It's easier to fix early.

**Tip 3: Theme First, Assets Second**
Decide your visual theme before placing assets. Everything will look cohesive.

**Tip 4: Test on Mobile Early**
Mobile is the most restrictive. If it works on mobile, it works everywhere.

**Tip 5: Use Auto-Undo Features**
ForgeAI tracks all operations. Don't be afraid to experiment - you can always undo!

**Tip 6: Combine Generated Content with Manual**
Generated content is a starting point. Add handcrafted details to make scenes unique.

**Tip 7: Create Custom Scripts**
Use Script Generator for boilerplate, then customize heavily. Don't use templates as-is.

### Time-Saving Workflows

**5-Minute Market Setup**
1. Layout Generator (2 min) - Grid layout, 75% density
2. Asset Placement (2 min) - Market zone, 60% density  
3. Done! (1 min) - Review and adjust

**10-Minute Game Area**
1. Layout Generator (2 min) - Choose layout type
2. Asset Placement (3 min) - Add buildings and trees
3. Theme Intelligence (2 min) - Apply theme
4. Performance (2 min) - Optimize and check
5. Done! (1 min) - Final review

**15-Minute Game with NPCs**
1. Layout Generator (3 min) - Create space
2. Asset Placement (3 min) - Add buildings
3. NPC Pathfinding (4 min) - Create patrol paths
4. Script Generation (3 min) - Generate NPC scripts
5. Theme Intelligence (1 min) - Apply theme
6. Done! (1 min) - Final review

---

## Troubleshooting

### General Issues

**"Plugin failed to load"**

**Causes:**
- Folder not in correct location
- Missing files in ForgeAI folder
- Roblox Studio needs restart

**Solutions:**
1. Check folder location is correct
2. Verify all files are present
3. Restart Roblox Studio
4. Reinstall plugin if needed

**"Preview doesn't update"**

**Causes:**
- Preview is not focused
- Camera is zoomed too far out
- GPU issue

**Solutions:**
1. Click in preview area first
2. Use mouse wheel to zoom
3. Restart Studio
4. Update graphics drivers

**"Generated content looks wrong"**

**Causes:**
- Settings not configured correctly
- Workspace has terrain/obstacles
- Part collision enabled where shouldn't be

**Solutions:**
1. Review preview before applying
2. Clear area before generating
3. Adjust density and spacing settings
4. Try different layout type

### Layout Generator Issues

**"Layout too crowded"**

**Causes:**
- Density set too high
- Spacing set too low
- Grid size too small

**Solutions:**
```
Try one of:
- Reduce Density from 80% to 50%
- Increase Spacing from 20 to 30
- Increase Grid Size from 30 to 50
```

**"Layout too sparse"**

**Causes:**
- Density too low
- Spacing too high
- Grid size too large

**Solutions:**
```
Try one of:
- Increase Density from 30% to 70%
- Decrease Spacing from 50 to 30
- Decrease Grid Size from 100 to 50
```

**"Layout has overlapping parts"**

**Causes:**
- Collision detection disabled
- Parts already in that space
- Spacing too low

**Solutions:**
1. Enable Collision Detection
2. Clear the area first
3. Increase Spacing value
4. Use Undo and try again

### Asset Placement Issues

**"Assets placed incorrectly"**

**Causes:**
- Wrong zone type selected
- Spacing set incorrectly
- Area has obstacles

**Solutions:**
1. Choose correct zone type
2. Review preview carefully
3. Clear obstacles in area
4. Adjust spacing if needed

**"Too many assets placed"**

**Causes:**
- Density set too high
- Spacing set too low
- Area too large

**Solutions:**
1. Use Undo
2. Reduce Density to 40%
3. Increase Spacing value
4. Try smaller area

**"Not enough assets placed"**

**Causes:**
- Density too low
- Spacing too high
- Area blocked

**Solutions:**
1. Undo and try again
2. Increase Density to 70%
3. Decrease Spacing value
4. Check for obstacles

### Performance Analysis Issues

**"Analysis takes too long"**

**Causes:**
- Region too large
- Too many parts
- GPU overloaded

**Solutions:**
1. Analyze smaller regions
2. Close other programs
3. Reduce graphics quality
4. Update graphics driver

**"Recommendations don't work"**

**Causes:**
- Already optimized
- Bottleneck elsewhere
- Not the right fix

**Solutions:**
1. Try different optimization
2. Analyze different area
3. Check for scripting bottlenecks
4. Profile with Studio's tools

### NPC Pathfinding Issues

**"NPC gets stuck on obstacles"**

**Causes:**
- Waypoints placed badly
- Obstacles in the way
- Spacing too small

**Solutions:**
1. Increase waypoint spacing
2. Remove obstacles
3. Choose linear patrol instead
4. Use undo and regenerate

**"Patrol path looks weird"**

**Causes:**
- Terrain blocking path
- Settings too aggressive
- Waypoints placed badly

**Solutions:**
1. Preview the path
2. Adjust spacing and count
3. Clear terrain obstacles
4. Try different patrol type

### Script Generation Issues

**"Generated script won't run"**

**Causes:**
- Wrong location
- Missing dependencies
- Syntax error

**Solutions:**
1. Check script is in right location
2. Check for error messages in Output
3. Copy script again, paste carefully
4. Check for TODO markers

**"Script doesn't do what I expect"**

**Causes:**
- Need to customize TODO sections
- Settings not configured
- Game state not set up

**Solutions:**
1. Read through comments
2. Fill in all TODO sections
3. Test with sample setup
4. Debug with print statements

### Theme Intelligence Issues

**"Theme detection wrong"**

**Causes:**
- Not enough consistent materials
- Mixed colors in scene
- Lighting too varied

**Solutions:**
1. Add more objects of one theme
2. Use consistent colors
3. Fix lighting to match theme
4. Manually select theme preset

**"Theme colors look bad"**

**Causes:**
- Palette doesn't match game
- Color values wrong
- Lighting mismatch

**Solutions:**
1. Try different preset
2. Manually set color values
3. Adjust lighting to match
4. Use suggestion palette

### UI/UX Analysis Issues

**"Analysis says issues that aren't issues"**

**Causes:**
- Different design choices
- Analysis too strict
- Mobile vs desktop differences

**Solutions:**
1. Use "Report Only" mode to review
2. Manually fix what matters
3. Set appropriate device target
4. Ignore if acceptable for your game

**"Auto-fix changed things I didn't want"**

**Causes:**
- Auto-fix applied to whole UI
- Settings were too aggressive

**Solutions:**
1. Use Undo (Ctrl+Z)
2. Use "Report Only" instead
3. Manually fix specific issues
4. Review all changes before applying

---

## Quick Reference Guide

### Tool Selection
- **Left Sidebar** - Click tool name to select
- **Tools available:** 7 (Layout, Assets, Perf, NPC, Scripts, Theme, UI)

### Settings Workflow
1. Choose tool from left menu
2. Configure settings in center panel
3. See preview on right side
4. Click Generate/Apply/Analyze button
5. Review results
6. Undo if needed (Ctrl+Z)

### Common Settings
- **Density:** 30-70% (lower = sparse, higher = crowded)
- **Spacing:** 10-50 studs (lower = closer, higher = spread out)
- **Size:** 100-1000 studs (smaller = faster, larger = bigger area)

### Important Buttons
- **Generate:** Create new layout/assets
- **Apply:** Add to workspace
- **Preview:** See 3D preview
- **Analyze:** Check performance/accessibility
- **Update:** Apply color/theme changes

### Keyboard Shortcuts
- **Ctrl+Z:** Undo last action
- **Ctrl+Y:** Redo action
- **Ctrl+S:** Save project

---

## Getting Help

### In-Game Help
- Hover over any setting for tooltip
- Read section headers for descriptions
- Check status bar for feedback

### Documentation
- README.md - Feature overview
- ARCHITECTURE.md - Technical details
- QUICK_REFERENCE.md - Command reference

### Common Questions

**Q: Can I undo everything?**
A: Yes! Use Ctrl+Z to undo any action. Multiple undos work too.

**Q: Will this work on mobile?**
A: Yes! ForgeAI generates mobile-optimized content.

**Q: How do I save my layouts?**
A: Save your place file in Studio (Ctrl+S). Layouts save with it.

**Q: Can I customize generated content?**
A: Absolutely! Generated content is a starting point. Edit freely.

**Q: Does this slow down my game?**
A: ForgeAI helps optimize! Generated content is already efficient.

**Q: How long does generation take?**
A: Most operations take 1-5 seconds. Large regions may take longer.

---

## Support & Feedback

For issues or suggestions:
1. Check this guide first
2. Review troubleshooting section
3. Check documentation files
4. Review generated code comments
5. Experiment with different settings

---

**Version:** 1.0
**Last Updated:** 2026
**Compatible with:** Roblox Studio (all recent versions)
