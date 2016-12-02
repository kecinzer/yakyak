module.exports = view (models) ->
	div class:'listheadlabel', ->
		if process.platform isnt 'darwin'
			button title:'Menu', onclick:togglemenu, ->
				i class:'material-icons', "menu"
		span "Konverzace"

togglemenu = ->
	if process.platform isnt 'darwin'
		action 'togglemenu'
