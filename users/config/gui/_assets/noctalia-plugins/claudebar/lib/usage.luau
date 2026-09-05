local M = {}

local ARGV = {
  "claudebar",
  "--format",
  "{plan}|{session_pct}|{session_reset}|{session_elapsed}|{weekly_pct}|{weekly_reset}|{weekly_elapsed}",
}

local function stripMarkup(text)
  return (string.gsub(text or "", "<[^>]*>", ""))
end

local function split(text)
  local fields = {}
  local start = 1

  while true do
    local sep = string.find(text, "|", start, true)
    if not sep then
      table.insert(fields, string.sub(text, start))
      break
    end
    table.insert(fields, string.sub(text, start, sep - 1))
    start = sep + 1
  end

  return fields
end

function M.fetch(callback)
  noctalia.runAsync(ARGV, function(result)
    if not result or result.exitCode ~= 0 then
      callback(nil, "claudebar exited with an error")
      return
    end

    local decoded = noctalia.json.decode(result.stdout)
    if not decoded or not decoded.text then
      callback(nil, "claudebar returned no usable output")
      return
    end

    local fields = split(stripMarkup(decoded.text))
    if #fields < 7 then
      callback(nil, "claudebar returned " .. #fields .. " fields, expected 7")
      return
    end

    callback({
      plan = fields[1],
      sessionPct = tonumber(fields[2]) or 0,
      sessionReset = fields[3],
      sessionElapsed = tonumber(fields[4]) or 0,
      weeklyPct = tonumber(fields[5]) or 0,
      weeklyReset = fields[6],
      weeklyElapsed = tonumber(fields[7]) or 0,
    })
  end)
end

return M
