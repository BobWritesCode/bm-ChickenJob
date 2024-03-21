Config = {

  -- DEBUG: Turn debug mode on (true/false)
  Debug = false,
  UseQBTarget = true,

  -- NOTIFY : Choice of notification system
  Notify = 'QB',                   -- Possible values: QB / okokNotify

  CaptureChance = 70,              -- 0-100 chance of catching a chicken on each dive
  SellPrice = math.random(10, 50), -- How much each package chicken sells for.
  CuttingUpChickenTime = 15000,    -- Progress bar time when butchering.
  PackagingChickenTime = 15000,    -- Progress bar time when packaging.
  SellingChickenTime = 15000,      -- Progress bar time when selling.

  Locations = {
    chickenFarm = {
      blipName = "Chicken Farm",
      coords = vector3(2388.37, 5045.8, 46.37),
      blipSprite = 126,
      blipDisplay = 4,
      blipScale = 0.6,
      blipColour = 46,
      PedModel = "a_m_m_farmer_01", -- If using QB-Target
      PedModelHeading = 228.9       -- If using QB-Target
    },
    chickenProcessing = {
      blipName = "Chicken Slaughter House",
      coords = vector3(-95.72, 6207.15, 31.03),
      blipSprite = 84,
      blipDisplay = 4,
      blipScale = 0.6,
      blipColour = 64,
    },
    chickenDealer = {
      blipName = "Chicken Dealer",
      coords = vector3(-186.04, -1432.3, 31.33),
      blipSprite = 615,
      blipDisplay = 4,
      blipScale = 0.6,
      blipColour = 64,
      PedModel = "a_m_m_hillbilly_01", -- If using QB-Target
      PedModelHeading = 117.07         -- If using QB-Target
    },
    cutting = {
      one = {
        coords = vector3(-95.72, 6207.15, 31.03),         -- Non QB-Target coords
        QBTargetCoords = vector3(-95.19, 6207.48, 31.03), -- Coords for QB-Targert
        A = 311.0,
        B = -94.87,
        C = 6207.008,
        D = 30.08,
        E = 45.0,
      },
      two = {
        coords = vector3(-100.52, 6202.48, 31.03),        -- Non QB-Target coords
        QBTargetCoords = vector3(-100.08, 6202.0, 31.03), -- Coords for QB-Targert
        A = 222.0,
        B = -100.39,
        C = 6201.56,
        D = 29.99,
        E = -45.0,
      },
    },
    packing = {
      {
        coords = vector3(-106.44, 6204.2, 31.02), -- Non QB-Target coords
        QBTargetCoords = vector3(-106.56, 6205.19, 31.02)
      },
      {
        coords = vector3(-104.20, 6206.45, 31.02), -- Non QB-Target coords
        QBTargetCoords = vector3(-104.53, 6207.18, 31.02)
      },
      {
        coords = vector3(-101.77, 6208.93, 31.02), -- Non QB-Target coords
        QBTargetCoords = vector3(-102.59, 6209.33, 31.02)
      },
      {
        coords = vector3(-99.59, 6210.97, 31.02), -- Non QB-Target coords
        QBTargetCoords = vector3(-100.45, 6211.65, 31.021)
      }
    }
  },


  -- REQUIREDITEMS: These are here incase you needed to save the items under a different name.
  RequiredItems = {
    alivechicken       = {
      Name = "alivechicken",
      Label = "alivechicken",
      Weight = 500,
      Type = "item",
      Image = "alivechicken.png",
      Unique = false,
      Useable = true,
      ShouldClose = true,
      Combinable = nil,
      Description = "For all the thirsty out there"
    },
    packagedchicken    = {
      Name = "packagedchicken",
      Label = "packagedchicken",
      Weight = 500,
      Type = "item",
      Image = "packagedchicken.png",
      Unique = false,
      Useable = true,
      ShouldClose = true,
      Combinable = nil,
      Description = "For all the thirsty out there"
    },
    slaughteredchicken = {
      Name = "slaughteredchicken",
      Label = "slaughteredchicken",
      Weight = 500,
      Type = "item",
      Image = "slaughteredchicken.png",
      Unique = false,
      Useable = true,
      ShouldClose = true,
      Combinable = nil,
      Description = "For all the thirsty out there"
    },
  },
  Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
  }
}
