-- Load Rosetta
local rosetta = require("rosetta").new()

-- Initiate Rosetta - this will load all languages and settings
rosetta:initiate()

-- Print the value of "hello" from the current language (currently it is specified in language.settings as default)
print(rosetta:getString("hello"))

-- Change the language to french
rosetta:setCurrentLanguage("french")

-- Now print out hello again but in french
print(rosetta:getString("hello"))

-- Print out hello in german without changing the language
print(rosetta:getString("hello", "german"))