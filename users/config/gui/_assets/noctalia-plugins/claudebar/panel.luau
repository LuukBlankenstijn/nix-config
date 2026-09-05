local usage = require("./lib/usage.luau")

local data = nil
local failure = nil

local function severity(pct)
  if pct >= 90 then
    return "error"
  elseif pct >= 75 then
    return "secondary"
  end
  return "primary"
end

local function meter(title, pct, elapsed, reset)
  local color = severity(pct)

  return ui.column({ gap = 6 }, {
    ui.row({ gap = 8, align = "center" }, {
      ui.label({ text = title, fontWeight = "bold" }),
      ui.spacer({ flexGrow = 1 }),
      ui.label({ text = pct .. "%", fontWeight = "bold", color = color }),
    }),
    ui.progress({ progress = pct / 100, fill = color, height = 8, radius = 4 }),
    ui.row({ gap = 8, align = "center" }, {
      ui.label({ text = "resets in " .. reset, fontSize = 12, color = "on_surface_variant" }),
      ui.spacer({ flexGrow = 1 }),
      ui.label({ text = elapsed .. "% elapsed", fontSize = 12, color = "on_surface_variant" }),
    }),
  })
end

local function render()
  if failure then
    panel.render(ui.column({ gap = 12, padding = 16 }, {
      ui.label({ text = "Claude usage", fontWeight = "bold" }),
      ui.label({ text = failure, color = "error" }),
      ui.button({ text = "Retry", variant = "primary", onClick = "onRefresh" }),
    }))
    return
  end

  if not data then
    panel.render(ui.column({ gap = 12, padding = 16 }, {
      ui.label({ text = "Claude usage", fontWeight = "bold" }),
      ui.label({ text = "Loading…", color = "on_surface_variant" }),
    }))
    return
  end

  panel.render(ui.column({ gap = 14, padding = 16 }, {
    ui.row({ gap = 8, align = "center" }, {
      ui.glyph({ name = "brain", size = 18 }),
      ui.label({ text = data.plan, fontWeight = "bold" }),
    }),
    ui.separator({}),
    meter("Session", data.sessionPct, data.sessionElapsed, data.sessionReset),
    meter("Weekly", data.weeklyPct, data.weeklyElapsed, data.weeklyReset),
    ui.row({ align = "center" }, {
      ui.spacer({ flexGrow = 1 }),
      ui.button({ text = "Refresh", variant = "outline", controlSize = "sm", onClick = "onRefresh" }),
    }),
  }))
end

local function load()
  usage.fetch(function(result, message)
    data = result
    failure = message
    render()
  end)
end

function onRefresh()
  load()
end

function onOpen()
  render()
  load()
end
