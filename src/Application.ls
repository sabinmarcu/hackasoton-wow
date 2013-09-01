class Application extends IS.Object
	~>
		do @baseSetup
		do @firstTimeInclude
		do @loadLibs
		do @fixStylesheets
		do @loadApplication

	baseSetup: ->
		AppInfo.displayname ?= AppInfo.name
		document.title = AppInfo.displayname
		do ->
			meta = document.createElement "meta"
			meta.setAttribute "name", "viewport"
			meta.setAttribute "content", "width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1"
			document.head.appendChild meta
			meta = document.createElement "link"
			meta.setAttribute "rel", "apple-touch-icon"
			meta.setAttribute "href", "icon.ico"
			document.head.appendChild meta
			meta = document.createElement "meta"
			meta.setAttribute "name", "apple-mobile-web-app-capable"
			meta.setAttribute "content", "yes"
			document.head.appendChild meta
			meta = document.createElement \link
			meta.set-attribute \rel, \icon
			meta.set-attribute \href, \icon.ico
			document.head.appendChild meta
	loadLibs: ->
		DepMan.lib "prelude"
		window <<< window.prelude
		DepMan.lib "jquery"
		window.Hammer = DepMan.lib "hammer"
		window.jwerty = (DepMan.lib "hotkeys").jwerty
		DepMan.lib "angular.min"
		DepMan.lib "QRCodeDraw"
		DepMan.stylesheet "font-awesome"
	firstTimeInclude: ~>
		window.DepMan = new ( require "classes/helpers/DependenciesManager" )
		window.Tester = new ( DepMan.helper "Tester")()
	fixStylesheets: ~>
		styles = window.getStylesheets!; fwstyles = $('#css-font-awesome')
		styles.innerHTML = styles.innerHTML.replace /\<\<INSERT OPEN SANS 300 WOFF HERE\>\>/g, DepMan.font "woff/opensans1"
		styles.innerHTML = styles.innerHTML.replace /\<\<INSERT OPEN SANS 400 WOFF HERE\>\>/g, DepMan.font "woff/opensans2"
		styles.innerHTML = styles.innerHTML.replace /\<\<INSERT ELECTROLIZE WOFF HERE\>\>/g, DepMan.font "woff/electrolize"
		styles.innerHTML = styles.innerHTML.replace /\<\<INSERT ROBOTO 100 WOFF HERE\>\>/g, DepMan.font "woff/roboto100"
		styles.innerHTML = styles.innerHTML.replace /\<\<INSERT ROBOTO 400 WOFF HERE\>\>/g, DepMan.font "woff/roboto400"
		regex = /[\"\']escape-nib - ([^;]*)[\"\']/gm; str = regex.exec styles.innerHTML
		while str and str.length
			styles.innerHTML = styles.innerHTML.replace str[0], str[1]
			str = regex.exec styles.innerHTML
		fwstyles.html (fwstyles.html().replace /\<\<INSERT FONTAWESOME EOT HERE\>\>/g, DepMan.font "eot/fontawesome-webfont")
		fwstyles.html (fwstyles.html().replace /\<\<INSERT FONTAWESOME TTF HERE\>\>/g, DepMan.font "ttf/fontawesome-webfont")
		fwstyles.html (fwstyles.html().replace /\<\<INSERT FONTAWESOME WOFF HERE\>\>/g, DepMan.font "woff/fontawesome-webfont")
		document.head.appendChild styles
	loadApplication: ~>
		angular.module AppInfo.displayname, []
		DepMan.helper "Runtime"
		window.Controller = DepMan.controller "Landing"
		angular.bootstrap document.body, [AppInfo.displayname]

module.exports = Application

