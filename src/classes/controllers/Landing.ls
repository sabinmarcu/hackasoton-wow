const STATES = [\open \closed]; States = new IS.Enum STATES
const PAGES = [\home \demo]; Pages = new IS.Enum PAGES

class LandingController extends IS.Object
	~> @render!
	init: (@scope, @runtime) ~> 
		@config-scope!

	config-scope: ~>
		@safeApply = (fn) ~>
			phase = @scope.$parent.$$phase
			if phase is "$apply" or phase is "$digest"
				if fn and (typeof(fn) is 'function')
					do fn
			else @scope.$apply(fn)
		@scope <<< @

	read-more: ~>
		unless window.location.toString!indexOf('#about') >= 0
			window.location = window.location + '#about'

	render: ~> 
		let body = document.body
			@sidebar-status = States.closed
			@active-tab = Pages.home
			body.setAttribute "ng-controller", "Landing"
			body.setAttribute "ng-class", "sidebarStatus"
			body.innerHTML = DepMan.render "index", States: States, Pages: PAGES
		window.addEventListener "mousemove", @move
		window.addEventListener "touchmove", @move
	toggle: ~> 
		@scope.sidebar-status = switch @scope.sidebar-status
		| 0 => 1
		| 1 => 0
		@safeApply!
	change-active-tab: ~>
		@scope.active-tab = it
		@scope.sidebar-status = States.closed
		@safe-apply!
	move: ~>
		point =  it.touches?[0].clientX or it.clientX
		if point < 50 then @scope.sidebar-status = States.open; @safe-apply!
		else if point >= window.innerHeight / 2 and @scope.sidebar-status is States.open then @scope.sidebar-status = States.closed; @safe-apply!


	height: (style) ~> switch style
	| \login => height: window.innerHeight - 300 + "px"
	| \full => height: window.innerHeight + "px"

Controller = new LandingController()
angular.module AppInfo.displayname .controller "Landing", ["$scope", "Runtime", Controller.init]
module.exports = Controller
