local qMenuBasePanel = {}

function qMenuBasePanel:Init()
  self:SetSize(gel.fw:resoloutionScale(500, 300))
  self:Center()

  -- Add additonal panels
  self:addBaseSheetPanel()
  self:createToolsPanel()
end

function qMenuBasePanel:addBaseSheetPanel()
  self.baseSheet = vgui.Create("DPropertySheet", self)
  self.baseSheet:Dock(FILL)

  self.basicSheets = {}
end

function qMenuBasePanel:addSheet(idOfSheet, vGuiPanel)
  self.basicSheets[idOfSheet] = vGuiPanel
  self.baseSheet:AddSheet(idOfSheet, self.basicSheets[idOfSheet], "icon16/bullet_wrench.png")
end

function qMenuBasePanel:createToolsPanel()
  self.toolsPanel = vgui.Create("Panel", self)

  self.toolsPanel.form = gel.fw:newForm(self.toolsPanel, {
    {
      categoryId = "Category",
      id = "genericAtrribute",
      name = "Generic Atrribute",
      type = "Generic",
      defaultValue = "Test",
    },
    {
      categoryId = "New Cat",
      id = "genericAtrribute2",
      name = "Generic Atrribute2",
      type = "Generic",
      defaultValue = "1",
    },
  })

  -- Any additional properties
  self:addSheet("Tools", self.toolsPanel)
end

vgui.Register("nz.Menu.qMenu", qMenuBasePanel, "EditablePanel")

gel.fw:newInterface("CreateMenu", "nz.Menu.qMenu")

hook.Add("OnSpawnMenuOpen", "SpawnMenuWhitelist", function()
  gel.fw:getInterface("CreateMenu"):Open()
end)


hook.Add("OnSpawnMenuClose", "bfdb", function()
  gel.fw:getInterface("CreateMenu"):Close()
end)