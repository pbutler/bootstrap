local layout = {}

function layout.arrangeCommDesktop()
  local adium = hs.appfinder.appFromName("Adium")
  local slack = hs.appfinder.appFromName("Slack")
  local contacts = adium:findWindow("Contacts")
  local adium_msgs = adium:findWindow("[^C][^o][^n]")
  local slackw = slack:allWindows()[1]

  layout.setupWindow(slackw, 0, 0, 4, 6)
  layout.setupWindow(contacts, 4, 0, 2, 3)
  layout.setupWindow(adium_msgs, 4, 3, 2, 3)
end

function layout.setupWindow(win, x, y, w, h)
  local screen = win:screen()
  -- cell = hs.grid.get(win, screen)
  cell = {
    x=x,
    y=y,
    w=w,
    h=h
  }
  hs.grid.set(win, cell, screen)
end

layout.watcher = hs.screen.watcher.newWithActiveScreen(function ()
  layout.arrangeCommDesktop()
end):start()

return layout
