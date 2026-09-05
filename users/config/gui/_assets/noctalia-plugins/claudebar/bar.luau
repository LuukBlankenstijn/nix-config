local usage = require("./lib/usage.luau")

local REFRESH_MS = 60000

function onUsage(data, message)
  if not data then
    barWidget.setText("?")
    barWidget.setTooltip(message or "claudebar unavailable")
    return
  end

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
  )
end

function update()
  noctalia.setUpdateInterval(REFRESH_MS)
  barWidget.setGlyph("brain")
  usage.fetch(onUsage)
end

function onClick()
  noctalia.togglePanel("luuk/claudebar:panel")
end

function onRightClick()
  usage.fetch(onUsage)
end
