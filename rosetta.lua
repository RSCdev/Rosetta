module(..., package.seeall)

-- ==========================================================================================
--
-- Rosetta Language Class
-- 
-- Created by Graham Ranson of MonkeyDead Studios.
--
-- http://www.grahamranson.co.uk
-- http://www.monkeydeadstudios.com
--
-- 
-- Version: 1.0
-- 
-- Class is MIT Licensed
-- Copyright (C) 2011 MonkeyDead Studios - No Rights Reserved.
--
-- ==========================================================================================

require("Json")

local loadFileContents = function(file)
	local path = system.pathForFile( file, system.ResourcesDirectory )
	
	if path then
		local file = io.open( path, "r" )
	
		if file then -- nil if no file found
	   
			local contents = file:read( "*a" )
	   
		   	io.close( file )
	
			return contents
		else
			return nil
		end
	else
		return nil
	end
end

local decodeJsonData = function(data)
	if data then
		return Json.Decode(data)
	end
end

local loadSettings = function()

	local contents = loadFileContents("language.settings")

	local settings = decodeJsonData(contents)
	
	return settings
end

local loadLanguage = function(name)
	local contents = loadFileContents(name .. ".language")
	
	local language = decodeJsonData(contents)
	
	return language
end

function new()
	
	local self = {}
	
	self.languages = {}
	self.currentLanguage = nil
	self.supportedLanguages = {}
	
	function self:initiate()

		self.settings = loadSettings()
		
		-- loop through all specified languages loading up their files
		for i=1, #self.settings.languages, 1 do
			local name = self.settings.languages[i]
			local language = loadLanguage(name)
			
			-- only add it as a supported language if the language file exists
			if language then
				self.languages[name] = language
				self.supportedLanguages[#self.supportedLanguages] = name
			end
		end
		
		-- try to set the default language
		if self.settings.default then
			if self.languages[self.settings.default] then
				self:setCurrentLanguage(self.settings.default)
			end
		else
			print("Rosetta: No default language set in language.settings")
		end

	end
	
	-- Returns a list of all the supported languages
	function self:getSupportedLanguageNames()
		return self.supportedLanguages
	end
	
	-- Returns the language table the specified language
	function self:getLanguage(name)
		return self.languages[name]
	end
	
	-- Sets the current language to the one specified
	function self:setCurrentLanguage(name)
		
		local language = self:getLanguage(name)
		
		if language then
			self.currentLanguage = language
			self.currentLanguageName = name
		else
			print("Rosetta: Language not found: " .. name or "nil")
		end
		
	end
	
	-- Gets the current language
	function self:getCurrentLanguage()
		return self.currentLanguage
	end
	
	-- Gets the name of the current language
	function self:getCurrentLanguageName()
		return self.currentLanguageName
	end
	
	-- Gets a string from the current language or the one specified as the second argument
	function self:getString(stringName, languageName)
		
		local language = nil
		
		if languageName then
			language = self:getLanguage(languageName)
			
			if not language then -- if a language name has been passed in but language is null then the language isn't supported
				print("Rosetta: Language not supported: " .. languageName)
				
				return nil
			end
		else
			language = self.currentLanguage
		end
		
		if language then
			return language[stringName] or "NO STRING"
		else
			print("Rosetta: Current language not set via rosetta:setCurrentLanguage(name)")
		end
	end
	
	return self
	
end