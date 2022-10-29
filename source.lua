--[[ 
FTUE objectives screen

This lua code gives a list of objectives for the player after they have finished the outpost/speeder FTUE

--]]

-----------------------------------------------------------------------
-- Descriptions
-- local TXT_GOTOMARKET = "A number of market locations are scattered across the surface of Haven. Use the map to locate and then visit one. \n\nOpen your map (F4) and find the nearest M icon or Building icon.  \nSet it as a destination and head over.  \n\nThere is even a very cheap starter pack of materials for you to pick up!"




local wrap = require('rslib').getTextWrapped
local cos, sin, min, max = math.cos, math.sin, math.min, math.max

local print = function(txt, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
  logMessage(string.format(txt, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12))
end


if not _localization then
  _localization = {
    ['STANDBY'] = {
      touch2Launch = "Click on the screen to start.",
      playerName = "ANONYMOUS",
      subTitle = "GREETINGS %s!",
      title = "PERSONAL OBJECTIVES ASSISTANT MANAGER",
      touchMe = "CLICK ME",
      description = "Get practical objectives to discover the world, based on your personal interests."
    },
    ['HOME'] = {
      playerName = [[<PLAYERNAME>]],
      title = "PICK TODAY'S OBJECTIVE",
      subTitle = "PERSONAL OBJECTIVES ASSISTANT MANAGER",
      tooltip = "Click on a category above to show objectives.",
      categories = "CATEGORIES:",
      back = "Back",
      menus = {
        { name = "EXPLORE",
          icon = { path = 'gui/screen_unit/img/decals/icon_planet2.png', width = 224, height = 224 }, page = 'EXPLORE' },
        { name = "IMPROVE",
          icon = { path = 'gui/screen_unit/img/decals/icon_talents.png', width = 224, height = 224 }, page = 'IMPROVE' },
        { name = "HARVEST",
          icon = { path = 'gui/screen_unit/img/decals/icon_mining.png', width = 209, height = 244 }, page = 'HARVEST' },
        { name = "CRAFTING",
          icon = { path = 'gui/screen_unit/img/decals/icon_crafting.png', width = 224, height = 224 }, page = 'CRAFTING' },
        { name = "MAKE\nMONEY",
          icon = { path = 'gui/screen_unit/img/decals/icon_money.png', width = 224, height = 224 }, page = 'MONEY' },
        { name = "BUILDING",
          icon = { path = 'gui/screen_unit/img/decals/icon_building.png', width = 150, height = 150 }, page = 'BUILDING' },
        { name = "PILOTING",
          icon = { path = 'gui/screen_unit/img/decals/icon_piloting.png', width = 224, height = 224 }, page = 'PILOTING' },
        { name = "SOCIAL",
          icon = { path = 'gui/screen_unit/img/decals/icon_social.png', width = 224, height = 224 }, page = 'SOCIAL' }
      }
    },
    ['OBJECTIVES'] = {
      separator = ',',
      back = "Back",
      objectivesTitle = "OBJECTIVES:",
      description = "DESCRIPTION:",
      subTitle = "PERSONAL OBJECTIVES ASSISTANT MANAGER",
      tooltip = "Choose an objective to show its details then click on the 'Let's DU it!'' button to initiate it.",
      duIt = "Let's DU it!",
      reduIt = "Let's reDU it!"
    },
    ['EXPLORE'] = {
      title = "EXPLORE",
      objectives = {
        { title = "GO TO A MARKET", desc = "A number of market locations are scattered across the surface of Haven. Use the map to locate and then visit one. \n\nOpen your map (F4) and find the nearest M icon or Building icon.  \nSet it as a destination and head over.  \n\nThere is even a very cheap starter pack of materials for you to pick up!", done = 0,
          trigger = "go_to_market", duItButton = 0 },
        { title = "TAKE A SHUTTLE TO ALIOTH", desc = "Travel between planets is impossible without a ship. A shuttle service is provided on some worlds, including Haven. \nGo To a Haven District Market and take a shuttle to Alioth. \n\nOpen your map (F4) and find the nearest Building icon.  \nGo there and take a shuttle to Alioth.", done = 0,
          trigger = "shuttle_to_alioth", duItButton = 0 },
        { title = "VISIT THE INSTITUTES", desc = "The Institutes are located right next to our Arkship, with an unsurpassed view of this beautiful technological marvel. \nThe Institute buildings are filled with information and objects essential to life on these new worlds. A virtual museum of our current knowledge. \nGo To Alioth and visit the Institutes. \n\nGo to Alioth as described in the previous objective, then use a teleporter to go to the institutes.  \nOr fly there directly.",
          done = 0, trigger = "visit_institutes", duItButton = 0},
        { title = "VISIT THE AEGIS", desc = "Located between worlds in the vacuum of space is the Aegis space Market. Take a space capable vehicle (Or get a ride from someone who has a space capable vehicle) and explore the Aegis. \n\nBuy a spaceworthy ship, use the map (F4) to set a destination on the Aegis, and head on over", done = 0,
          trigger = "visit_aegis", duItButton = 0 }
      }
    },
    ['IMPROVE'] = {
      title = "IMPROVE",
      objectives = {
        { title = "TALENTS", desc = "Mini-tutorial: \nNearly everything you can do is improved by upgrading your abilities known as Talents. \n2 out of 3 experienced Noveans insist that Talents are extremely important to learn.\n\nChoose a Talent you would like to improve and begin researching to train and improve that ability. ", done = 0,
          trigger = "talents", duItButton = 1 },
        { title = "FLASHLIGHT", desc = "IS IT TOO DARK?   \nPress  L  to activate the flashlight.   \n\nDo it.   Try it.    \n\nL   \n\nThen go outside.  Or turn off a light.  \nYou're welcome. ", done = 0,
          trigger = "flashlight", duItButton = 0 },
        { title = "CHAT", desc = "FEELING LOST or LONELY?  \n\nPress -Enter- to open the chat window.  \n\nDon't be shy.  Noveans are a chatty bunch.\n\nIf you have a problem, you can ask for help on the Help channel.", done = 0, trigger = "chat", duItButton = 0 }
      }
    },
    ['HARVEST'] = {
      title = "HARVEST",
      objectives = {
        { title = "SURFACE GATHERING", desc = "Tutorial \nHarvesting material is one of the first steps in crafting items that you will need. \n\nPress the button to take the Harvesting tutorial in the VR Surrogate Station.",
          done = 0, trigger = "surface_gathering", duItButton = 1 },
        { title = "SCAVENGE YOUR LANDER", desc = "Your Lander delivered you safely to the surface of a new world and it has one more chance to be useful. \nRecuperate material from your Lander by first repairing, then dismantling it.    \n\nGo to your lander, enter build mode and start removing material.  \nTake the VR construction tutorial first to see how.",
          done = 0, trigger = "scavenge_lander", duItButton = 0 },
        { title = "MINING UNIT CALIBRATION", desc = "Mining Units are an important and convenient way to gather much needed resources. But Mining Units must be well calibrated to function at peak performance.  \nCalibration will also extract a big chunk of ore for you. \n\nGo to your Mining Unit, open its HUD and hit calibrate.  \nThere are many pop ups to guide you.", done = 0,
          trigger = "mining_unit", duItButton = 0 }
      }
    },
    ['CRAFTING'] = {
      title = "CRAFTING",
      objectives = {
        { title = "CRAFT NITRON", desc = "Mini-tutorial\nLearn how to craft nitron to fuel your vehicles. \n\nPress K to open your Nanocrafter, find Nitron and see what you need to craft it.  \nHarvest those ores and then try your hand at crafting that most important fuel.", done = 0,
          trigger = "craft_nitron", duItButton = 0 },
        { title = "CRAFT SCRAP", desc = "Mini-tutorial\nHave you broken your Speeder? Does your Lander have a broken element?  Repair it using scrap!  Learn how to craft scrap to repair your vehicles. \n\nKnow that any ore can be made into scrap.  \nCollect some ore, press K to open the Nanocrafter, find the approprate scrap type, and craft away!", done = 0,
          trigger = "craft_scrap", duItButton = 0 },
        { title = "CRAFT AN ELEMENT", desc = "Mini-tutorial \nLearn how to craft an element. \n\nDecide what element you want to build.  \nMaybe wings for your speeder?  \n\nPress K to open the Nanocrafter, search for the element, and poke around to see what you need to collect to build it.  Then build that sucker!", done = 0,
          trigger = "craft_element", duItButton = 0 },
        { title = "INDUSTRY", desc = "Tutorial\nKnowing how to use your Nanocrafter and how to use industry elements is essential to successful crafting. \n\nPress the button to take the Industry tutorial in the VR Surrogate Station.", done = 0,
          trigger = "industry_tutorial", duItButton = 1 }
      }
    },
    ['MONEY'] = {
      title = "MAKE\nMONEY",
      objectives = {
        { title = "SELL YOUR GOODS", desc = "Mini-tutorial: \nOne of the most basic ways to make money is to sell things on the market. \nUse your map to locate a Market (M icon or Building icon), travel there and sell something. \n\nGrab some ore or something you have crafted, and fly to the nearest market.  \nUse the market pod to create a sell order of what you brought with you.", done = 0,
          trigger = "sell_market", duItButton = 0 },
        { title = "MARKET TUTORIAL", desc = "VR Tutorial:\nSuccessfully selling items at a Market requires a knowledge of how the Market system works.  \n\nPress the button to take the Market Introduction tutorial at the VR Surrogate Station.", done = 0,
          trigger = "market_tutorial", duItButton = 1 },
        { title = "APHELIA MISSIONS", desc = "Mini-tutorial: \nAphelia offers missions that can be completed for Quanta. This is an alternate avenue to generate revenue. \nComplete an Aphelia mission and earn some Quanta.  \n\nOpen the Mission Menu (F8) and search for nearby Aphelia missions.",
          done = 0, trigger = "aphelia_missions", duItButton = 0 },
        { title = "CHALLENGE", desc = "Challenges are another way to earn Quanta.  The payout is good, and they are a great way to practice in a safe environment. \n\nPress the button to find out how to take a Challenge at the VR Surrogate Station", done = 0,
          trigger = "take_challenge", duItButton = 1 }
      }
    },
    ['BUILDING'] = {
      title = "BUILDING",
      objectives = {
        { title = "BUILD MODE", desc = "VR Tutorial\nBuilding your own constructs is a core component of surviving in this new solar system. \nBuilding may seem like a daunting task but a quick tutorial will show how easy it can be. \n\nPress the button to take the Construction tutorial in the VR Surrogate Station.", done = 0,
          trigger = "construction_tutorial", duItButton = 1 },
        { title = "MODIFY YOUR SPEEDER", desc = "The speeder that you received when you arrived can be modified to act as a flying vehicle instead of only a hover vehicle. \nLearn to modify your speeder so it can fly.  \n\nPress the button to take the Starting Speeder Modification tutorial in the VR Surrogate Station.", done = 0,
          trigger = "speeder_upgrade", duItButton = 1 },
        { title = "COMPACTIFICATION", desc = "Mini-tutorial \nSome dynamic constructs such as ships and speeders can be “compacted”, allowing you to take them with you wherever you go. \nLearn about pocket ships and how to compact them. \n\nPoint your reticle at your speeder, right-click and select Construct Compactification.  Now your speeder is a magic blueprint in your inventory.",
          done = 0, trigger = "compactification", duItButton = 0 }
      }
    },
    ['PILOTING'] = {
      title = "PILOTING",
      objectives = {
        { title = "GROUND VEHICLES", desc = "VR Tutorial\nThe vast distances spanning the surface of a planet would  be very time consuming to traverse without vehicles.\nThe speeder you received when you arrived is considered a 'ground vehicle'. \n\nPress the button to learn how to better pilot it by taking a VR tutorial.",
          done = 0, trigger = "surface_piloting", duItButton = 1 },
        { title = "ATMOSPHERIC VEHICLES", desc = "VR Tutorial\nFew things compare to the thrill of soaring through the atmosphere, lifted by winds and powerful thrusters. \nThere are also few things worse than landing nose first and waking up in a respawn chamber and having weeks worth of work scattered across the countryside. \n\nTo avoid this, learning to pilot atmospheric vehicles is essential.\nPress the button to take the Atmospheric Piloting tutorial in the VR Surrogate Station.", done = 0,
          trigger = "atmospheric_piloting", duItButton = 1 },
        { title = "GUNNERY", desc = "VR Tutorial\nOnce you manage to learn to fly a ship without crashing, someone is inevitably going to try to 'crash' your ship for you, by filling it with massive holes using hi tech long range weapons. \nEnsure sure you have the knowledge and skills to protect yourself by taking a Gunnery tutorial.\n\nPress the button to take the Gunnery tutorial in the VR Surrogate Station.", done = 0,
          trigger = "gunnery", duItButton = 1 }
      }
    },
    ['SOCIAL'] = {
      title = "SOCIAL",
      objectives = {
        { title = "VISITORS WELCOME", desc = "Mini-tutorial\nLearn about the Visitors Welcome territory flag.  \n\nIf you want people to come visit your territory, press F4 to open the map, right click on your territory and select Declare Visitors Territory",
          done = 0, trigger = "visitors_welcome", duItButton = 0 },
        { title = "FRIEND REQUESTS", desc = "Mini-tutorial\nSend and receive friend requests.   \n\nHave you met another player?  Use the Contacts menu to connect with them.", done = 0,
          trigger = "friend_requests", duItButton = 0 },
        { title = "MISSIONS", desc = "Mini-tutorial\nLearn about player made missions and the Mission Forums.   \n\nOpen the Missions menu and browse the Job Forum.  Maybe something will catch you eye.  \nBE WARY, someone might want to take advantage of you.", done = 0,
          trigger = "player_missions", duItButton = 0 },
        { title = "ORGANISATIONS", desc = "Mini-tutorial\nFind and join an organisation.   \n\nOpen the Organisations menu (F3) and browse other Novean's orgs.  \nSome are extremely friendly.  Some might not be friendly.  \n\nHave fun, but be careful.   \nNEVER give other players open permissions (RDMS) to your constructs or territory unless you trust them.  Only pirates ask you for that.", done = 0,
          trigger = "organisations", duItButton = 0 },
        { title = "RDMS", desc = "Mini-tutorial\nAt some point you may wish to give others the rights to build in your territories or interact with the functional parts of your constructions. \nNo need to lock your doors, no one can open them but you. \nLikewise no one can sit in your favorite chair, unless you have specifically given the permissions or “rights” to do so. \nTo learn how to set these rights, take the tutorial at the VR Surrogate Station.", done = 0,
          trigger = "rdms_tutorial", duItButton = 0 }
      }
    },
  }
end


if not _init then

  function getEllipsis(font, text, maxWidth)
    local ellipisWidth = getTextBounds(font, '...')

    for i = 1, #text do
      local line = getTextBounds(font, text:sub(1, i)) + ellipisWidth
      if line > maxWidth then
        return text:sub(1, i - 1) .. '...'
      end
    end
    return text
  end

  function getFormat(number, sep)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1" .. sep)
    return minus .. int:reverse():gsub("^.", "") .. fraction
  end

  --#################################
  function Initialize()
    if _init then return end

    if not _menu then
      logMessage("WARNING : No '_menu' globals defined,set as default 'STANDBY'.")
      _menu = 'STANDBY'
      _page = nil
    end

    _loc = {}
    for key, dict in pairs(_localization) do
      if key == _menu or key == _page then

        for str, field in pairs(dict) do
          _loc[str] = field
        end
      end
    end


    if _menu == 'HOME' then
      _tooltip = _loc.tooltip
      _selected = 0
    elseif _menu == 'OBJECTIVES' then
      _selected = 1
      _scrollLeft = 0
      _scrollRight = 0
    end


    _init = true
  end

  --#################################
  function Compute()
    local rx, ry = getResolution()
    local mx, my = getCursor()
    local debug = createLayer()

    local dt = getDeltaTime()
    local released = getCursorReleased()

    setDefaultStrokeColor(debug, Shape_Line, 1, 0, 0, 0.75)

    requestAnimationFrame(1)
    if _menu == 'STANDBY' then
      if released then
        _menu = 'HOME'
        _page = nil
        _init = false
      end

      requestAnimationFrame(12)
    elseif _menu == 'HOME' then
      local small = loadFont('Play', 14)

      _tooltip = _loc.tooltip
      _selected = 0
      _hover = 0
      _page = nil

      if my > 177.5 and my < 452.5 then
        local menusSize = #_loc.menus
        for k, p in pairs(_loc.menus) do
          local x = rx / 2 - 119 * (menusSize - 1) / 2 + (k - 1) * 119

          if (mx > x - 57.5 and mx < x + 57.5) then
            _hover = k
            if p.tip then _tooltip = p.tip end

            if released then
              _menu = 'OBJECTIVES'
              _page = p.page
              _init = false
            end
          end
        end

      elseif my > 530 and my < 560 then

        local backWidth = getTextBounds(small, '< ' .. _loc.back)
        backWidth = min(240, backWidth) + 32

        if (mx > 39 and mx < 39 + backWidth) then
          _hover = -3

          if released then
            _menu = 'STANDBY'
            _page = nil
            _init = false
          end
        end

      end

      requestAnimationFrame(1)
    elseif _menu == 'OBJECTIVES' then
      _hover = 0

      local o = _loc.objectives[_selected]
      local small = loadFont('Play', 14)
      local big = loadFont('Play', 38)

      local count = #_loc.objectives

      if my > 46 and my < 78 then
        local titleWidth = getTextBounds(big, _loc.title)
        local subtitleWidth = getTextBounds(small, _loc.subTitle)
        local x = max(subtitleWidth, titleWidth) + 84

        local id = 1
        for k, m in pairs(_localization['HOME'].menus) do
          if m.page == _page then
            id = k
            break
          end
        end

        if mx > 22 and mx < 54 and released then
          _menu = 'OBJECTIVES'
          _page = _localization['HOME'].menus[id == 1 and #_localization['HOME'].menus or id - 1].page
          _init = false
        elseif mx > x and mx < x + 32 and released then
          _menu = 'OBJECTIVES'
          _page = _localization['HOME'].menus[id == #_localization['HOME'].menus and 1 or id + 1].page
          _init = false
        end

      elseif (mx > 41 and mx < 322) and (my > 150 and my < 486) then

        if count > 9 then
          if my < 250 then
            _scrollLeft = _scrollLeft - 100.0 * dt * (250 - my) / 100
          elseif my > 386 then
            _scrollLeft = _scrollLeft - 100.0 * dt * (386 - my) / 100
          end

          _scrollLeft = _scrollLeft < 0 and 0 or _scrollLeft > count * 35 - 332 and count * 35 - 332 or _scrollLeft
        end

        for k, o in pairs(_loc.objectives) do
          if 153.5 + k * 35 - _scrollLeft > 118 then
            if (mx > 41 and mx < 322) and (my > 153.5 + (k - 1) * 35 - _scrollLeft and
                my < 153.5 + (k - 1) * 35 + 32 - _scrollLeft) then
              _hover = k

              if released then
                _selected = k
              end
            end
          end

          if 153.5 + k * 35 - _scrollLeft > 522 then break end
        end

      elseif (mx > 391 and mx < 986) and (my > 179 and my < 445) then

        if my < 279 then
          _scrollRight = _scrollRight - 100.0 * dt * (279 - my) / 100
        elseif my > 345 then
          _scrollRight = _scrollRight - 100.0 * dt * (345 - my) / 100
        end

      elseif my > 456 and my < 486 then

        local duitWidth = getTextBounds(small, o.done == 1 and _loc.reduIt or _loc.duIt)
        duitWidth = min(240, duitWidth) + 32

        if (mx > 986 - duitWidth and mx < 986) then
          _hover = -2

          if released then
            local output = string.format('{trigger="%s"}', o.trigger or 'nil')
            logMessage('DEBUG : PRINT TRIGGER IN OUTPUT "' .. output .. '"')
            setOutput(output)
          end
        end

      elseif my > 530 and my < 560 then

        local backWidth = getTextBounds(small, '< ' .. _loc.back)
        backWidth = min(240, backWidth) + 32

        if (mx > 39 and mx < 39 + backWidth) then
          _hover = -3

          if released then
            _menu = 'HOME'
            _page = nil
            _init = false
          end
        end

      end

      requestAnimationFrame(1)
    end
  end

  --#################################
  function Render()
    local rx, ry = getResolution()
    local mx, my = getCursor()
    local time = getTime()

    if _menu == 'STANDBY' then
      local rx2 = rx / 2

      local back = createLayer()
      local front = createLayer()
      local fore = createLayer()

      local mini = loadFont('Play', 16)
      local small = loadFont('Play', 18)
      local smallBold = loadFont('Play-Bold', 18)
      local medium = loadFont('Play', 20)
      local big = loadFont('Play', 38)

      local iconNoveanTech = loadImage('gui/common/images/novean_technologie.png')
      local iconFlex = loadImage('gui/screen_unit/img/decals/flex_icon.png')

      --Default style

      setBackgroundColor(15 / 255, 24 / 255, 29 / 255)

      setNextFillColor(front, 52 / 255, 71 / 255, 78 / 255, 0.75)
      addImage(front, iconFlex, -5, 170, 360, 360)

      setDefaultFillColor(back, Shape_Circle, 0, 0, 0, 0)
      setDefaultStrokeColor(back, Shape_Line, 0, 0, 0, 0.5)
      setDefaultShadow(back, Shape_Line, 6, 0, 0, 0, 0.5)
      setDefaultFillColor(back, Shape_Text, 183 / 255, 224 / 255, 241 / 255, 1)

      setDefaultFillColor(front, Shape_Box, 0.075, 0.125, 0.156, 1)
      setDefaultFillColor(front, Shape_Text, 0.710, 0.878, 0.941, 1)

      --Header

      addLine(back, 0, 112, rx, 112)
      addBox(front, 0, 12, rx, 100)

      setNextFillColor(front, 110 / 255, 166 / 255, 181 / 255, 1)
      addText(front, medium, string.format(_loc.subTitle, _loc.playerName), 44, 45)

      addText(front, big, _loc.title, 44, 85)

      --Body

      for k = 1, 2 do
        local t = 3 * (time + 0.25 * k)

        setNextStrokeWidth(back, 4 * (-sin(t)))
        setNextStrokeColor(back, 0.976, 0.831, 0.482, sin(t))
        addCircle(back, rx2, 300, 30 + (1 - cos(t)) * 40)
      end

      setNextFillColor(back, 0.976, 0.831, 0.482, 1)
      setNextTextAlign(back, AlignH_Center, AlignV_Middle)
      addText(back, medium, _loc.touchMe, rx2, 300)


      lines = wrap(small, _loc.description, 340)
      for k, l in pairs(lines) do
        local y = 483 + (k - 1 - (#lines - 1) / 2) * 20

        setNextTextAlign(back, AlignH_Right, AlignV_Baseline)
        addText(back, small, l, 981, y)
      end

      --Foot

      setNextTextAlign(front, AlignH_Center, AlignV_Baseline)
      addText(front, mini, _loc.touch2Launch, rx2, 550)

      --
      setNextStrokeColor(back, 46 / 255, 59 / 255, 65 / 255, 0.5)
      setNextShadow(back, 340, 46 / 255, 59 / 255, 65 / 255, 0.5)
      addLine(back, 0, 524, rx, 524)

      addLine(back, 0, 518, rx, 518)
      addBox(front, 0, 518, rx, 58)

      setNextFillColor(fore, 181 / 255, 224 / 255, 240 / 255, 1)
      addImage(fore, iconNoveanTech, 890, 520, 98, 44)

      --#################################
      return
    elseif _menu == 'HOME' then
      local rx2 = rx / 2

      local back = createLayer()
      local front = createLayer()
      local fore = createLayer()
      local over = createLayer()

      local mini = loadFont('Play', 12)
      local small = loadFont('Play', 14)
      local smallBold = loadFont('Play-Bold', 18)
      local big = loadFont('Play', 38)

      local iconNoveanTech = loadImage('gui/common/images/novean_technologie.png')
      local iconTrophee = loadImage('gui/screen_unit/img/decals/icon_trophee.png')

      setBackgroundColor(15 / 255, 24 / 255, 29 / 255)

      setDefaultFillColor(back, Shape_BoxRounded, 52 / 255, 71 / 255, 78 / 255, 0.75)
      setDefaultFillColor(back, Shape_Text, 181 / 255, 224 / 255, 240 / 255, 1)
      setDefaultStrokeColor(back, Shape_Line, 0, 0, 0, 0.5)
      setDefaultShadow(back, Shape_Line, 6, 0, 0, 0, 0.5)

      setDefaultFillColor(front, Shape_Box, 19 / 255, 32 / 255, 40 / 255, 1)

      setDefaultFillColor(front, Shape_BoxRounded, 249 / 255, 212 / 255, 123 / 255, 1)
      setDefaultFillColor(front, Shape_Image, 181 / 255, 224 / 255, 240 / 255, 1)
      setDefaultFillColor(front, Shape_Text, 0, 0, 0, 1)

      setDefaultFillColor(fore, Shape_Text, 0.710, 0.878, 0.941, 1)
      setDefaultFillColor(fore, Shape_Image, 0, 0, 0, 1)

      setDefaultFillColor(over, Shape_Image, 249 / 255, 212 / 255, 123 / 255, 1)

      --Header

      addLine(back, 0, 112, rx, 112)
      addBox(front, 0, 12, rx, 100)

      setNextFillColor(front, 110 / 255, 166 / 255, 181 / 255, 1)
      addText(front, small, _loc.subTitle, 44, 45)

      addText(fore, big, _loc.title, 44, 85)

      --Body
      addText(back, mini, _loc.categories, 40, 173)

      for k, p in pairs(_loc.menus) do
        local lines = wrap(smallBold, p.name, 130)

        local x, y = rx2 - 119 * (#_loc.menus - 1) / 2 + (k - 1) * 119, 290
        local img, imgW, imgH = loadImage(p.icon.path), p.icon.width, p.icon.height
        local imgScale = imgW <= imgH and 72 / imgH or 72 / imgW

        local layBack = _hover == k and front or back
        local layImg = _hover == k and fore or front
        local layText = _hover == k and front or fore

        addBoxRounded(layBack, x - 57.5, y - 112.5, 115, 275, 0)

        addImage(layImg, img, x - (imgW * imgScale) / 2, y - (imgH * imgScale) / 2, imgW * imgScale, imgH * imgScale)

        setDefaultTextAlign(layText, AlignH_Center, AlignV_Middle)
        for j,line in pairs(lines) do
          addText(layText, small, line, x, y + 60 + (j-1)*14)
        end
      end

      --Gradient
      setNextStrokeColor(back, 46 / 255, 59 / 255, 65 / 255, 0.5)
      setNextShadow(back, 340, 46 / 255, 59 / 255, 65 / 255, 0.5)
      addLine(back, 0, 524, rx, 524)

      --Foot

      --Back button
      local btnText = '< ' .. _loc.back
      local w = getTextBounds(small, btnText)
      w = min(240, w) + 32

      if _hover == -3 then
        setNextFillColor(fore, 73 / 255, 106 / 255, 118 / 255, 1)
      else
        setNextFillColor(fore, 52 / 255, 71 / 255, 78 / 255, 0.85)
      end
      addBox(fore, 39, 530, w, 30)

      if _hover == -3 then
        setNextFillColor(fore, 194 / 255, 234 / 255, 248 / 255, 1)
      end
      setNextTextAlign(fore, AlignH_Center, AlignV_Middle)
      addText(fore, small, getEllipsis(small, btnText, w), 39 + w * 0.5, 545)

      --Tooltip
      setNextTextAlign(fore, AlignH_Center, AlignV_Baseline)
      addText(fore, small, _tooltip, rx / 2, 550)

      setNextStrokeColor(back, 0, 0, 0, 0.5)
      setNextShadow(back, 6, 0, 0, 0, 0.5)
      addLine(back, 0, 518, rx, 518)

      addBox(front, 0, 518, rx, 58)

      setNextFillColor(fore, 181 / 255, 224 / 255, 240 / 255, 1)
      addImage(fore, iconNoveanTech, 890, 520, 98, 44)

      --#################################
      return
    elseif _menu == 'OBJECTIVES' then
      local mx, my = getCursor()

      local under = createLayer()
      local back = createLayer()
      local ground = createLayer()
      local front = createLayer()
      local fore = createLayer()
      local over = createLayer()

      local mini = loadFont('Play', 12)
      local small = loadFont('Play', 14)
      local smallBold = loadFont('Play-Bold', 18)
      local medium = loadFont('Play', 20)
      local big = loadFont('Play', 38)

      local iconNoveanTech = loadImage('gui/common/images/novean_technologie.png')
      local iconCheck = loadImage('gui/screen_unit/img/decals/icon_check.png')
      local iconArrow = loadImage('gui/screen_unit/img/decals/icon_arrow.png')
      local iconUncheck = loadImage('gui/screen_unit/img/decals/icon_uncheck.png')

      local imgCateg = { path = '', width = 224, height = 224 }
      for k, m in pairs(_localization['HOME'].menus) do
        if m.page == _page then
          imgCateg = m.icon
          break
        end
      end

      --Default style

      setBackgroundColor(7 / 255, 13 / 255, 16 / 255, 1)

      setDefaultFillColor(under, Shape_Box, 52 / 255, 71 / 255, 78 / 255, 0.85)

      setDefaultStrokeWidth(back, Shape_Line, 0)
      setDefaultStrokeColor(back, Shape_Line, 0, 0, 0, 0.5)
      setDefaultShadow(back, Shape_Line, 6, 0, 0, 0, 0.5)
      setDefaultFillColor(back, Shape_Text, 116 / 255, 162 / 255, 176 / 255, 1)

      setDefaultFillColor(ground, Shape_Box, 15 / 255, 24 / 255, 29 / 255, 1)
      setDefaultStrokeColor(ground, Shape_Line, 0, 0, 0, 0.5)
      setDefaultShadow(ground, Shape_Line, 6, 0, 0, 0, 0.5)
      setDefaultFillColor(ground, Shape_Text, 0.710, 0.878, 0.941, 1)

      setDefaultFillColor(front, Shape_Box, 0.075, 0.125, 0.156, 1)
      setDefaultFillColor(front, Shape_Text, 183 / 255, 224 / 255, 241 / 255, 1)

      setDefaultFillColor(fore, Shape_Box, 0.075, 0.125, 0.156, 1)
      setDefaultFillColor(fore, Shape_Text, 183 / 255, 224 / 255, 241 / 255, 1)
      setDefaultFillColor(fore, Shape_Image, 249 / 255, 212 / 255, 123 / 255, 1)

      --Header

      addLine(ground, 0, 112, rx, 112)
      addBox(front, 0, 12, rx, 100)

      setNextFillColor(front, 110 / 255, 166 / 255, 181 / 255, 1)
      setNextTextAlign(front, AlignH_Left, AlignV_Baseline)
      addText(front, small, _loc.subTitle, 72, 45)

      setNextTextAlign(front, AlignH_Left, AlignV_Baseline)
      addText(front, big, _loc.title, 72, 85)

      addImage(fore, iconArrow, 22, 46, 32, 32)

      local titleWidth = getTextBounds(big, _loc.title)
      local subtitleWidth = getTextBounds(small, _loc.subTitle)

      setNextRotation(fore, math.rad(180))
      addImage(fore, iconArrow, max(subtitleWidth, titleWidth) + 84, 46, 32, 32)


      --Background layer
      addBox(ground, 0, 0, rx, 152.5)
      addBox(ground, 0, 150.5, 38, 336)

      setNextFillColor(ground, 7 / 255, 13 / 255, 16 / 255, 1)
      addBox(ground, 39, 151, 326, 1)

      addBox(ground, 367, 152.5, 656, 27)
      addBox(ground, 367, 179.5, 24, 265)
      addBox(ground, 986, 179.5, 38, 265)

      addBox(ground, 367, 444.5, 656, 318.5)

      addBox(ground, 0, 486.5, rx, 89.5)

      setNextFillColor(ground, 7 / 255, 13 / 255, 16 / 255, 1)
      addBox(ground, 39, 485, 326, 1)

      setNextStrokeColor(ground, 46 / 255, 59 / 255, 65 / 255, 0.5)
      setNextShadow(ground, 340, 46 / 255, 59 / 255, 65 / 255, 0.5)
      addLine(ground, 0, 524, rx, 524)

      --List of objectives
      local count = #_loc.objectives
      local w, maxH = 322, count * 35

      if count > 9 then
        setNextFillColor(under, 0, 0, 0, 1)
        addBox(under, 357, 153.5, 6, 330)

        setNextFillColor(fore, 84 / 255, 122 / 255, 135 / 255, 1)
        addBox(fore, 357, 153.5 + _scrollLeft / maxH * 330, 6, 330 / maxH * 330)
        w = 313
      end


      addText(ground, mini, _loc.objectivesTitle, 40, 148)

      if mx > 39 and mx < 322 then
        if my < 250 and _scrollLeft > 1 then
          setNextStrokeColor(back, 0.976, 0.831, 0.482, 0.5)
          setNextShadow(back, 30, 0.976, 0.831, 0.482, 0.5)
          addLine(back, 139, 151, 265, 151)
        elseif my > 386 and _scrollLeft < maxH - 333 then
          setNextStrokeColor(back, 0.976, 0.831, 0.482, 0.5)
          setNextShadow(back, 30, 0.976, 0.831, 0.482, 0.5)
          addLine(back, 139, 486, 265, 486)
        end
      end

      for k, o in pairs(_loc.objectives) do

        if 153.5 + k * 35 - _scrollLeft > 118 then
          if _hover == k then
            setNextFillColor(under, 73 / 255, 106 / 255, 118 / 255, 1)
            setNextFillColor(back, 194 / 255, 234 / 255, 248 / 255, 1)
          elseif _selected == k then
            setNextFillColor(under, 0.976, 0.831, 0.482, 1)
            setNextFillColor(back, 0, 0, 0, 1)
          end

          addBox(under, 41, 153.5 + (k - 1) * 35 - _scrollLeft, w, 32)

          setNextTextAlign(back, AlignH_Left, AlignV_Middle)
          addText(back, mini, getEllipsis(mini, o.title, w - 47), 73.5, 169 + (k - 1) * 35 - _scrollLeft)

          if o.done == 1 then
            if _hover == k then
              setNextFillColor(back, 249 / 255, 212 / 255, 123 / 255, 1)
            elseif _selected == k then
              setNextFillColor(back, 0, 0, 0, 1)
            else
              setNextFillColor(back, 249 / 255, 212 / 255, 123 / 255, 1)
            end
          else
            if _hover == k then
              setNextFillColor(back, 194 / 255, 234 / 255, 248 / 255, 1)
            elseif _selected == k then
              setNextFillColor(back, 0, 0, 0, 1)
            else
              setNextFillColor(back, 116 / 255, 162 / 255, 176 / 255, 1)
            end
          end

          addImage(back, o.done == 1 and iconCheck or iconUncheck, 49, 169 + (k - 1) * 35 - 9 - _scrollLeft, 18, 18)
        end

        if 153.5 + k * 35 - _scrollLeft > 522 then break end
      end

      -- Description and buttons

      setNextFillColor(under, 52 / 255, 71 / 255, 78 / 255, 0.75)
      addBox(under, 391, 179.5, 595, 265)

      local img, imgW, imgH = loadImage(imgCateg.path), imgCateg.width, imgCateg.height
      local imgScale = imgW <= imgH and 196 / imgH or 196 / imgW

      setNextFillColor(front, 183 / 255, 224 / 255, 241 / 255, 0.10)
      addImage(front, img, 960 - (imgW * imgScale), 312 - (imgH * imgScale) / 2, imgW * imgScale, imgH * imgScale)


      addLine(back, 391, 179, 986, 179)
      addLine(back, 390, 179, 390, 444)

      addText(ground, mini, _loc.description, 393, 176)

      local o = _loc.objectives[_selected]

      setNextFillColor(ground, 1, 1, 1, 1)
      addText(ground, medium, getEllipsis(medium, o.title, 550), 393, 154)

      if o.done == 1 then
        setNextFillColor(front, 249 / 255, 212 / 255, 123 / 255, 1)
      else
        setNextFillColor(front, 116 / 255, 162 / 255, 176 / 255, 1)
      end
      addImage(front, o.done == 1 and iconCheck or iconUncheck, 954, 136, 32, 32)


      local lines = wrap(small, o.desc, 580)
      local w, maxH = 580, #lines * 17
      if maxH > 265 then
        w = 566
        lines = wrap(small, o.desc, 566)
        maxH = #lines * 17

        setNextFillColor(under, 0, 0, 0, 0.5)
        addBox(under, 977, 182.5, 6, 259)

        setNextFillColor(fore, 84 / 255, 122 / 255, 135 / 255, 1)
        addBox(fore, 977, 182.5 + _scrollRight / maxH * 255, 6, 255 / maxH * 255)

        _scrollRight = _scrollRight < 0 and 0 or _scrollRight > maxH - 255 and maxH - 255 or _scrollRight
      else
        _scrollRight = 0
      end


      if mx > 391 and mx < 986 then
        if my < 279 and _scrollRight > 1 then
          setNextStrokeColor(back, 0.976, 0.831, 0.482, 0.5)
          setNextShadow(back, 30, 0.976, 0.831, 0.482, 0.5)
          addLine(back, 491, 179, 886, 179)
        elseif my > 345 and _scrollRight < maxH - 266 then
          setNextStrokeColor(back, 0.976, 0.831, 0.482, 0.5)
          setNextShadow(back, 30, 0.976, 0.831, 0.482, 0.5)
          addLine(back, 491, 445, 886, 445)
        end
      end


      for k, line in pairs(lines) do
        local y = 200 + k * 17 - _scrollRight
        if y > 194 then
          addText(under, small, line, 402, y - 17)
        end

        if y > 456 then break end
      end


      --Du it button
      if o.duItButton == 1 then
        local btnText = o.done == 1 and _loc.reduIt or _loc.duIt
        local w = getTextBounds(small, btnText)
        w = min(240, w) + 32

        setNextFillColor(front, 249 / 255, 212 / 255, 123 / 255, 1)
        addBox(front, 986 - w, 456, w, 30)

        setNextFillColor(front, 0, 0, 0, 1)
        setNextTextAlign(front, AlignH_Center, AlignV_Middle)
        addText(front, small, getEllipsis(small, btnText, w), 986 - w * 0.5, 471) 
      end

      --Foot

      --Back button
      local btnText = '< ' .. _loc.back
      local w = getTextBounds(small, btnText)
      w = min(240, w) + 32

      if _hover == -3 then
        setNextFillColor(fore, 73 / 255, 106 / 255, 118 / 255, 1)
      else
        setNextFillColor(fore, 52 / 255, 71 / 255, 78 / 255, 0.85)
      end
      addBox(fore, 39, 530, w, 30)

      if _hover == -3 then
        setNextFillColor(fore, 194 / 255, 234 / 255, 248 / 255, 1)
      end
      setNextTextAlign(fore, AlignH_Center, AlignV_Middle)
      addText(fore, small, getEllipsis(small, btnText, w), 39 + w * 0.5, 545)

      --Tooltip
      setNextTextAlign(front, AlignH_Center, AlignV_Baseline)
      addText(front, small, _loc.tooltip, rx / 2, 550)

      addLine(ground, 0, 518, rx, 518)
      addBox(front, 0, 518, rx, 58)

      setNextFillColor(fore, 181 / 255, 224 / 255, 240 / 255, 1)
      addImage(fore, iconNoveanTech, 890, 520, 98, 44)

      --#################################
      return
    end
  end

end


Initialize()
Render()

--[[
local rx, ry = getResolution()

local wipLayer = createLayer()
local wipFont = loadFont('FiraMono', 20)

setNextFillColor(wipLayer, 0.976, 0.831, 0.482, 1)
addBox(wipLayer, 0, 576, rx, ry - 576)

setNextFillColor(wipLayer, 0, 0, 0, 1)
setNextTextAlign(wipLayer, AlignH_Center, AlignV_Middle)
addText(wipLayer, wipFont, "**Work In Progress", rx * 0.5, 576 + (ry - 576) * 0.5)
--]]
Compute()
