local layout = {}

function layout.arrangeCommDesktop()
  local adium = hs.appfinder.appFromName("Adium")
  local slack = hs.appfinder.appFromName("Slack")
  local contacts = adium:findWindow("Contacts")
  local slackw = slack:mainWindow()


  layout.setupWindow(slackw, 0, 0, 4, 6)
  layout.setupWindow(contacts, 4, 0, 2, 3)

  local wf = hs.window.filter
  local awindows = hs.window.filter.new("Adium")
  for i, window in ipairs(awindows:getWindows()) do
    if contacts:id() ~= window:id() then
      local screen1 = findScreen(contacts)
      local screen2 = findScreen(window)
      if screen1:id() ~= screen2:id() then
        print("jumping")
        window:setFrame(contacts:frame())
      end

      layout.setupWindow(window, 4, 3, 2, 3)
      end
  end
end

function findScreen(window)
  local wrect = window:frame()
  for i, screen in ipairs(hs.screen.allScreens()) do
    local srect = screen:frame()
    if wrect:inside(srect) then
      return screen
    end
  end
  wrect = hs.geometry(wrect.x1, wrect.x2)
  for i, screen in ipairs(hs.screen.allScreens()) do
    srect = screen:frame()
    if wrect:inside(srect) then
      return screen
    end
  end
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

layout.watcher = hs.screen.watcher.newWithActiveScreen(function (newScreen)
  layout.arrangeCommDesktop()
end):start()

return layout
