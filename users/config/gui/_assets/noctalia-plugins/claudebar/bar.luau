local usage = require("./lib/usage.luau")

local REFRESH_MS = 300000
local STALE_NOTE = "\nStale: claudebar could not refresh, showing cached data"

function onUsage(data, message)
  if not data then
    barWidget.setGlyph("brain")
    barWidget.setText("?")
    barWidget.setTooltip(message or "claudebar unavailable")
    return
  end

  barWidget.setGlyph(data.stale and "clock-pause" or "brain")
  barWidget.setText(data.sessionPct .. "% · " .. data.sessionReset)
  barWidget.setTooltip(
    data.plan
      .. "\nSession "
      .. data.sessionPct
      .. "% · resets in "
      .. data.sessionReset
      .. "\nWeekly "
      .. data.weeklyPct
      .. "% · resets in "
      .. data.weeklyReset
      .. (data.stale and STALE_NOTE or "")
  )
end

function update()
  noctalia.setUpdateInterval(REFRESH_MS)
  usage.fetch(onUsage)
end

function onClick()
  noctalia.togglePanel("luuk/claudebar:panel")
end

function onRightClick()
  usage.fetch(onUsage)
end
