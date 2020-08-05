hyper:bind({}, "l", function()
  hs.caffeinate.startScreensaver()
  hyper.triggered = true
end)

local caffeine = nil
function setCaffeineDisplay(state)
    if state then
        if not caffeine then
            caffeine = hs.menubar.new()
        end
        caffeine:setTitle("☕️")
        caffeine:setClickCallback(caffeineClicked)
        --caffeine:setTitle("AWAKE")
	-- caffeine:setIcon(ampOnIcon)
    else
        if caffeine then
            caffeine:delete()
	    caffeine = nil
        end
        -- caffeine:setTitle("SLEEPY")
	-- caffeine:setIcon(ampOffIcon)
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end
hyper:bind({}, "c", caffeineClicked)
