--[[---------------------------------------------------------------------------
  Remind people of certain gameplay mechanics and important commands
  Tips are tables containing either colorus or strings
]]-----------------------------------------------------------------------------

local REMINDER = 'reminders'
local JOB = 'reminders_job'

-- database
local reminders = {
  tips = {},
  jobs = {}
}

-- cursors
local instance = {
  tips = {
    group = 1,
    cursors = {}
  },
  job = 1
}

--[[---------------------------------------------------------------------------
  Adds a general tip group
  @param {table} tips
  @return {number} table position
]]-----------------------------------------------------------------------------
function DarkRP.addTipGroup(tips)
  return table.insert(reminders.tips, tips)
end

--[[---------------------------------------------------------------------------
  Adds a group of job related tips
  @param {string|table} job/s
  @param {table} tips
]]-----------------------------------------------------------------------------
function DarkRP.addJobReminders(jobs, tips)
  if type(jobs) == 'table' then
    for _, job in pairs(jobs) do
      reminders.jobs[job] = tips
    end
  else
    reminders.jobs[jobs] = tips
  end
end

--[[---------------------------------------------------------------------------
  Prints a job related tip and moves the cursor
]]-----------------------------------------------------------------------------
local function nextJobReminder()
  local job = LocalPlayer():Team()
  if not reminders.jobs[job] then return end
  if instance.job > #reminders.jobs[job] then
    instance.job = 1
  end
  chat.AddText(unpack(reminders.jobs[job][instance.job]))
  instance.job = instance.job + 1
end

--[[---------------------------------------------------------------------------
  Prints a generic tip and moves the cursor
]]-----------------------------------------------------------------------------
local function nextTip()
  local group = instance.tips.group
  local max_groups = #reminders.tips
  local has_job_tips = false

  -- if it has job tips, increase maximum groups
  if LocalPlayer().Team then has_job_tips = reminders.jobs[LocalPlayer():Team()] end
  if has_job_tips then
    max_groups = max_groups + 1
  else
    -- if jobs were changed before a job tip appears, reset it to 1
    if group > #reminders.tips then
      group = 1
    end
  end

  -- last but not least, give a job tip
  if group > #reminders.tips and has_job_tips then
    nextJobReminder()
  else
    -- create cursor (if missing)
    if not instance.tips.cursors[group] then
      instance.tips.cursors[group] = 1
    end

    -- print message
    local tip = instance.tips.cursors[group]
    chat.AddText(unpack(reminders.tips[group][tip]))

    -- move tip cursor
    if tip + 1 > #reminders.tips[group] then
      instance.tips.cursors[group] = 1
    else
      instance.tips.cursors[group] = tip + 1
    end
  end

  -- move group cursor
  if instance.tips.group + 1 > max_groups then
    instance.tips.group = 1
  else
    instance.tips.group = group + 1
  end
end

--[[---------------------------------------------------------------------------
  Start generic tips timer
]]-----------------------------------------------------------------------------
timer.Create(REMINDER, GAMEMODE.Config.tipFrequency, 0, nextTip)
