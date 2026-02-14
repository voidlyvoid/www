# ForgeAI - Professional Roblox Studio Plugin

A professional-grade world-building, optimization, and generation system for Roblox developers. ForgeAI combines procedural generation, intelligent optimization, performance analysis, and theme learning into a single, cohesive plugin.

## Overview

ForgeAI is designed for serious game studios and advanced developers who need:

- **Procedural Layout Generation** - Grid, organic, and modular layouts with collision-aware placement
- **Intelligent Asset Placement** - Context-aware decoration and asset distribution with performance budgeting
- **Performance Analysis & Optimization** - Real-time metrics, bottleneck detection, and auto-optimization suggestions
- **NPC Path Generation** - Patrol routes, interaction zones, and coverage analysis
- **Script Generation** - Auto-generate clean, production-ready Lua scripts from specifications
- **Theme Analysis & Synthesis** - Detect themes, suggest color palettes, and apply visual themes
- **UI/UX Analysis** - Analyze ScreenGuis for accessibility, mobile compatibility, and contrast

## Architecture

```
ForgeAI/
├── PluginMain.lua           # Plugin entry point and lifecycle management
├── UI/
│   ├── AppRoot.lua          # Main UI container and layout
│   ├── MetricsDashboard.lua # Performance metrics display
│   ├── OptimizationPanel.lua# Optimization controls
│   ├── PromptEditor.lua     # Generation prompt editor
│   ├── NavigationPanel.lua  # Left sidebar navigation
│   ├── PreviewViewport.lua  # 3D preview rendering
│   ├── ThemePanel.lua       # Theme analysis UI
│   ├── NPCPanel.lua         # NPC configuration
│   └── ScriptGeneratorPanel.lua # Script gen interface
├── Core/
│   ├── LayoutEngine.lua     # Grid, organic, modular layouts
│   ├── AssetIntelligence.lua# Asset placement & zone analysis
│   ├── PerformanceAnalyzer.lua # Metrics & bottleneck detection
│   ├── OptimizationEngine.lua # Auto-optimization application
│   ├── PathfindingEngine.lua # NPC routes & interaction zones
│   ├── ScriptFactory.lua    # Script generation
│   ├── ThemeAnalyzer.lua    # Material/color/lighting analysis
│   └── UIAnalyzer.lua       # ScreenGui accessibility checking
├── Data/
│   ├── LayoutPresets.lua    # Pre-configured layouts
│   ├── ThemePresets.lua     # Color palettes & themes
│   └── OptimizationRules.lua# Optimization strategies
├── Utils/
│   ├── Metrics.lua          # Performance measurement
│   ├── SceneScanner.lua     # Workspace hierarchy analysis
│   ├── GeometryUtils.lua    # Spatial calculations
│   ├── Validator.lua        # Input validation
│   └── UndoManager.lua      # Undo/redo integration
└── README.md                # This file
```

## Core Systems

### 1. Layout Generation Engine
Generates structured world layouts with multiple strategies:
- **Grid**: Regular, organized grid-based layouts
- **Organic**: Natural, flowing layouts with coherent randomness
- **Modular**: Flexible modular building blocks

**Key Features:**
- Collision-aware placement
- Semantic zone classification
- Deterministic generation (seed support)
- Path generation between zones

### 2. Asset Intelligence System
Intelligent asset placement and distribution:
- Zone identification from structural elements
- Context-aware asset suggestions
- Performance budget management
- Distribution planning (even/random spacing)

### 3. Performance Analysis & Optimization
Real-time performance metrics and auto-optimization:
- Part count, mesh density, lighting cost tracking
- Automatic bottleneck identification
- LOD suggestions
- Mesh conversion recommendations
- One-click optimization with dry-run preview

**Metrics Tracked:**
- Part count & mesh distribution
- Physics load calculation
- Shadow-casting cost
- Particle emitter count
- Device impact (Mobile/PC)

### 4. Pathfinding & NPC Systems
Route generation and interaction zone placement:
- Patrol path generation (loop/linear)
- Walkable surface detection
- Cover & hide point identification
- Interaction zone placement
- Coverage calculation

### 5. Script Generation Factory
Auto-generates production-ready Lua scripts:
- Server scripts with player handling
- Client scripts with input management
- Modules with OOP patterns
- UI templates
- Best practices enforced

### 6. Theme Analysis & Application
Visual theme detection and suggestion:
- Material and color analysis
- Lighting profile detection
- Theme classification (urban/nature/tech/fantasy)
- Color palette suggestions
- Theme application

### 7. UI/UX Analyzer
ScreenGui accessibility and optimization:
- Contrast ratio checking (WCAG compliance)
- Mobile responsiveness analysis
- Touch target size validation
- Accessibility label checking
- AutoLayout recommendations

## Usage Examples

### Generate a Layout

```lua
local LayoutEngine = require(script.Parent.Core.LayoutEngine)

local layout = LayoutEngine.generateLayout({
    center = workspace.SpawnLocation.Position,
    width = 200,
    depth = 200,
    type = "grid",
    spacing = 50,
    density = 0.6
})

print("Generated " .. #layout.zones .. " zones")
```

### Analyze Performance

```lua
local PerformanceAnalyzer = require(script.Parent.Core.PerformanceAnalyzer)

local analysis = PerformanceAnalyzer.analyzeScene(workspace.MyRegion)

print("Complexity Score: " .. analysis.metrics.complexityScore)
print("Bottlenecks: " .. #analysis.bottlenecks)
for _, rec in ipairs(analysis.recommendations) do
    print("- " .. rec.action)
end
```

### Generate Scripts

```lua
local ScriptFactory = require(script.Parent.Core.ScriptFactory)

local script = ScriptFactory.generateFromSpec({
    name = "PlayerManager",
    type = "server"
})

print(script.content)
```

### Analyze Theme

```lua
local ThemeAnalyzer = require(script.Parent.Core.ThemeAnalyzer)

local theme = ThemeAnalyzer.analyzeTheme(workspace.MyRegion)

print("Detected Style: " .. theme.detectedStyle)
for _, material in ipairs(theme.dominantMaterials) do
    print("- " .. material.name)
end
```

## Configuration & Presets

ForgeAI comes with pre-configured presets:

- **Layout Presets**: Common layout templates (marketplace, residential, industrial)
- **Theme Presets**: Color palettes (urban, nature, tech, fantasy)
- **Optimization Rules**: Performance targets (mobile-friendly, high-performance, balanced)

## Undo/Redo Support

All operations integrate with Roblox's ChangeHistoryService:

```lua
local UndoManager = require(script.Parent.Utils.UndoManager)

UndoManager.beginOperation("Generate Level Layout")
-- ... generate layout ...
UndoManager.endOperation()

-- Users can now undo with Ctrl+Z
```

## Performance Considerations

- **Cached Scene Analysis**: Workspace scans are cached for 5 seconds
- **Lazy Loading**: UI panels load on demand
- **Optimized Loops**: Spatial queries use efficient algorithms
- **Non-blocking Operations**: Long operations use coroutines

## Best Practices

1. **Always use dry-run mode** before applying optimizations
2. **Use performance budgets** when placing assets in large scenes
3. **Set seeds for reproducible generation** when needed
4. **Validate inputs** with the Validator utility
5. **Use undo operations** for all destructive changes

## Future Integration

ForgeAI is designed for future AI backend integration:
- JSON specification format for AI-generated layouts
- Deterministic execution for reproducibility
- Safe sandboxing of generated content
- Modular architecture for extension

## Contributing

ForgeAI is modular and extensible. To add new systems:

1. Create a new module in `/Core/`
2. Follow the existing API patterns
3. Use Validator for input checking
4. Integrate with UndoManager for changes
5. Document public methods

## License

ForgeAI - Professional Roblox Studio Plugin
Created for advanced game development workflows

## Support

For issues, questions, or feature requests, refer to the inline code documentation in each module.

## Repository Cleanup

The following internal documentation and verification files were removed from this distribution to reduce client-visible clutter:

- ARCHITECTURE.md
- COMPREHENSIVE_AUDIT.md
- COMPLETION_STATUS.md
- INTEGRATION_TEST.md
- PROJECT_SUMMARY.md
- QUICK_REFERENCE.md
- VERIFICATION_CHECKLIST.md
- VALIDATION_COMPLETE.txt

If you need these files restored or require access to internal artifacts, contact the maintainers.

---

**ForgeAI** - Building better worlds, faster.
