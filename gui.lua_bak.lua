local addonName, addon = ...
local Reputable = addon.a

local version = GetAddOnMetadata(addonName, "Version") or 9999;

local playerFaction = UnitFactionGroup("player")

--local y = 0
local function openTab( menuBTN )
	--print( menuBTN.name )
	for k, v in pairs ( Reputable.guiTabs ) do
		--print( k, v)
		Reputable.gui[ k ]:Hide()
	end
	--Reputable.gui.main:SetHeight( 30 - Reputable.gui[ menuBTN.name ].y )
	Reputable.gui[ menuBTN.name ]:Show()
end

local function createSubTitle( frame, name, text, text2 )
	frame.y = frame.y - 10
	--local o = Reputable.gui.main
	frame[ "subtitle_" .. name ] = frame:CreateFontString(nil, frame, "GameFontNormal" )
	frame[ "subtitle_" .. name ]:SetText( text )
	frame[ "subtitle_" .. name ]:SetPoint("TOPLEFT", 10, frame.y )
	
	if text2 then
		frame[ "subtitle2_" .. name ] = frame:CreateFontString(nil, frame, "GameFontNormal" )
		frame[ "subtitle2_" .. name ]:SetText( text2 )
		frame[ "subtitle2_" .. name ]:SetPoint("TOPLEFT", 150, frame.y )
		frame[ "subtitle2_" .. name ]:SetScript("OnHyperlinkEnter", function(...) Reputable:OnHyperlinkEnter(...) end )
	end
	frame.y = frame.y - 20
end
local function createMenuBTN( frame, name, text )
	--frame.y = frame.y - 20
	--local o = Reputable.gui.main
	--frame[ "subtitle_" .. name ] = frame:CreateFontString(nil, frame, "GameFontWhiteSmall" )
	frame[ "menuBTN_" .. name ] = CreateFrame('Button', name, frame, "OptionsListButtonTemplate")
	frame[ "menuBTN_" .. name ].name = name
	frame[ "menuBTN_" .. name ]:SetText( text )
	frame[ "menuBTN_" .. name ]:SetNormalFontObject( "GameFontWhiteSmall" )
	frame[ "menuBTN_" .. name ]:SetPoint("TOPLEFT", 20, frame.y )
	--frame[ "subtitle_" .. name ]:SetScript("OnClick", function() print("foo") Reputable.gui.scrollFrameMain:SetScrollChild( Reputable.gui.dungeonsTBC ) end)
	frame[ "menuBTN_" .. name ]:SetScript("OnClick", openTab )
	frame.y = frame.y - 20
	
	--Reputable.gui.scrollFrameMain:SetScrollChild( Reputable.gui.dungeonsTBC );
end

--local function addString( frame, name, text )
--local function addString( cont[zoneInfo.cat], zoneInfo.abv, factionID )
--end

Reputable.guiTabs = {
	--home = {},
	dungeonsTBC = { title = "The Burning Crusade Dungeons", label = "Dungeons" },
}

function Reputable:createGUI()
	--print( "Reputable:createGUI() fired" )
	local menuW = 160
	
	Reputable.gui = CreateFrame("frame","ReputableGUI")
	local cont = Reputable.gui
	cont:SetBackdrop({
		  bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
		  edgeFile="Interface/Tooltips/UI-Tooltip-Border",
		  tile=1, tileSize=16, edgeSize=16,
		  insets={left=4, right=4, top=4, bottom=4}
	})
	cont:SetWidth(640)
	cont:SetHeight(420)
	cont:SetPoint("CENTER",UIParent)
	cont:EnableMouse(true)
	cont:SetMovable(true)
	cont:SetClampedToScreen( true )
	cont:SetResizable(true)
	cont:SetMinResize(180,100);
	cont:RegisterForDrag("LeftButton")
	cont:SetScript("OnDragStart", function(self) self:StartMoving() end)
	cont:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	cont:SetFrameStrata("FULLSCREEN_DIALOG")

	cont.closeBTN = CreateFrame("button","MyAddonButton", cont, "UIPanelButtonTemplate")
	cont.closeBTN:SetHeight(24)
	cont.closeBTN:SetWidth(26)
	cont.closeBTN:SetPoint("TOPRIGHT", cont, "TOPRIGHT", -5, -5)
	cont.closeBTN:SetText("X")
	cont.closeBTN:SetScript("OnClick", function(self) cont:Hide() end)
	
	cont.settingsBTN = CreateFrame("button","MyAddonButton", cont, "UIPanelButtonTemplate")
	cont.settingsBTN:SetHeight(24)
	cont.settingsBTN:SetWidth(60)
	cont.settingsBTN:SetPoint("RIGHT", cont.closeBTN, "LEFT", 0, 0)
	cont.settingsBTN:SetText("Options")
	cont.settingsBTN:SetScript("OnClick", function(self)  cont:Hide(); InterfaceOptionsFrame_OpenToCategory(addonName);InterfaceOptionsFrame_OpenToCategory(addonName) end)
	
	cont.resizeBTN = CreateFrame("Button", nil, cont)
	cont.resizeBTN:SetSize(16, 16)
	cont.resizeBTN:SetPoint("BOTTOMRIGHT")
	cont.resizeBTN:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	cont.resizeBTN:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	cont.resizeBTN:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	cont.resizeBTN:SetScript("OnMouseDown", function(self, button)
		cont:StartSizing("BOTTOMRIGHT")
		cont:SetUserPlaced(true)
	end)
	cont.resizeBTN:SetScript("OnMouseUp", function(self, button)
		cont:StopMovingOrSizing()
	end)
		
	cont.title = cont:CreateFontString(nil, cont, "GameFontNormalLarge" )
	cont.title:SetText(addonName)
	cont.title:SetPoint("TOPLEFT",10,-10)
	
	cont.version = cont:CreateFontString(nil, cont, "GameFontDisable" )
	cont.version:SetText( "(v" .. version ..")" )
	cont.version:SetPoint("LEFT", cont.title, "RIGHT",5,0)
	
	cont.headerLine = cont:CreateLine()
	cont.headerLine:SetColorTexture(1,1,1,0.5)
	cont.headerLine:SetThickness(1)
	cont.headerLine:SetStartPoint("TOPLEFT",4,-32)
	cont.headerLine:SetEndPoint("TOPRIGHT",-4,-32)
	
	cont.menuLine = cont:CreateLine()
	cont.menuLine:SetColorTexture(1,1,1,0.5)
	cont.menuLine:SetThickness(1)
	cont.menuLine:SetStartPoint("TOPLEFT",menuW + 25,-32)
	cont.menuLine:SetEndPoint("BOTTOMLEFT",menuW + 25,3)
	
	cont.scrollFrameMenu = CreateFrame( "ScrollFrame", "$parent_ScrollFrame", cont, "UIPanelScrollFrameTemplate" );
	--cont.scrollFrameMenu:SetHeight(200)
	cont.scrollBar = _G[cont.scrollFrameMenu:GetName() .. "ScrollBar"];
	cont.scrollFrameMenu:SetWidth( menuW );
	cont.scrollFrameMenu:SetPoint( "TOPLEFT", 0, -35 );
	--cont.scrollFrameMenu:SetPoint( "BOTTOMRIGHT", -30, 10 );
	cont.scrollFrameMenu:SetPoint( "BOTTOM", 0, 10 );

	cont.menu = CreateFrame( "Frame", "$parent_ScrollChild", cont.scrollFrameMenu );
	cont.menu.y = 0
	cont.menu:SetWidth( cont.scrollFrameMenu:GetWidth() );
	cont.menu:SetAllPoints( cont.scrollFrameMenu );
	cont.scrollFrameMenu:SetScrollChild( cont.menu );
	
	createSubTitle( cont.menu, "menuTBC", "The Burning Crusade" )
	
	cont.scrollFrameMain = CreateFrame( "ScrollFrame", "$parent_ScrollFrame", cont, "UIPanelScrollFrameTemplate" );
	--cont.scrollFrameMain:SetHeight(200)
	cont.scrollBar = _G[cont.scrollFrameMain:GetName() .. "ScrollBar"];
	--cont.scrollFrameMain:SetWidth( 200);
	cont.scrollFrameMain:SetPoint( "TOPLEFT", menuW + 25, -35 );
	cont.scrollFrameMain:SetPoint( "BOTTOMRIGHT", -30, 10 );

	cont.main = CreateFrame( "Frame", "$parent_ScrollChild", cont.scrollFrameMain );
	cont.main.y = 0
	cont.main:SetWidth( cont.scrollFrameMain:GetWidth() );
	cont.main:SetAllPoints( cont.scrollFrameMain );
	cont.scrollFrameMain:SetScrollChild( cont.main );
	--cont.scrollFrameMain:SetScrollChild( cont.menu );
	
	--[[
	cont.home = CreateFrame( "frame", "home", cont.main );
	cont.home.y = 0
	cont.home:SetWidth( cont.scrollFrameMain:GetWidth() );
	cont.home:SetHeight(200)
	cont.home:SetAllPoints( cont.main );
	--]]
	for k, v in pairs ( Reputable.guiTabs ) do
		--print( k, v)
		--Reputable.gui[ k ]:Hide()
		
		cont[k] = CreateFrame( "frame", k, cont.main );
		cont[k].y = 0
		cont[k]:SetWidth( cont.scrollFrameMain:GetWidth() );
		cont[k]:SetHeight(200)
		cont[k]:SetAllPoints( cont.main );
		--cont[k]:SetScript("OnHyperlinkEnter", function(...) Reputable:OnHyperlinkEnter(...) end )
		createSubTitle( cont[k], k, v.title )
		
		createMenuBTN( cont.menu, k, v.label )
	end
	
	for zone, zoneInfo in pairs ( Reputable.instanceZones ) do
		local factionID = zoneInfo.faction
		if type(factionID) == 'table' then factionID = zoneInfo.faction[ playerFaction ] end
		local factionLink = "|Hreputable:faction:" .. factionID .. "|h[" .. factionID .. "]|h"
		createSubTitle( cont[zoneInfo.cat], zoneInfo.abv, zone, factionLink )
		--addString( cont[zoneInfo.cat], zoneInfo.abv, factionID ) 
	end
	
	--main:SetHeight( 30 - main.y );
	cont.main:SetHeight( 200 );
	cont.menu:SetHeight( 30 - cont.menu.y );
	
	
	openTab( { name = 'dungeonsTBC' } )
end

function Reputable:toggleGUI()
	if Reputable.gui == nil then
		Reputable:createGUI()
	elseif Reputable.gui:IsVisible() then
		Reputable.gui:Hide()
	else
		Reputable.gui:Show()
	end
end