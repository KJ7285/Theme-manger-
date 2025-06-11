local httpService = game:GetService('HttpService')
local ThemeManager = {}

do
    ThemeManager.Folder = 'LinoriaLibSettings'
    ThemeManager.Library = nil

    ThemeManager.BuiltInThemes = {
        ['Default']        = { 1, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"0055ff","BackgroundColor":"141414","OutlineColor":"323232"}') },

        ['PinkDream']      = { 2, httpService:JSONDecode('{"FontColor":"4a004a","MainColor":"ffc0cb","AccentColor":"ff69b4","BackgroundColor":"fff0f5","OutlineColor":"ff1493"}') },
        ['DarkDesire']     = { 3, httpService:JSONDecode('{"FontColor":"ffeaf0","MainColor":"3b002c","AccentColor":"8b0055","BackgroundColor":"1e0017","OutlineColor":"ad0066"}') },
        ['ToxicNight']     = { 4, httpService:JSONDecode('{"FontColor":"00ff00","MainColor":"0a0a0a","AccentColor":"39ff14","BackgroundColor":"050505","OutlineColor":"007f0e"}') },
        ['SunsetBlaze']    = { 5, httpService:JSONDecode('{"FontColor":"fff5e1","MainColor":"ff4500","AccentColor":"ff6347","BackgroundColor":"330000","OutlineColor":"ff3300"}') },
        ['Frostbite']      = { 6, httpService:JSONDecode('{"FontColor":"e0ffff","MainColor":"1c1f26","AccentColor":"00ffff","BackgroundColor":"0f1117","OutlineColor":"3a4b57"}') },
        ['MidnightPurple'] = { 7, httpService:JSONDecode('{"FontColor":"d8bfff","MainColor":"2a003f","AccentColor":"8000ff","BackgroundColor":"1b002b","OutlineColor":"5e00a3"}') },
        ['Sandstorm']      = { 8, httpService:JSONDecode('{"FontColor":"332200","MainColor":"f4e2d8","AccentColor":"d2b48c","BackgroundColor":"c19a6b","OutlineColor":"8b5a2b"}') },
        ['MidnightRain']   = { 9, httpService:JSONDecode('{"FontColor":"a0c4ff","MainColor":"10162a","AccentColor":"4d648d","BackgroundColor":"070a12","OutlineColor":"2e3e5c"}') },
        ['NeonSynth']      = {10, httpService:JSONDecode('{"FontColor":"00ffff","MainColor":"1a003f","AccentColor":"ff00ff","BackgroundColor":"0a001e","OutlineColor":"550055"}') },
        ['ForestDusk']     = {11, httpService:JSONDecode('{"FontColor":"d8f4dc","MainColor":"0a200a","AccentColor":"228b22","BackgroundColor":"041004","OutlineColor":"0d2a0d"}') },
        ['SolarFlare']     = {12, httpService:JSONDecode('{"FontColor":"000000","MainColor":"ffdf00","AccentColor":"ffb300","BackgroundColor":"333300","OutlineColor":"666600"}') },
        ['DeepSea']        = {13, httpService:JSONDecode('{"FontColor":"aaffff","MainColor":"001f3f","AccentColor":"0074d9","BackgroundColor":"001022","OutlineColor":"003358"}') },
        ['EmberAsh']       = {14, httpService:JSONDecode('{"FontColor":"ffc4c4","MainColor":"1b1b1b","AccentColor":"e25822","BackgroundColor":"0f0f0f","OutlineColor":"441111"}') },
        ['ArcticWind']     = {15, httpService:JSONDecode('{"FontColor":"001f3f","MainColor":"e0f7fa","AccentColor":"81d4fa","BackgroundColor":"b2ebf2","OutlineColor":"4dd0e1"}') },
        ['RetroGame']      = {16, httpService:JSONDecode('{"FontColor":"00ff00","MainColor":"0b0b0b","AccentColor":"14ff00","BackgroundColor":"060606","OutlineColor":"0f2f0f"}') },
        ['VampireBloody']  = {17, httpService:JSONDecode('{"FontColor":"ffcccc","MainColor":"2a0000","AccentColor":"8b0000","BackgroundColor":"100000","OutlineColor":"550000"}') },
        ['GalaxyBurst']    = {18, httpService:JSONDecode('{"FontColor":"f0f8ff","MainColor":"1a0b3b","AccentColor":"7f00ff","BackgroundColor":"0b0415","OutlineColor":"150824"}') },
    }

    function ThemeManager:ApplyTheme(theme)
        local customTheme = self:GetCustomTheme(theme)
        local data = customTheme or self.BuiltInThemes[theme]
        if not data then return end
        for key, hex in pairs(data[2]) do
            self.Library[key] = Color3.fromHex(hex)
            if Options[key] then Options[key]:SetValueRGB(Color3.fromHex(hex)) end
        end
        self:ThemeUpdate()
    end

    function ThemeManager:ThemeUpdate()
        for _, key in ipairs{"FontColor","MainColor","AccentColor","BackgroundColor","OutlineColor"} do
            if Options and Options[key] then
                self.Library[key] = Options[key].Value
            end
        end
        self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor)
        self.Library:UpdateColorsUsingRegistry()
    end

    function ThemeManager:LoadDefault()
        local theme = 'Default'
        local path = self.Folder..'/themes/default.txt'
        if isfile(path) then
            local saved = readfile(path)
            if self.BuiltInThemes[saved] then theme = saved
            elseif self:GetCustomTheme(saved) then theme = saved end
        end
        Options.ThemeManager_ThemeList:SetValue(theme)
    end

    function ThemeManager:SaveDefault(theme)
        writefile(self.Folder..'/themes/default.txt', theme)
    end

    function ThemeManager:CreateThemeManager(box)
        box:AddLabel('Background color'):AddColorPicker('BackgroundColor',{Default=self.Library.BackgroundColor})
        box:AddLabel('Main color')      :AddColorPicker('MainColor',{Default=self.Library.MainColor})
        box:AddLabel('Accent color')    :AddColorPicker('AccentColor',{Default=self.Library.AccentColor})
        box:AddLabel('Outline color')   :AddColorPicker('OutlineColor',{Default=self.Library.OutlineColor})
        box:AddLabel('Font color')      :AddColorPicker('FontColor',{Default=self.Library.FontColor})

        local names = {}
        for name in pairs(self.BuiltInThemes) do table.insert(names,name) end
        table.sort(names, function(a,b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

        box:AddDivider()
        box:AddDropdown('ThemeManager_ThemeList',{Text='Theme list',Values=names,Default=1})
        box:AddButton('Set as default',function()
            self:SaveDefault(Options.ThemeManager_ThemeList.Value)
            self.Library:Notify(("Default ➔ %q"):format(Options.ThemeManager_ThemeList.Value))
        end)

        Options.ThemeManager_ThemeList:OnChanged(function()
            self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
        end)

        box:AddDivider()
        box:AddInput('ThemeManager_CustomThemeName',{Text='Custom theme name'})
        box:AddDropdown('ThemeManager_CustomThemeList',{Text='Custom themes',Values=self:ReloadCustomThemes(),AllowNull=true,Default=1})

        box:AddButton('Save theme',function()
            self:SaveCustomTheme(Options.ThemeManager_CustomThemeName.Value)
            Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
            Options.ThemeManager_CustomThemeList:SetValue(nil)
        end):AddButton('Load theme',function()
            self:ApplyTheme(Options.ThemeManager_CustomThemeList.Value)
        end)

        box:AddButton('Refresh list',function()
            Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
            Options.ThemeManager_CustomThemeList:SetValue(nil)
        end)

        box:AddButton('Set as default',function()
            local sel = Options.ThemeManager_CustomThemeList.Value
            if sel and sel ~= '' then
                self:SaveDefault(sel)
                self.Library:Notify(("Default ➔ %q"):format(sel))
            end
        end)

        self:LoadDefault()
        for _,k in ipairs{"BackgroundColor","MainColor","AccentColor","OutlineColor","FontColor"} do
            Options[k]:OnChanged(function() self:ThemeUpdate() end)
        end
    end

    function ThemeManager:GetCustomTheme(name)
        local f = self.Folder..'/themes/'..name..'.json'
        if not isfile(f) then return nil end
        local ok,data = pcall(httpService.JSONDecode,httpService,readfile(f))
        return ok and data or nil
    end

    function ThemeManager:SaveCustomTheme(name)
        if name:match'^%s*$' then return self.Library:Notify('Invalid name',3) end
        local t = {}
        for _,k in ipairs{"FontColor","MainColor","AccentColor","BackgroundColor","OutlineColor"} do
            t[k] = Options[k].Value:ToHex()
        end
        writefile(self.Folder..'/themes/'..name..'.json', httpService:JSONEncode(t))
    end

    function ThemeManager:ReloadCustomThemes()
        local out = {}
        for _,f in ipairs(listfiles(self.Folder..'/themes')) do
            if f:sub(-5)=='.json' then
                out[#out+1] = f:match'([^\\/]+)%.json$'
            end
        end
        return out
    end

    function ThemeManager:SetLibrary(lib) self.Library = lib end

    function ThemeManager:BuildFolderTree()
        local paths, parts = {}, self.Folder:split('/')
        for i=1,#parts do paths[i] = table.concat(parts,'/',1,i) end
        paths[#paths+1] = self.Folder..'/themes'; paths[#paths+1] = self.Folder..'/settings'
        for _,p in ipairs(paths) do if not isfolder(p) then makefolder(p) end end
    end

    function ThemeManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function ThemeManager:CreateGroupBox(tab)
        assert(self.Library,'Need to set library')
        return tab:AddLeftGroupbox('Themes')
    end

    function ThemeManager:ApplyToTab(tab)
        self:CreateThemeManager(self:CreateGroupBox(tab))
    end

    function ThemeManager:ApplyToGroupbox(box)
        self:CreateThemeManager(box)
    end

    ThemeManager:BuildFolderTree()
end

return ThemeManager
