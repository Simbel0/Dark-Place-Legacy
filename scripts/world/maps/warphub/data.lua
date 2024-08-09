return {
  version = "1.5",
  luaversion = "5.1",
  tiledversion = "2021.03.23",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 23,
  height = 24,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 11,
  nextobjectid = 107,
  properties = {
    ["border"] = "glow",
    ["music"] = "warphub",
    ["name"] = "Warp Hub"
  },
  tilesets = {
    {
      name = "castle",
      firstgid = 1,
      filename = "../../tilesets/castle.tsx",
      exportfilename = "../../tilesets/castle.lua"
    },
    {
      name = "whitespace",
      firstgid = 61,
      filename = "../../tilesets/whitespace.tsx",
      exportfilename = "../../tilesets/whitespace.lua"
    },
    {
      name = "city_alleyway",
      firstgid = 70,
      filename = "../../tilesets/city_alleyway.tsx",
      exportfilename = "../../tilesets/city_alleyway.lua"
    },
    {
      name = "space",
      firstgid = 385,
      filename = "../../tilesets/space.tsx"
    },
    {
      name = "warphub_doors",
      firstgid = 397,
      filename = "../../tilesets/warphub_doors.tsx",
      exportfilename = "../../tilesets/warphub_doors.lua"
    },
    {
      name = "devroom-objects",
      firstgid = 457,
      filename = "../../tilesets/devroom-objects.tsx",
      exportfilename = "../../tilesets/devroom-objects.lua"
    },
    {
      name = "warp_bin",
      firstgid = 511,
      filename = "../../tilesets/warp_bin.tsx",
      exportfilename = "../../tilesets/warp_bin.tsx"
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 9,
      name = "objects_bg",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 103,
          name = "entry",
          type = "",
          shape = "point",
          x = 845.455,
          y = -339.394,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 10,
      name = "objects_doors",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 93,
          name = "",
          type = "",
          shape = "rectangle",
          x = 70,
          y = 360,
          width = 102,
          height = 80,
          rotation = 0,
          gid = 476,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 23,
      height = 24,
      id = 1,
      name = "tiles",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 17, 0, 0, 388, 389, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 17, 47, 0, 388, 389, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 47, 0, 388, 389, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 385, 386, 386, 389, 389, 389, 386, 386, 386, 386, 386, 386, 387, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 0, 0, 0, 0, 0,
        0, 385, 386, 386, 386, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 386, 386, 386, 387, 0,
        0, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 0,
        0, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 0,
        0, 391, 392, 392, 392, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 392, 392, 392, 393, 0,
        0, 394, 395, 395, 395, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 395, 395, 395, 396, 0,
        0, 394, 395, 395, 395, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 395, 395, 395, 396, 0,
        0, 394, 395, 395, 395, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 395, 395, 395, 396, 0,
        0, 394, 395, 395, 395, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 395, 395, 395, 396, 0,
        0, 394, 395, 395, 395, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 395, 395, 395, 396, 0,
        0, 394, 395, 395, 395, 388, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 389, 390, 395, 395, 395, 396, 0,
        0, 394, 395, 395, 395, 391, 392, 392, 392, 392, 392, 392, 392, 392, 392, 392, 392, 393, 395, 395, 395, 396, 0,
        0, 394, 395, 395, 395, 394, 395, 395, 395, 395, 395, 395, 395, 395, 395, 395, 395, 396, 395, 395, 395, 396, 0,
        0, 394, 395, 395, 395, 394, 395, 395, 395, 395, 395, 395, 395, 395, 395, 395, 395, 396, 395, 395, 395, 396, 0,
        0, 394, 395, 395, 395, 394, 395, 395, 395, 395, 395, 395, 395, 395, 395, 395, 395, 396, 395, 395, 395, 396, 0,
        0, 394, 395, 395, 395, 394, 395, 395, 395, 395, 395, 395, 395, 395, 395, 395, 395, 396, 395, 395, 395, 396, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 23,
      height = 24,
      id = 2,
      name = "decal",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 439, 440, 441, 0, 0, 0, 0, 439, 440, 441, 439, 440, 441, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 445, 446, 447, 0, 0, 0, 0, 445, 446, 447, 445, 446, 447, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 451, 452, 453, 0, 0, 0, 456, 451, 452, 453, 451, 452, 453, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 298, 298, 298, 0, 0, 0, 0, 298, 298, 298, 298, 298, 298, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 439, 440, 441, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 445, 446, 447, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 456, 451, 452, 453, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 298, 298, 298, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 291, 292, 293, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 511, 512, 513, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "collision",
      visible = true,
      opacity = 0.5,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 58,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 120,
          width = 240,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 61,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 260,
          width = 120,
          height = 100,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 63,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 20,
          width = 240,
          height = 100,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 64,
          name = "",
          type = "",
          shape = "rectangle",
          x = 760,
          y = 260,
          width = 120,
          height = 100,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 70,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 0,
          width = 40,
          height = 360,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 72,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 280,
          width = 40,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 73,
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 520,
          width = 160,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 74,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 560,
          width = 40,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 75,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 800,
          width = 600,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 76,
          name = "",
          type = "",
          shape = "rectangle",
          x = 720,
          y = 520,
          width = 40,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 77,
          name = "",
          type = "",
          shape = "rectangle",
          x = 760,
          y = 520,
          width = 160,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 79,
          name = "",
          type = "",
          shape = "rectangle",
          x = 880,
          y = 320,
          width = 40,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 80,
          name = "",
          type = "",
          shape = "rectangle",
          x = 720,
          y = 0,
          width = 40,
          height = 360,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 81,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 0,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 98,
          name = "",
          type = "",
          shape = "rectangle",
          x = 760,
          y = 360,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 99,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 0,
          width = 120,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "markers",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 20,
          name = "spawn",
          type = "",
          shape = "point",
          x = 460,
          y = 600,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 84,
          name = "door1",
          type = "",
          shape = "point",
          x = 120,
          y = 400,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 104,
          name = "entry",
          type = "",
          shape = "point",
          x = 382,
          y = 72,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 27,
          name = "savepoint",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 560,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["text1"] = "* Another time,[wait:5] another place...",
            ["text2"] = "* The power of tourism shines within you."
          }
        },
        {
          id = 43,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 410,
          y = 480,
          width = 110,
          height = 90,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "warp_bin",
            ["solid"] = true
          }
        },
        {
          id = 45,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 390,
          y = 280,
          width = 140,
          height = 60,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "warphub.warp_codes",
            ["solid"] = true
          }
        },
        {
          id = 46,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 320,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["cutscene"] = "warphub.spamgolor",
            ["solid"] = true
          }
        },
        {
          id = 54,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 500,
          y = 80,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* This room appears to be for rent.",
            ["text2"] = "* But,[wait:10] you don't know how to rent it."
          }
        },
        {
          id = 55,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 620,
          y = 80,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* This room appears to be for rent.",
            ["text2"] = "* But,[wait:10] you don't know how to rent it."
          }
        },
        {
          id = 92,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 360,
          width = 120,
          height = 120,
          rotation = 0,
          gid = 470,
          visible = true,
          properties = {}
        },
        {
          id = 97,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 780,
          y = 320,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* This room appears to be for rent.",
            ["text2"] = "* But,[wait:10] you don't know how to rent it."
          }
        },
        {
          id = 102,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 320,
          y = -40,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "diamondwarproom",
            ["marker"] = "entry"
          }
        },
        {
          id = 105,
          name = "npc",
          type = "",
          shape = "rectangle",
          x = 680,
          y = 760,
          width = 40,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["actor"] = "you_plush",
            ["cutscene"] = "plushies.you_plush",
            ["flagcheck"] = "!you_plush"
          }
        },
        {
          id = 106,
          name = "interactable",
          type = "",
          shape = "rectangle",
          x = 220,
          y = 80,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["solid"] = true,
            ["text1"] = "* This room appears to be for rent.",
            ["text2"] = "* But,[wait:10] you don't know how to rent it."
          }
        }
      }
    }
  }
}
